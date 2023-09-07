public with sharing class QuoteVatInvocable {
	@InvocableMethod(Label='Update VAT data' Description='Use for update field value on VAT Rate')
	public static List<Results> updateQuote(List<Requests> requestList) {
		Map<String, VatService.VatWrapper> wrapperMap = new VatService().getVAT();
		List<Results> toReturn = new List<Results>();


		for (Requests requestItem : requestList) {
			Results results = new Results();
			if (String.isBlank(requestItem.quoteRecord.Client_Country__c) == false &&
					wrapperMap.containsKey(requestItem.quoteRecord.Client_Country__c)) {

				requestItem.quoteRecord.VAT_Rate__c = wrapperMap.get(requestItem.quoteRecord.Client_Country__c).standard;
				results.quoteRecordResult = requestItem.quoteRecord;
				toReturn.add(results);
			}
		}
		return toReturn;
	}

	public class Requests {
		@InvocableVariable public Quote quoteRecord;
	}

	public class Results {
		@InvocableVariable public Quote quoteRecordResult;
	}

}
