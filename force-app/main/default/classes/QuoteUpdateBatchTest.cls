@IsTest
global class QuoteUpdateBatchTest {
	static String strJson = '{ "status": 200, "message": "success", "rate_type": "GOODS", "countries": { "AT": { "country": "Austria", "rates": { "standard": 20, "reduced_1": 13, "reduced_2": 10, "super_reduced": null, "parking": 13 } } } }';

	@TestSetup
	global static void setupTestData() {
		Account testAccount = TestDataFactory.createAccount();
		insert testAccount;

		Opportunity testOpportunity = TestDataFactory.createOpportunity();
		testOpportunity.AccountId = testAccount.Id;
		insert testOpportunity;

		API__c myCustomSetting = TestDataFactory.createApi();
		insert myCustomSetting;
	}

	@IsTest
	global static void testQuoteUpdateBatch() {

		Test.setMock(HttpCalloutMock.class, new MockHandler(strJson, 200));
		Quote q = TestDataFactory.createQuote();
		q.OpportunityId = [SELECT Id FROM Opportunity LIMIT 1].Id;
		insert q;

		Test.startTest();
		QuoteUpdateBatch batch = new QuoteUpdateBatch();
		Id batchJobId = Database.executeBatch(batch, 1);
		Test.stopTest();

		Quote afterUpdate = [SELECT Id, VAT_Rate__c FROM Quote LIMIT 1];
		Assert.areEqual(20, afterUpdate.VAT_Rate__c);

		// Verify that the batch job has completed
		AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJob WHERE Id = :batchJobId];
		Assert.areEqual('Completed', job.Status);
	}

	@IsTest
	global static void testQuoteUpdateBatchHelper() {
		Test.setMock(HttpCalloutMock.class, new MockHandler(strJson, 200));
		Quote q = TestDataFactory.createQuote();
		q.OpportunityId = [SELECT Id FROM Opportunity LIMIT 1].Id;
		insert q;

		Test.startTest();
		// Call the helper method
		QuoteUpdateBatchHelper.batchVATUpdate(new List<Quote>{q});
		Test.stopTest();

		Quote afterUpdate = [SELECT Id, VAT_Rate__c FROM Quote LIMIT 1];
		Assert.areEqual(20, afterUpdate.VAT_Rate__c);
	}
}
