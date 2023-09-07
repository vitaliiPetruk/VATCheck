public with sharing class QuoteUpdateQueueable implements Queueable, Database.AllowsCallouts {
	/**
		  * if you need to call it from a trigger use this one.
		  * System.enqueueJob(new QuoteUpdateQueueable(Trigger.new));
	*/
	private List<Quote> quotesToUpdate = new List<Quote>();

	public QuoteUpdateQueueable(List<Quote> quotesToUpdate) {
		this.quotesToUpdate = quotesToUpdate;
	}

	public void execute(QueueableContext context) {
		Map<String, VatService.VatWrapper> vatWrapper = new VatService().getVAT();
		List<Quote> internationalQuotesQueueable = new List<Quote>();

		for (Quote quote : quotesToUpdate) {
			if (String.isBlank(quote.Client_Country__c) == false) {
				Quote afterUpdateQ = new Quote(Id = quote.Id, Client_Country__c = quote.Client_Country__c);
				internationalQuotesQueueable.add(afterUpdateQ);
			}
		}

		if (internationalQuotesQueueable.isEmpty() == false) {
			for (Quote quote : internationalQuotesQueueable) {
				if (vatWrapper.containsKey(quote.Client_Country__c)) {
					quote.VAT_Rate__c = vatWrapper.get(quote.Client_Country__c).standard;
				}
			}
			update internationalQuotesQueueable;
		}
	}

}
