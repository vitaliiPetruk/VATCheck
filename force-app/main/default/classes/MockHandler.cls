@IsTest
global with sharing class MockHandler  implements HttpCalloutMock {
	private String responseBody;
	private Integer statusCode;

	global HttpResponse respond(HttpRequest req) {
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
		res.setBody(responseBody);
		res.setStatusCode(statusCode);
		return res;
	}

	global MockHandler(final String responseBody, final Integer statusCode) {
		this.responseBody = responseBody;
		this.statusCode = statusCode;
	}
}