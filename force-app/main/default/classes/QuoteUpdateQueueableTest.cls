@IsTest
private class QuoteUpdateQueueableTest {

	@TestSetup
	public static void setupTestData() {
		Account testAccount = TestDataFactory.createAccount();
		insert testAccount;

		Opportunity testOpportunity = TestDataFactory.createOpportunity();
		testOpportunity.AccountId = testAccount.Id;
		insert testOpportunity;

		API__c myCustomSetting = TestDataFactory.createApi();
		insert myCustomSetting;
	}

	@IsTest
	public static void testQuoteUpdateQueueable() {
		Test.setMock(HttpCalloutMock.class, new MockHandler(TestDataFactory.RESPONSE_JSON, 200));

		List<Quote> quotesToUpdate = new List<Quote>();
		Quote q = TestDataFactory.createQuote();
		q.OpportunityId = [SELECT Id FROM Opportunity LIMIT 1].Id;
		insert q;
		quotesToUpdate.add(q);


		Test.startTest();
		Id queueableJobID = System.enqueueJob(new QuoteUpdateQueueable(quotesToUpdate));
		Test.stopTest();

		Quote afterUpdate = [SELECT Id, VAT_Rate__c FROM Quote LIMIT 1];
		Assert.areEqual(20, afterUpdate.VAT_Rate__c);

		AsyncApexJob job = [SELECT Status FROM AsyncApexJob WHERE Id = :queueableJobID];
		Assert.areEqual('Completed', job.Status);
	}

}