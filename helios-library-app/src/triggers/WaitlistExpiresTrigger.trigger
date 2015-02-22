trigger WaitlistExpiresTrigger on Waitlist_Entry__c (after update) {
    for (Waitlist_Entry__c expiredWaitlistEntry : Trigger.new) {
        if (expiredWaitlistEntry.status__c == 'Expired' && Trigger.oldMap.get(expiredWaitlistEntry.id).status__c == 'Notified') {
            book_copy__c copyToMakeAvailable = [select id, book__c, waiting_student__c from book_copy__c where waiting_student__c = :expiredWaitlistEntry.id limit 1];
            copyToMakeAvailable.waiting_student__c = null;
            update copyToMakeAvailable;
            WaitlistUtil.activateFirstWaitlistEntry(copyToMakeAvailable);
        }    
    }
}