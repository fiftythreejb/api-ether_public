/**
* The base model test case will use the 'model' annotation as the instantiation path
* and then create it, prepare it for mocking and then place it in the variables scope as 'model'. It is your
* responsibility to update the model annotation instantiation path and init your model.
*/
component extends="coldbox.system.testing.BaseModelTest" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		variables.model = prepareMock(getInstance('modTemplate.handlers.ModTemplate'));

		// setup the model
		super.setup();

		// init the model object
		// model.init();
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "ModTemplate Suite", function(){
			
			it( "can be created", function(){
				expect(model).toBeComponent();
			} );
			
			it( "has handler logic", function(){
				$assert.skip(message = 'use a handler unit test to hit logic not covered in the service unit test');
			} );
		});

	}

}
