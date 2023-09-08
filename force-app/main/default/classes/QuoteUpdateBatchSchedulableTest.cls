@IsTest
private class QuoteUpdateBatchSchedulableTest {

	@IsTest
	public static void testQuoteUpdateBatch() {
		String sch = '0 6 * * * ?';

		Test.startTest();
		String jobID = System.schedule('Update VAT rate every day at 00:05 AM.', sch, new QuoteUpdateBatchSchedulable());
		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
		Test.stopTest();

		Assert.areEqual(sch, ct.CronExpression);

		Assert.areEqual(0, ct.TimesTriggered);
	}

}
