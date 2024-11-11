/**
 * I manage modTemplate
 */
component singleton accessors="true" extends="base.models.service" displayname="ModTemplateService"{

	// Properties
	property name="dao" lazy; // coldbox lazy load of dao

/************************
	PUBLIC
************************/

	/**
	 * Constructor
	 * I return an ModTemplate bean
	 *
	 * @return modTemplate.models.ModTemplateService instance
	 */
	public modTemplate.models.ModTemplateService function init(){
		super.init();

		if( isNull( getModelCache() ) ) {
			setModelCache( new base.models.cache( entity = "modTemplateCache" ) );
		}
		return this;
	}

	/**
	 * I return an ModTemplate bean
	 *
	 * @return modTemplate.models.ModTemplateBean
	 */
	public modTemplate.models.ModTemplateBean function getBean() {
		return new modTemplate.models.ModTemplateBean();
	}

	/**
	 * I return an ModTemplate by ID
	 * @id numeric ?: The value for id
	 *
	 * @return modTemplate.models.ModTemplateBean
	 */
	public modTemplate.models.ModTemplateBean function loadById(required numeric id) {
		var bean = getBean();
		bean.setId(arguments.id);
		load(bean);
		return bean;
	}


/****************
	Private
****************/
	/**
	 * Build a Dao object lazyily, by convention.
	 * The first time you call it, it will lock, build it, and store it by convention as 'variables.dao'
	 */
	private function buildDao(){
		return new modTemplate.models.ModTemplateDao();
	}

}