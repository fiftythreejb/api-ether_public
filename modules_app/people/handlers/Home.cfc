/**
 * The main module handler
 */
component extends="coldbox.system.RestHandler" accessors="true" {

	property name="people" inject="peopleService@people";

	/**
	 * Module EntryPoint
	 */
	function index( event, rc, prc ) secured {
		event.getResponse().setData('Person Profile');
	}

}
