public class WaitlistEntryExtension {
    public Book__c theBook {public get; private set;}
    public WaitlistEntryExtension(ApexPages.StandardController controller) {
        Waitlist_Entry__c record = (Waitlist_Entry__c) controller.getRecord();
        record.Book__c = ApexPages.currentPage().getParameters().get('bookId');
        theBook = [select Title__c, Author_Display_Name__c from Book__c where Id = :record.Book__c];
    }
    
    
}