@IsTest
private class PresentVatDataControllerTest {

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
	static void testGetVatData() {
		Test.setMock(HttpCalloutMock.class, new MockHandler(TestDataFactory.RESPONSE_JSON, 200));

		Quote testQuote = TestDataFactory.createQuote();
		testQuote.OpportunityId = [SELECT Id FROM Opportunity LIMIT 1].Id;
		insert testQuote;

		Test.startTest();
		VatService.VatWrapper result = PresentVatDataController.getVatData(testQuote.Id);
		Test.stopTest();

		Assert.areNotEqual(null, result);
		Assert.areEqual(20, result.standard);
	}

	@IsTest
	static void testNoDataFound() {
		Test.setMock(HttpCalloutMock.class, new MockHandler(TestDataFactory.RESPONSE_JSON, 200));

		Quote testQuote = TestDataFactory.createQuote();
		testQuote.OpportunityId = [SELECT Id FROM Opportunity LIMIT 1].Id;
		testQuote.Client_Country__c = 'BG';
		insert testQuote;

		Test.startTest();
		VatService.VatWrapper result = PresentVatDataController.getVatData(testQuote.Id);
		Test.stopTest();

		Assert.areNotEqual(testQuote.VAT_Rate__c, result.standard);
		Assert.areEqual(0, result.standard);
	}

	@IsTest
	static void testUpdateVatData() {
		Test.setMock(HttpCalloutMock.class, new MockHandler(TestDataFactory.RESPONSE_JSON, 200));

		Quote testQuote = TestDataFactory.createQuote();
		testQuote.OpportunityId = [SELECT Id FROM Opportunity LIMIT 1].Id;
		testQuote.VAT_Rate__c = 11;
		insert testQuote;

		Test.startTest();
		PresentVatDataController.updateVatData(testQuote.Id);
		Test.stopTest();

		Quote updatedQuote = [SELECT VAT_Rate__c FROM Quote WHERE Id = :testQuote.Id LIMIT 1];

		Assert.areNotEqual(11, updatedQuote.VAT_Rate__c);
		Assert.areEqual(20, updatedQuote.VAT_Rate__c);
	}

}