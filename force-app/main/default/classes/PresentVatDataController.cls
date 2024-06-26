public with sharing class PresentVatDataController {

	/**
	 * @return 0n a country basis reflects the current VAT rate
	 */
	@AuraEnabled
	public static VatService.VatWrapper getVatData(String quoteId) {
		Quote q = [SELECT Id, Client_Country__c FROM Quote WHERE Id = :quoteId LIMIT 1];
		Map<String, VatService.VatWrapper> vatWrappersByStrings = new VatService().getVAT();

		if (vatWrappersByStrings.containsKey(q.Client_Country__c)) {
			return vatWrappersByStrings.get(q.Client_Country__c);
		}

		return new VatService.VatWrapper();
	}

	/**
	 *  Accept quotaId and update data on record detail page
	 */
	@AuraEnabled
	public static void updateVatData(String quoteId) {
		Quote quoteToUpdate = [SELECT Id, Client_Country__c, VAT_Rate__c FROM Quote WHERE Id = :quoteId LIMIT 1];
		VatService.VatWrapper wrapper = getVatData(quoteId);

		if (wrapper != null) {
			quoteToUpdate.VAT_Rate__c = wrapper.standard;
			update quoteToUpdate;
		}
	}
}