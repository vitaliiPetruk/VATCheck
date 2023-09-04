public with sharing class QuoteUpdateBatchHelper {

	static public void batchVATUpdate(List<Quote> quotes) {
		try {
			Map<String, VatService.VatWrapper> vatWrapper = new VatService().getVAT();

			if (quotes.isEmpty() == false) {
				for (Quote quote : quotes) {
					if (vatWrapper.containsKey(quote.Client_Country__c)) {
						quote.VAT_Rate__c = vatWrapper.get(quote.Client_Country__c).standard;
					}
				}
				update quotes;
			}

		} catch (Exception e) {
			System.debug(String.format('{0}\n{1}', new Object[]{
					e.getMessage(), e.getStackTraceString()
			}));
		}
	}
}
