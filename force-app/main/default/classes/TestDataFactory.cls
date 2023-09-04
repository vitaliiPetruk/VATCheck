@IsTest
public with sharing class TestDataFactory {

	public static Account createAccount() {
		Account testAcc = new Account(
				Name = 'Test Account'
		);
		return testAcc;
	}

	public static Opportunity createOpportunity() {
		Opportunity testOpportunity = new Opportunity(
				Name = 'Test Opportunity',
				StageName = 'Prospecting',
				CloseDate = Date.today() + 30// Set a future close date
		);
		return testOpportunity;
	}

	public static Quote createQuote() {
		Quote testQuote = new Quote(
				Name = 'TestQuote',
				Client_Country__c = 'AT'
		);

		return testQuote;
	}

	public static API__c createApi() {
		API__c testApi = new API__c(
				API_Key__c = '12345'
		);

		return testApi;
	}

}
