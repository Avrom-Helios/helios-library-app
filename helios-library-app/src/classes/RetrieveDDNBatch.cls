global class RetrieveDDNBatch implements Database.Batchable<Book__c>, Database.AllowsCallouts {
    //public for testing
    public static String BASE_CLASSIFY_URL = 'http://classify.oclc.org/classify2/Classify?';
    
    global Iterable<Book__c> start(Database.BatchableContext BC) {
        return [SELECT id, isbn__c, ddn__c, title__c, author_last_name__c, author_first_name__c
                FROM Book__c
                WHERE ddn__c = null
               AND Location__r.Main_location__r.Uses_Dewey_Decimal_Coding__c = true];
    }
    
    global void execute(Database.BatchableContext bc, List<Book__c> books) {
        Http theHttp = new Http();
        List<Book__c> toUpdate = new List<Book__c>();
        for (Book__c book : books) {
            //books here always have null ddn
            String ddn = null;
            String isbn = book.isbn__c;
            
            if (isbn != null) {
                HttpRequest req = new HttpRequest();
                req.setMethod('GET');
                req.setEndpoint(BASE_CLASSIFY_URL + 'isbn=' + isbn + '&summary=true');
                ddn = processOclcRecord(docallout(theHttp, req));
            }
            if (ddn == null) {
                //Try again by title and name

                String author = EncodingUtil.urlEncode(book.Author_Last_Name__c + 
                                                       ', ' + book.Author_First_Name__c, 
                                                       'UTF-8');
                String title = EncodingUtil.urlEncode(book.Title__c, 'UTF-8');
                HttpRequest req = new HttpRequest();
                req.setMethod('GET');
                req.setEndpoint(BASE_CLASSIFY_URL + 'author=' + author +
                                '&title=' + book.Title__c + '&summary=true');
                ddn = processOclcRecord(docallout(theHttp, req));
            }
            if (ddn != null) {
                book.DDN__c = ddn.substring(0, Math.min(10, ddn.length()));
                toUpdate.add(book);
            }
        }
        update toUpdate;
    }
    
    private HttpResponse doCallout(Http theHttp, HttpRequest request) {
        //Stupid and awful, but Apex won't respect mocks on batch requests so we have to do it here.
        if (Test.isRunningTest()) {
            return new OCLCMock().respond(request);
        }
        return theHttp.send(request);
    }
    
    private String processOclcRecord(HttpResponse response) {
        XmlStreamReader reader = response.getXmlStreamReader();
        boolean inDDCSection = false;
        while (reader.hasNext()) {
            XmlTag event = reader.getEventType();
            if (event == XmlTag.START_ELEMENT) {
                if ('ddc'.equals(reader.getLocalName())) {
                    inDDCSection = true;
                } else if (inDDCSection && 'mostPopular'.equals(reader.getLocalName())) {
                    String providedVal = reader.getAttributeValue(null, 'sfa');
                    //If is test fails, still don't return null immediately; there can
                    //be multiple "most popular" DDNs
                    if (providedVal != null) {
                        //Oy, isNumeric won't work with decimal points!?
                        String[] parsedProvidedVal = providedVal.trim().split('\\.');
                        if (parsedProvidedVal.size() == 1 || parsedProvidedVal.size() == 2) {
                            boolean rightFormat = true;
                            for (String part : parsedProvidedVal) {
                                if (!part.trim().isNumeric()) {
                                    rightFormat = false;
                                    break;
                                }
                            }
                            if (rightFormat) {
                                return providedVal.trim();
                            }
                        }
                        
                        
                    }
                }
            } else if (event == XmlTag.END_ELEMENT) {
                if ('ddc'.equals(reader.getLocalName())) {
                    inDDCSection = false;
                }
            }
            reader.next();
        }
        return null;
    }
    
    global void finish(Database.BatchableContext bc) {
        
    }

}