public class WaitlistUtil {
    public static boolean activateFirstWaitlistEntry(book_copy__c copy) {
        Waitlist_Entry__c[] waiting = [SELECT id, status__c, createdDate from Waitlist_Entry__c where book__c = :copy.book__c and status__c = 'Waiting' order by createdDate];
        if (waiting.size() == 0) {
            return false;
        } else {
            System.debug(waiting.size());
            Waitlist_Entry__c first = waiting[0];
            first.status__c = 'Notified';
            copy.waiting_student__c = first.Id; 
            update copy;
            update first;
            return true;
        }
    }
    
    public static ApexPages.PageReference checkOutForWaitlist(Id copyId) {
        Book_Copy__c copy = [SELECT Waiting_Student__r.id, Waiting_Student__c, Waiting_Student__r.Status__c, Waiting_Student__r.Student__c from Book_Copy__c where id = :copyId];
        Waitlist_Entry__c entry = copy.Waiting_Student__r;
        entry.Status__c = 'Fulfilled';
        Checkout__c checkout = new Checkout__c();
        checkout.Book_Copy__c = copyId;
        checkout.Student__c = entry.Student__c;
        update entry;
        copy.Waiting_Student__c = null;
        update copy;
        return new ApexPages.StandardController(checkout).save();
    }
}