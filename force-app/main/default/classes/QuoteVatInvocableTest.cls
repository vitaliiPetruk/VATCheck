@IsTest
private class QuoteVatInvocableTest {

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
	public static void testInvocableQuoteUpdate() {
		Test.setMock(HttpCalloutMock.class, new MockHandler(TestDataFactory.RESPONSE_JSON, 200));
		Quote q = TestDataFactory.createQuote();
		q.OpportunityId = [SELECT Id FROM Opportunity LIMIT 1].Id;
		Assert.isNull(q.VAT_Rate__c);

		List<QuoteVatInvocable.Requests> requestList = new List<QuoteVatInvocable.Requests>();
		QuoteVatInvocable.Requests request = new QuoteVatInvocable.Requests();
		request.quoteRecord = q;
		requestList.add(request);

		Test.startTest();
		List<QuoteVatInvocable.Results> results = QuoteVatInvocable.updateQuote(requestList);
		Test.stopTest();

		Assert.areNotEqual(null,results[0].quoteRecordResult.VAT_Rate__c);
		Assert.areEqual(20,results[0].quoteRecordResult.VAT_Rate__c);

	}

}