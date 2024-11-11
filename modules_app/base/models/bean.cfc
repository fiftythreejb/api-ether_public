component output="false" displayname="base.bean" accessors="true"  {
	
	/**
	* @displayname  getPrimaryKey
	* @description  I return the primary key of the bean that extends this bean
	* @return		string
	*/
	public string function getPrimaryKey() {
		var primaryKey = '';
		var metaProperty = '';

		// get component metadata from the cache
		var metaData = getMetaData( this );

		// loop through the components properties
		for( metaProperty in metaData.properties ) {
			// check if the 'primary' attribute is set on this property and is true
			if( structKeyExists( metaProperty, 'primary' ) and metaProperty.primary ) {
				// it does, set the primary key value to this properties name
				primaryKey = metaProperty.name;
				break;
			}
		}

		// return the primary key name
		return primaryKey;
	}
}