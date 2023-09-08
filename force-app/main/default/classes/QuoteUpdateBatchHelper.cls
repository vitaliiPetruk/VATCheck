public with sharing class QuoteUpdateBatchHelper {

	/**
	 * One callout is performed for a mass VAT update on Quote record
	 */
	static public void vatUpdate(List<Quote> quotes) {
		Map<String, VatService.VatWrapper> vatWrapper = new VatService().getVAT();

		if (quotes.isEmpty() == false) {
			for (Quote quote : quotes) {
				if (vatWrapper.containsKey(quote.Client_Country__c)) {
					quote.VAT_Rate__c = vatWrapper.get(quote.Client_Country__c).standard;
				}
			}
			update quotes;
		}
	}
}