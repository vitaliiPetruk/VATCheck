public with sharing class VatService {
	final private static String endpoint = 'https://global.vatapi.com/v2/vat-rates';

	/**
	 * @return provides connection with endpoint to get actual VAT information for all countries
	 */
	public Map<String, VatWrapper> getVAT() {
		Map<String, String> UrlParams = new Map<String, String>();
		Map<String, String> headerParams = new Map<String, String>();

		API__c mySettings = API__c.getInstance();
		String apiKey = mySettings.API_Key__c;

		UrlParams.put('rate_type', 'GOODS');
		headerParams.put('x-api-key', apiKey);

		HttpResponse httpResponse
				= HttpHandler.doHTTPRequest(endpoint, 'GET', UrlParams, headerParams, null);

		Map<String, VatWrapper> toReturn = getVatMap(new JSONParse(httpResponse.getBody()));

		return toReturn;
	}

	private Map<String, VatWrapper> getVatMap(JSONParse body) {
		Map<String, VatWrapper> toReturn = new Map<String, VatWrapper>();
		Map<String, JSONParse> parseMap = body.get('countries').asMap();

		for (String str : parseMap.keySet()) {
			JSONParse jsonParse = parseMap.get(str);

			VatWrapper wrapper = new VatWrapper();
			wrapper.standard = jsonParse.get('rates.standard').getDecimalValue();
			wrapper.reduced_1 = jsonParse.get('rates.reduced_1').getDecimalValue();
			wrapper.reduced_2 = jsonParse.get('rates.reduced_2').getDecimalValue();
			wrapper.super_reduced = jsonParse.get('rates.super_reduced').getDecimalValue();
			wrapper.parking = jsonParse.get('rates.parking').getDecimalValue();
			wrapper.country = jsonParse.get('country').getStringValue();

			toReturn.put(str, wrapper);
		}

		return toReturn;
	}

	public class VatWrapper {
		@AuraEnabled
		public String country = '';
		@AuraEnabled
		public Decimal standard = 0;
		@AuraEnabled
		public Decimal reduced_1 = 0;
		@AuraEnabled
		public Decimal reduced_2 = 0;
		@AuraEnabled
		public Decimal super_reduced = 0;
		@AuraEnabled
		public Decimal parking = 0;
	}
}