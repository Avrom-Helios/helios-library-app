@IsTest
public class CheckoutExtenstionTest {
    static testmethod void testSetBookCopy() {
        Book__c testBook = ApexTestUtil.createTestBook('The Book that We Are Testing');
        Book_copy__c testCopy = ApexTestUtil.createTestBookCopy(testBook);
        PageReference currentPage = Page.Checkout;
        currentPage.getParameters().put('bcId', testCopy.Id);
        Test.setCurrentPage(currentPage);
        CheckoutExtension checkoutExt = new CheckoutExtension(new ApexPages.StandardController(new Checkout__c()));
        testCopy = [SELECT copy_number__c from book_copy__c where id = :testCopy.id];
        System.assertEquals(testCopy.copy_number__c, checkoutExt.theCopy.copy_number__c);
    }
}