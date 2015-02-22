trigger CheckExistingWaitlistOrCheckout on Waitlist_Entry__c (before insert) {
    Waitlist_entry__c newEntry = Trigger.new[0];  // no bulk inserts for waitlist entries
    Waitlist_entry__c[] existingEntries = [SELECT student__c from waitlist_entry__c where (status__c = 'Waiting' or status__c = 'Notified') and book__c = :newEntry.book__c];
    for (waitlist_entry__c existing : existingEntries) {
      if (existing.student__c == newEntry.student__c) {
        newEntry.addError('You are already on the waitlist for this book.');
        return;
      }
    }
    Checkout__c[] existingCheckouts = [SELECT student__c from checkout__c where book_copy__r.book__c = :newEntry.book__c and is_current__c = true];
    for (Checkout__c checkout : existingCheckouts) {
      if (checkout.student__c == newEntry.student__c) {
        newEntry.addError('You have already checked out a copy of this book.');
        return;
      }
    }
}