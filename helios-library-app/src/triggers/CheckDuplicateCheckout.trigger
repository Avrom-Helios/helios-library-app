trigger CheckDuplicateCheckout on Checkout__c (before insert) {
    for (Checkout__c newCheckout : Trigger.new) {
        Book_copy__c checkedOutBookCopy = [select book__c from book_copy__c where id = :newCheckout.book_copy__c];
        Checkout__c[] existingCheckouts = [SELECT id from Checkout__c where 
            is_current__c = true and
            book_copy__r.book__c = :checkedOutBookCopy.book__c and
            student__c  = :newCheckout.student__c];
        if (existingCheckouts.size() > 0) {
            newCheckout.addError('You have already checked out a copy of this book.');
            return;
        }
    }
}