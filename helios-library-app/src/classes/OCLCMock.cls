@IsTest
global class OCLCMock implements System.HttpCalloutMock {
    global System.HttpResponse respond(System.HttpRequest req) {
        System.assertEquals('GET', req.getMethod());
        String url = req.getEndpoint();
        System.assert(url.startsWith(RetrieveDDNBatch.BASE_CLASSIFY_URL),
                     'Unexpected endpoint ' + url + ' did not start with '
                     + RetrieveDDNBatch.BASE_CLASSIFY_URL);
        StaticResource oclcResponseBody;
        if (url.contains('isbn')) {
           System.assertEquals(RetrieveDDNBatchTest.EXPECTED_ISBN_URL_DECODED, 
                               EncodingUtil.urlDecode(url, 'UTF-8')); 
            oclcResponseBody = [SELECT body FROM StaticResource WHERE name = 'TestIsbnOclcResponse'];
            
        } else {
            System.assertEquals(RetrieveDDNBatchTest.EXPECTED_TITLE_URL_DECODED, 
                               EncodingUtil.urlDecode(url, 'UTF-8'));
            oclcResponseBody = [SELECT body FROM StaticResource WHERE name = 'TestAuthorTitleOclcResponse'];
        }
        System.HttpResponse res = new System.HttpResponse();
        res.setStatusCode(200);
        res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        res.setBody(oclcResponseBody.Body.toString());
        return res;
    }
}