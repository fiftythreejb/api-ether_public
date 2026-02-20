component displayname="PeopleService" accessors="true" extends="base.models.service" singleton {

	property name="dao" type="People.models.PeopleDao" getter="false";
	property name="pepper" inject="coldbox:configSettings:pepper";

/************************
	PUBLIC
************************/

	public People.models.PeopleService function init() {
		return this;
	}

	/**
	* Return a Parked Order bean
	*
	* @return bean
	*/
	public People.models.PeopleBean function getBean() {
		return new People.models.PeopleBean();
	}

	/**
	 * Return a parked order by ID
	 * @id numeric 		The value for id
	 *
	 * @return bean
	 */
	public People.models.PeopleBean function loadById(required numeric id) {
		var bean = getBean();
		bean.setId(arguments.id);
		load(bean);
		return bean;
	}

	/**
	 * Return a parked order by email
	 * @id numeric 		The value for id
	 *
	 * @return bean
	 */
	public People.models.PeopleBean function loadByEmail(required string email) {
		var bean = getBean();
		bean.setEmail(arguments.email);
		load(bean);
		return bean;
	}

	public string function simpleHash(required string password, required string salt) {
		return hash(arguments.salt & arguments.password & pepper, "SHA-512", "utf-8");
	}

/************************
	PACKAGE
************************/
	/**
	 * I run a filtered query of all records within the parked order in the database
	 *
	 * @returnColumns string 				A list of the columns
	 * @id numeric					The primary key for the person record
	 * @email string						person email
	 * @email firstName						person first name
	 * @email lastName						person last name
	 * @isActive boolean					Is the parked record active
	 *
	 * @return query
	 */
	package query function filter(
		string returnColumns = "id,d_email,d_first_name,d_last_name,d_is_active",
		numeric id,
		string email,
		string firstName,
		string lastName,
		boolean isActive
	) {
		return getDao().filter(
			returnColumns = arguments.returnColumns,
			id = arguments.id,
			email  = arguments.email ,
			firstName = arguments.firstName,
			lastName = arguments.lastName,
			isActive = arguments.isActive
		);
	}

/****************
	Private
****************/
	/**
	 * Build a Dao object lazyily.
	 * The first time you call it, it will lock, build it, and store it by convention as 'variables.Dao'
	 */
	private People.models.PeopleDao function getDao(){
		if (!variables.keyExists('dao')) {
			setDao(new People.models.PeopleDao());
		}
		return variables.dao;
	}
}
