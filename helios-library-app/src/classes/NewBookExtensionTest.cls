@IsTest
public class NewBookExtensionTest {
    public static testmethod void testFindExisting() {
        String title = 'Duplicated Title';
        String author_first = 'Duplicated';
        String author_last = 'Author';
        Book__c original = ApexTestUtil.createTestBook(title);
        original.Author_First_Name__c = author_first;
        original.Author_Last_Name__c = author_last;
        update original;
        System.PageReference newBookPage = Page.NewBook;
        Book__c dup = new Book__c();
        NewBookExtension ext = new NewBookExtension(new ApexPages.StandardController(dup));
        dup.Title__c = title;
        dup.Author_First_Name__c = author_first;
        dup.Author_Last_Name__c = author_last;
        PageReference expectedResult = Page.NewBookCopy;
        expectedResult.getParameters().put('bookId', original.Id);
        System.assertEquals(expectedResult.getUrl(), ext.doSaveOrFindExisting().getUrl());
    }
    
    public static testmethod void testRelocate() {
        Book__c theBook = ApexTestUtil.createTestBook('The Book');
        System.PageReference newBookPage = Page.NewBook;
        NewBookExtension ext = new NewBookExtension(new ApexPages.StandardController(theBook));
        System.assert(!ext.useDDN, 'Book with no location should not use DDN');
        Main_Location__c mainLoc1 = ApexTestUtil.createMainLocation('main');
        mainLoc1.Uses_Dewey_Decimal_Coding__c = true;
        update mainLoc1;
        Location__c loc1 = ApexTestUtil.createLocation('loc', mainLoc1);
        theBook.Location__c = loc1.Id;
        ext.relocate();
        System.assert(ext.useDDN, 'Book with main location using DDN should use it.');
        Main_Location__c mainLoc2 = ApexTestUtil.createMainLocation('main');
        Location__c loc2 = ApexTestUtil.createLocation('loc', mainLoc2);
        theBook.Location__c = loc2.Id;
        ext.relocate();
        System.assert(!ext.useDDN, 'Book with main location not using DDN should not use it.');
    }
    
    public static testmethod void testValidation() {
        Main_Location__c ddnMainLoc = ApexTestUtil.createMainLocation('ddnMainLoc');
        ddnMainLoc.Uses_Dewey_Decimal_Coding__c = true;
        update ddnMainLoc;
        Location__c loc = ApexTestUtil.createLocation('loc', ddnMainLoc);
        Book__c newBook = new Book__c();
        NewBookExtension ext = new NewBookExtension(new ApexPages.StandardController(newBook));
        newBook.Location__c = loc.Id;
        newBook.Title__c = 'Title';
        System.assert(ext.doSaveOrFindExisting() == null, 'Book was saved when it should have failed DDN validation.');
        newBook.DDN__c = '020';
        PageReference expectedStart = Page.Book;
        String realUrl = ext.doSaveOrFindExisting().getUrl();
        String bookKeyPref = Book__c.sobjectType.getDescribe().getKeyPrefix();
		System.assert(realUrl.startsWith('/' + bookKeyPref),
                      'Book was not saved when it should have passed DDN validation.');
    }
}