/**
 * Class runs every day at 00:05 AM.
 * <br>
 * <br>
 * String sch = '0 5 0 * * ?';
 * <br>
 *	String jobID = System.schedule('Update VAT rate every day at 00:05 AM.', sch, new QuoteUpdateBatchSchedulable());
 */
global with sharing class QuoteUpdateBatchSchedulable implements Schedulable  {
	global void execute(SchedulableContext sc) {
		QuoteUpdateBatch quoteUpdateBatch = new QuoteUpdateBatch();
		database.executebatch(quoteUpdateBatch);
	}
}