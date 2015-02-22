@IsTest 
public class RetrieveDDNBatchTest {
    static String ISBN = '0439926440';
    public static String EXPECTED_ISBN_URL_DECODED = RetrieveDDNBatch.BASE_CLASSIFY_URL + 
        'isbn=' + ISBN + '&summary=true';
    static String TITLE = 'The Encyclopedia of Mammals';
    static String AUTHOR_LAST_NAME = 'MacDonald';
    static String AUTHOR_FIRST_NAME = 'David W.';
    public static String EXPECTED_TITLE_URL_DECODED = RetrieveDDNBatch.BASE_CLASSIFY_URL + 
        'author=' + AUTHOR_LAST_NAME + ', ' + AUTHOR_FIRST_NAME + '&title=' + TITLE + '&summary=true';
    
    public static testmethod void testRetrieveDDNs() {
        Main_Location__c mainLoc = ApexTestUtil.createMainLocation('foo');
        mainLoc.Uses_Dewey_Decimal_Coding__c = true;
        update mainLoc;
        Location__c loc = ApexTestUtil.createLocation('bar', mainLoc);
        List<Book__c> books = new List<Book__c>();
        //A book with ISBN
        Book__c isbnBook = ApexTestUtil.createTestBook('Some Random Title');
        //This book's DDN should be 372.4
        isbnBook.ISBN__c = ISBN;
        isbnBook.Location__c = loc.id;
        books.add(isbnBook);
        //A book with no ISBN, but author name and title
        Book__c authorBook = apexTestUtil.createTestBook(TITLE);
        //This book's DDN should be 599
        authorBook.Author_Last_Name__c = AUTHOR_LAST_NAME;
        authorBook.Author_First_Name__c = AUTHOR_FIRST_NAME;
        authorBook.Location__c = loc.id;
        books.add(authorBook);
        update books;
        //Setting a callout mock doesn't seem to work with batch methods (even after StartTest, it 
        //compliains that you've done a callout with uncommitted data), so we handle it stupidly
        //inside RetrieveDDNBatch
        Test.startTest();
        Database.executeBatch(new RetrieveDDNBatch(), 50);
        Test.stopTest();
        isbnBook = [SELECT DDN__c from Book__c WHERE Id = :isbnBook.Id];
        System.assertEquals('372.4', isbnBook.DDN__c);
        authorBook = [SELECT DDN__c from Book__c WHERE Id = :authorBook.Id];
        System.assertEquals('599', authorBook.DDN__c);
    }

    /* public static testmethod void testDontRetrieveDDNs() {
        Main_Location__c mainLoc = ApexTestUtil.createMainLocation('foo');
        mainLoc.Uses_Dewey_Decimal_Coding__c = true;
        update mainLoc;
        Location__c loc = ApexTestUtil.createLocation('bar', mainLoc);
        // And a location that doesn't use DDC.
        Main_Location__c controlMainLoc = ApexTestUtil.createMainLocation('baz');
        Location__c controlLoc = ApexTestUtil.createLocation('ble', controlMainLoc);
        List<Book__c> books = new List<Book__c>();
        //A book with no isbn, random name and title
        Book__c weirdBook = ApexTestUtil.createTestBook('Grblwxys');
        weirdBook.Location__c = loc.Id;
        books.add(weirdBook);
        //A book where we already specified the DDN, even though it doesn't match
        Book__c alreadyBook = ApexTestUtil.createTestBook('Some Random Title');
        //This book's DDN should at least start with 3, but we'll set it differently
        alreadyBook.ISBN__c = '0439926440';
        alreadyBook.Location__c = loc.id;
        alreadyBook.DDN__c = '999.9';
        books.add(alreadyBook);
        //A book where no DDN is expected, given the main location
        Book__c noDdnBook = ApexTestUtil.createTestBook('Harry Potter and the Sorceror\'s Stone');
        noDdnBook.isbn__c = '0439708184';
        books.add(noDdnBook);
        update books;
        Test.startTest();

        Database.executeBatch(new RetrieveDDNBatch(), 50);
        Test.stopTest();
        weirdBook = [SELECT DDN__c from Book__c WHERE Id = :weirdBook.Id];
        System.assertEquals(null, weirdBook.DDN__c);
        alreadyBook = [SELECT DDN__c from Book__c WHERE Id = :alreadyBook.Id];
        System.assertEquals('999.9', alreadyBook.DDN__c);
        noDdnBook = [SELECT DDN__c from Book__c WHERE Id = :noDdnBook.Id];
        System.assertEquals(null, alreadyBook.DDN__c);
    } */
    
}