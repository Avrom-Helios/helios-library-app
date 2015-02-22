public class BookSearchController {
    public String searchTerms {public get; public set;}
    public String copyNum {public get; public set;}
    
    public ApexPages.StandardSetController booksController {public get; private set;}
    public Book__c[] books {public get; private set;}
    
    public ApexPages.PageReference doSearch() {
         if (String.isBlank(searchTerms)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                                       'Please enter at least one search term.')
                                 );
            return null;
        }
        List<List<SObject>> results = [FIND :searchTerms IN ALL FIELDS RETURNING 
                                       Book__c(Id, Title__c, Author_display_name__c, Copyright_Date__c,
                                              Location__r.Full_Location__c, Dewey_Decimal_Code__c,
                                               Generally_Available_Copies__c, Newberry_Book__c)];
        books = results[0];
        booksController = new ApexPages.StandardSetController(books);
        return null;
    }
    
    public ApexPages.PageReference goToBook() {
        if (String.isBlank(copyNum)) {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                                       'Please enter a copy number.')
                                 );
            return null;
        }
        Book_copy__c[] copies = [Select Book__c from Book_Copy__c where Copy_Number__c = :copyNum];
        if (copies.size() == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                                       'No book copy with that number.')
                                 );
            return null;
        }
        
        System.assertEquals(copies.size(), 1, 'Duplicate copy number found');
        Id bookId = copies[0].Book__c;
        ApexPages.PageReference target =Page.Book;
        target.getParameters().put('id', bookId);
        return target;
    }
    
}