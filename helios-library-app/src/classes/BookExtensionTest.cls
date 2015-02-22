@IsTest
public class BookExtensionTest {
    public static testmethod void testCheckout() {
        Contact student = ApexTestUtil.createTestStudent('BookExtensionStudent');
        Book__c book = ApexTestUtil.createTestBook('xxxxxxxxxxxxx');
        Book_copy__c copy = ApexTestUtil.createTestBookCopy(book);
        Checkout__c checkout = ApexTestUtil.createCheckout(copy, student);
        checkout = [select is_current__c from checkout__c where id=:checkout.Id];
        System.assert(checkout.Is_Current__c);
        PageReference pageRef = Page.Book;
        pageRef.getParameters().put('id', book.id);
        pageRef.getParameters().put('copyId', copy.id);
        Test.setCurrentPage(pageRef);
        BookExtension ext = new BookExtension(new ApexPages.StandardController(book));
        pageRef = ext.checkIn();
        checkout = [select is_current__c from checkout__c where id=:checkout.Id];
        System.assert(!checkout.Is_Current__c);
    }
}