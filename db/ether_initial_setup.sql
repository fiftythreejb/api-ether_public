/*********************************************
-- Author:		Justin Burmeister
-- Create date: March 15, 2022
-- Description:	Initial DB creation and tables
*********************************************/

SET NOCOUNT OFF;
GO

PRINT CONVERT(varchar(1000), @@VERSION);
GO

PRINT '';
PRINT N'***Started - ' + CONVERT(varchar, GETDATE(), 121);
GO

USE master 
GO 

-- =================================================== 
-- Drop the database if it already exists then create
-- =================================================== 

PRINT '';
PRINT N'*** Dropping Database';
GO

DROP DATABASE IF EXISTS Ether 
GO

-- If the database has any other open connections close the network connection.
IF @@ERROR = 3702 
    RAISERROR('!! Ether database cannot be dropped because there are still other open connections', 20, 1) WITH NOWAIT, LOG;
GO

-- Drop Previous user
IF EXISTS (SELECT * FROM sys.database_principals WHERE name = N'CFUser')
	DROP USER CFUser
GO

IF EXISTS (SELECT * FROM sys.server_principals WHERE name = N'CFlogin')
	DROP LOGIN CFlogin
GO

DROP ROLE IF EXISTS db_execproc
GO


CREATE DATABASE Ether
GO

IF DB_ID('Ether') IS NOT NULL
	BEGIN
		PRINT N'*** We journey into the Ether'
	END
ELSE
	BEGIN
		RAISERROR ('!! Ether DB not created', 1, 2);
		--GOTO BatchEnd -- (not working - outside of block) This will skip over the script and go to Skipper
	END
GO


/********************************************* 
-- Base tables 
*********************************************/ 
USE ETHER 
GO 

PRINT '';
PRINT N'***Create base tables';
GO

	SET ANSI_NULLS ON -- only during creation to ensure proper ISO index creation
	GO
	SET QUOTED_IDENTIFIER ON -- ensure ISO rules for " and ' character use is fallowed
	GO

	/* ----------------------- 
		people
	----------------------- */
		PRINT '';
		PRINT N'***Started - People';
		GO
	
		-- User: base user object
		CREATE TABLE dbo.Person(
			PersonID int IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED,
			FirstName varchar(80) NULL,
			LastName varchar(100) NULL,
			Email varchar(150) NULL,
			Created datetime NULL DEFAULT GETDATE(),
			CreatedBy int NULL FOREIGN KEY REFERENCES Person(PersonID),
			StatusAID int NULL FOREIGN KEY REFERENCES AttributeList(AttributeListID),
			MiddleName varchar(80) NULL,
			BirthMonth tinyint NULL,
			BirthDay tinyint NULL,
			EmergencyContact varchar(100) NULL,
			EmergencyPhone varchar(30) NULL,
			Bio varchar(5000) NULL
		);
		GO

	/* ----------------------- 
		Accounts
	----------------------- */
		PRINT '';
		PRINT N'***Started - Accounts';
		GO
	
		-- Account types to link people to permission
		CREATE TABLE dbo.PersonAccount(
			PersonAccountID int IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED,
			PersonID int NULL FOREIGN KEY REFERENCES Person(PersonID),
			UserIdentity varchar(300) NULL, -- user account ID at destination endpoint
			[Password] varchar(300) NULL, -- remove (no local password management)
			PasswordSalt varchar(300) NULL, -- remove (no local password management)
			PasswordResetKey varchar(300) NULL, -- remove (no local password management)
			StatusAID int NULL,
			Created datetime NULL DEFAULT GETDATE(),
			CreatedBy int NULL FOREIGN KEY REFERENCES Person(PersonID),
			Updated datetime NULL DEFAULT GETDATE(),
			UpdatedBy int NULL FOREIGN KEY REFERENCES Person(PersonID)
		);
		GO

		-- we don't want 2 different users using the same external account
		ALTER TABLE dbo.PersonAccount
  			ADD CONSTRAINT uq_PersonAccount UNIQUE(AccountPoolID, UserIdentity);
		GO

		EXEC sp_addextendedproperty 
			@name = 'MS_Description', @value = 'User account ID at destination endpoint.',
			@level0type = 'Schema', @level0name = 'dbo',
			@level1type = 'Table', @level1name = 'PersonAccount',
			@level2type = 'Column', @level2name = 'UserIdentity'
		;
		GO

		IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'DBO' AND  TABLE_NAME = 'Person')
			AND EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'DBO' AND  TABLE_NAME = 'PersonAccount')
		)
			BEGIN
				PRINT '';
				PRINT N'***People Structures Created'
			END
		ELSE
			BEGIN
				RAISERROR ('People Structures not created', 20, 4);
				--GOTO BatchRollback -- (Rollback) This will skip over the script and go to Skipper
			END
		GO
	
PRINT '';
PRINT N'***Completed - Table Creation';
GO
	


/********************************************* 
-- Base inserts 
*********************************************/ 

PRINT '';
PRINT N'*** Begin base inserts';
GO

/******************
	users
******************/

	-- Initial user
	SET IDENTITY_INSERT dbo.Person ON;

		INSERT INTO dbo.Person (PersonID, FirstName, LastName, Email, CreatedBy, StatusAID, MiddleName, BirthMonth, BirthDay, EmergencyContact, EmergencyPhone, Bio)
		VALUES (1, 'System', 'Account', null, null, 7, null, null, null, null, null, 'This is the default account for first login. Disable after initial setup.');

	SET IDENTITY_INSERT dbo.Person OFF;

/********************************************* 
-- Base Views 
*********************************************/ 

PRINT '';
PRINT N'*** Begin View Creation';
GO
	

/********************************************* 
-- Base procedures 
*********************************************/ 



/********************************************* 
-- Base SQL users 
*********************************************/ 
	-- login
	-- user
	-- permission
--USE ETHER 
	-- Create a database role and add a user to that role.
	CREATE ROLE db_execproc;

	CREATE LOGIN CFlogin WITH PASSWORD = '$changem3';

	
	CREATE user CFUser for login CFlogin;
	GO

/********************************************* 
-- Base permissions 
*********************************************/ 

	EXEC sp_addrolemember N'db_execproc', N'CFUser';
	GO

	-- deny permissions on cf for security
	--DENY SELECT, INSERT, UPDATE, DROP ON SCHEMA::dbo TO CFUser;
	DENY INSERT, UPDATE, DELETE ON SCHEMA::dbo TO CFUser;
	GO
/* Temp for testing
	USE ETHER 
	GRANT SELECT ON SCHEMA::dbo TO CFUser;
	GO
 */
	-- Grant EXECUTE permission at the schema level.
	GRANT EXECUTE ON SCHEMA::dbo TO db_execproc;
	GO



GOTO BatchEnd

BatchEnd: -- Don't do nuttin!