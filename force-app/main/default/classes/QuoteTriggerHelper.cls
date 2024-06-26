public inherited sharing class QuoteTriggerHelper {

	/**
	 * Updates VAT data based on the customer's country when a record is created or updated
	 */
	@Future(Callout=true)
	static public void vatUpdate(Set<Id> quoteIds) {
		Map<String, VatService.VatWrapper> vatWrapper = new VatService().getVAT();
		List<Quote> quotesToUpdate = [SELECT Id, Client_Country__c, VAT_Rate__c, Price__c FROM Quote WHERE Id = :quoteIds];
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
				if(quote.Price__c != null ){
					quote.Price_With_VAT__c = quote.Price__c * (1 + vatWrapper.get(quote.Client_Country__c).standard / 100);
				}
			}
			update internationalQuotes;
		}
	}
}
