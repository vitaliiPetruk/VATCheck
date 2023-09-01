public with sharing class VatService {
	final private static String API_KEY =  'A0SaO3gYUl72CijLYniYe7jLmNBo3ujP5R6wsvMd';
	final private static String ENDPOINT = 'https://global.vatapi.com/v2/vat-rate-check';

	public VatWrapper getVAT(String country_code) {
		Map<String, String> UrlParams = new Map<String, String>();
		Map<String, String> headerParams = new Map<String, String>();

		UrlParams.put('rate_type', 'GOODS');
		UrlParams.put('country_code', country_code);
		headerParams.put('x-api-key', API_KEY);

		HttpResponse httpResponse = HttpHandler.doHTTPRequest(ENDPOINT, 'GET', UrlParams, headerParams, null);
		System.debug(httpResponse.getBody());

		JSONParse body = new JSONParse(httpResponse.getBody());

		VatWrapper toReturn = new VatWrapper();
		toReturn.standard = body.get('rates.standard').getDecimalValue();
		toReturn.reduced_1 = body.get('rates.reduced_1').getDecimalValue();
		toReturn.reduced_2 = body.get('rates.reduced_2').getDecimalValue();
		toReturn.super_reduced = body.get('rates.super_reduced').getDecimalValue();
		toReturn.parking = body.get('rates.parking').getDecimalValue();
		toReturn.country_code = body.get('country_code').getStringValue();
		toReturn.message = body.get('message').getStringValue();
		toReturn.country = body.get('country').getStringValue();

		return toReturn;
	}

	public class VatWrapper {
		public String country_code = '';
		public String message = '';
		public String country = '';
		public Decimal standard = 0;
		public Decimal reduced_1 = 0;
		public Decimal reduced_2 = 0;
		public Decimal super_reduced = 0;
		public Decimal parking = 0;
	}
}
