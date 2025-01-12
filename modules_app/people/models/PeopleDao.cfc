component displayname="PeopleDao" accessors="true" extends="base.models.dao" singleton {

	package people.models.PeopleDao function init() {
		return this;
	}

	/**
	 * Check for record existence by id
	 *
	 * @referenceBean people.models.PeopleBean     The Parked Order bean pre-populated with the data
	 *
	 * @return boolean
	 */
	package boolean function exists(required people.models.PeopleBean referenceBean) {
		
		// TODO: BEGIN TESTING - REMOVE WHEN UPDATING FROM TEMPLATE
		return true;
		// END TESTING

		return queryExecute("
				SELECT id
				FROM person
				WHERE id = :id
			",
			{id = {cfsqltype = "integer", value = arguments.referenceBean.getId()}},
			{datasource = getDsn()}
		).recordCount;
	}

	 /**
	 * Populate a person bean with the details of a specific record
	 *
	 * @referenceBean people.models.PeopleBean     I am the person bean pre-populated with person data
	 *
	 */
	package void function read(required people.models.PeopleBean referenceBean) {

		// TODO: BEGIN TESTING - REMOVE WHEN UPDATING FROM TEMPLATE
		arguments.referenceBean.setId(999999);
		arguments.referenceBean.setFirstName('Test');
		arguments.referenceBean.setLastName('Admin');
		arguments.referenceBean.setEmail('admin@coldbox.org');
		arguments.referenceBean.setPasswordHash('myPasswordIsWeak');
		arguments.referenceBean.setSalt('salt');
		return;
		// END TESTING

		var result = queryExecute("
				SELECT
					id,
					d_email,
					d_password_hash,
					d_salt,
					d_first_name,
					d_last_name,
					d_is_active
				FROM person
				WHERE
					(:Id IS NOT NULL AND id = :id)
					OR (:email IS NOT NULL AND d_email = :email)
			",
			{
				id = { cfsqltype="integer", value="#arguments.referenceBean.getId()#", null = (!arguments.referenceBean.getId() GT 0)},
				email = { cfsqltype="varchar", value="#arguments.referenceBean.getEmail()#", null = (!arguments.referenceBean.getEmail().len())}
			},
			{datasource = getDsn()}
		);

		if (result.recordCount) {
			arguments.referenceBean.setId(result.id);
			arguments.referenceBean.setFirstName(result.d_first_name);
			arguments.referenceBean.setLastName(result.d_last_name);
			arguments.referenceBean.setEmail(result.d_email);
			arguments.referenceBean.setPasswordHash(result.d_password_hash);
			arguments.referenceBean.setSalt(result.d_salt);
		}
	}
}
