public inherited sharing class QuoteTriggerHelper {

	@Future(Callout=true)
	static public void VATUpdate(Set<String> quoteIds) {
		Map<String, VatService.VatWrapper> vatWrapper = new VatService().getVAT();
		List<Quote> quotesToUpdate = [SELECT Id, Client_Country__c, VAT_Rate__c FROM Quote WHERE Id = :quoteIds];
		List<Quote> internationalQuotes = new List<Quote>();


		for (Quote quote : quotesToUpdate) {
			if (!String.isBlank(quote.Client_Country__c)) {
				internationalQuotes.add(quote);
			}
		}

		if (!internationalQuotes.isEmpty()) {
			for (Quote quote : internationalQuotes) {
				if (vatWrapper.containsKey(quote.Client_Country__c)) {
					Decimal vatRate = vatWrapper.get(quote.Client_Country__c).standard;
					quote.VAT_Rate__c = vatRate;
				}
			}
			update internationalQuotes;
		}


	}
}
