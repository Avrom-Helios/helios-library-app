trigger NotifyWaitlistOnCheckin on Checkout__c (after update) {
    for (Checkout__c checkin : Trigger.new) {
        if (Trigger.oldMap.get(checkin.id).is_current__c && !checkin.is_current__c) {
            book_copy__c copy = [SELECT id, book__c from book_copy__c where id = :checkin.book_copy__c];
            WaitlistUtil.activateFirstWaitlistEntry(copy);
        }
    }
}