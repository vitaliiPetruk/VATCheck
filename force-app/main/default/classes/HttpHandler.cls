public with sharing class HttpHandler {
	    public static HttpResponse doHTTPRequest(
	                String endpoint,
	                String method,
	                Map<String, String> UrlParams,
	                Map<String, String> headerParams,
	                Object bodyWrapperObject
	        ) {
	            HttpRequest request = new HttpRequest();
	            request.setEndpoint(endpoint);
	            request.setMethod(method);
	            request.setHeader('Content-Type', 'application/json');

	            if (headerParams != null && !headerParams.isEmpty()) {
	                for (String paramKey : headerParams.keySet()) {
	                    request.setHeader(paramKey, headerParams.get(paramKey));
	                }
	            }

	            if (bodyWrapperObject != null) {
	                request.setBody(JSON.serializePretty(bodyWrapperObject));
	            }

	            if (UrlParams != null && !UrlParams.isEmpty()) {
	                endpoint += '?';
	                for (String paramKey : UrlParams.keySet()) {
	                    endpoint += paramKey + '=' + UrlParams.get(paramKey) + '&';
	                }
	                endpoint = endpoint.removeEnd('&');
	                request.setEndpoint(endpoint);
	            }
	            HttpResponse response = new Http().send(request);
	            return response;
	        }

}
