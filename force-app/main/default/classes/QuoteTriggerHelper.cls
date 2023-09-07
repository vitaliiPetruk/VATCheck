public inherited sharing class QuoteTriggerHelper {

	@Future(Callout=true)
	static public void VATUpdate(Set<Id> quoteIds) {
		Map<String, VatService.VatWrapper> vatWrapper = new VatService().getVAT();
		List<Quote> quotesToUpdate = [SELECT Id, Client_Country__c, VAT_Rate__c FROM Quote WHERE Id = :quoteIds];
		List<Quote> internationalQuotes = new List<Quote>();


		for (Quote quote : quotesToUpdate) {
			if (String.isBlank(quote.Client_Country__c) == false) {
				internationalQuotes.add(quote);
			}
		}

		if (internationalQuotes.isEmpty() == false) {
			for (Quote quote : internationalQuotes) {
				if (vatWrapper.containsKey(quote.Client_Country__c)) {
					quote.VAT_Rate__c = vatWrapper.get(quote.Client_Country__c).standard;
				}
			}
			update internationalQuotes;
		}


	}
}
