@IsTest
public with sharing class TestDataFactory {
	public static final String RESPONSE_JSON = '{ "status": 200, "message": "success", "rate_type": "GOODS", "countries": { "AT": { "country": "Austria", "rates": { "standard": 20, "reduced_1": 13, "reduced_2": 10, "super_reduced": null, "parking": 13 } } } }';

	public static Account createAccount() {
		Account testAcc = new Account();
		testAcc.Name = 'Test Account';

		return testAcc;
	}

	public static Opportunity createOpportunity() {
		Opportunity testOpportunity = new Opportunity();
		testOpportunity.Name = 'Test Opportunity';
		testOpportunity.StageName = 'Prospecting';
		testOpportunity.CloseDate = Date.today() + 30;

		return testOpportunity;
	}

	public static Quote createQuote() {
		Quote testQuote = new Quote();
		testQuote.Name = 'TestQuote';
		testQuote.Client_Country__c = 'AT';

		return testQuote;
	}

	public static API__c createApi() {
		API__c testApi = new API__c();
		testApi.API_Key__c = '12345';

		return testApi;
	}

}