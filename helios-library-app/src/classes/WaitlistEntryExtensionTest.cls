@IsTest
public class WaitlistEntryExtensionTest {
    public static testmethod void testNewWaitlist() {
        Book__c theBook = ApexTestUtil.createTestBook('Test Book');
        PageReference waitlistEntryPage = Page.NewWaitlistEntry;
        waitlistEntryPage.getParameters().put('bookId', theBook.Id);
        Test.setCurrentPage(waitlistEntryPage);
        ApexPages.StandardController ctrlr = new ApexPages.StandardController(new Waitlist_Entry__c());
        WaitlistEntryExtension ext = new WaitlistEntryExtension(ctrlr);
        System.assertEquals(theBook.Id, ((Waitlist_Entry__c) ctrlr.getRecord()).Book__c);
    }
}