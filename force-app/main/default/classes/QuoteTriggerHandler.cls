public with sharing class QuoteTriggerHandler {

	@Future(Callout=true)
	static public void updateVAT(Set<Id> quoteIds) {
		List<Quote> quotesToUpdate = [SELECT Id, Client_Country__c, VAT_Rate__c FROM Quote WHERE Id =: quoteIds ];
		List<Quote> internationalQuotes = new List<Quote>();

		for (Quote quote : quotesToUpdate) {
			if (!String.isBlank(quote.Client_Country__c)) {
				internationalQuotes.add(quote);
			}
		}

		if (!internationalQuotes.isEmpty()) {
			for (Quote quote : internationalQuotes) {
				// Make an HTTP request to the VAT API
				VatService.VatWrapper vatWrapper = new VatService().getVAT(quote.Client_Country__c);

				Decimal vatRate = vatWrapper.standard;

				// Update the Quote object with the fetched VAT data
				quote.VAT_Rate__c = vatRate;
			}
		}
		update internationalQuotes;

	}

}




