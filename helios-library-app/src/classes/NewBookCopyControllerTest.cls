@IsTest
public class NewBookCopyControllerTest {
    public static testmethod void testSaveCopy() {
        Book__c newBook = ApexTestUtil.createTestBook('XXXXXXXXXXX');
        //May not be 0 if we have autocreate
        integer oldcopies = [SELECT COUNT() from Book_copy__c where book__c = :newBook.Id];
        PageReference pageRef = Page.newbookcopy;
        pageRef.getParameters().put('bookId', newBook.Id);
        Test.setCurrentPage(pageRef);
        NewBookCopyController controller = new NewBookCopyController();
        pageRef = controller.save();
        PageReference expectedResult = Page.book;
        expectedResult.getParameters().put('id', newBook.Id);
        System.assertEquals(expectedResult.getUrl(), pageRef.getUrl());
        integer newCopies = [SELECT COUNT() from Book_copy__c where book__c = :newBook.Id];
        System.assertEquals(newCopies, oldCopies + 1);
    }
}