@isTest
public class ApexTriggerTests {

    /* Ensure you can add a student without specifying an account */
    static testmethod void testSetAccountTrigger() {
        ApexTestUtil.createTestStudent('testSetAccountTriggerStudent');
    }
    
    static testmethod void testCheckExistingWaitlist() {
        Contact student = ApexTestUtil.createTestStudent('testCheckExistingWaitlistStudent');
        Book__c book = ApexTestUtil.createTestBook('testCheckExistingWaitlistBook');
        ApexTestUtil.createWaitlistEntry(student, book);
        try {
            ApexTestUtil.createWaitlistEntry(student, book);
            System.assert(false, 'able to create duplicate waitlist entry');
        } catch (DmlException e) {
            //expected result
        }
    }
    
    static testmethod void testCheckExistingCheckoutForWaitlist() {
        Contact student = ApexTestUtil.createTestStudent('testCheckExistingCheckoutStudent');
        Book__c book = ApexTestUtil.createTestBook('testCheckExistingCheckoutBook');
        Book_copy__c bookCopy = ApexTestUtil.createTestBookCopy(book);
        Checkout__c checkout = ApexTestUtil.createCheckout(bookCopy, student);
        try {
            ApexTestUtil.createWaitlistEntry(student, book);
            System.assert(false, 'able to create duplicate checkout');
         } catch (DmlException e) {
             //expected result
         }
    }
    
    static testmethod void testCheckDuplicateCheckout() {
        Contact student = ApexTestUtil.createTestStudent('testCheckExistingCheckoutStudent');
        Book__c book = ApexTestUtil.createTestBook('testCheckExistingCheckoutBook');
        Book_copy__c bookCopy1 = ApexTestUtil.createTestBookCopy(book);
        Book_copy__c bookCopy2 = ApexTestUtil.createTestBookCopy(book);
        Checkout__c checkout = ApexTestUtil.createCheckout(bookCopy1, student);
        try {
            ApexTestUtil.createCheckout(bookCopy2, student);
            System.assert(false, 'able to create duplicate checkout');
         } catch (DmlException e) {
             //expected result
         }
    }
    
    static testmethod void testWaitlistExpires() {
        Contact student1 = ApexTestUtil.createTestStudent('testWaitlistExpiresStudent1');
        Contact student2 = ApexTestUtil.createTestStudent('testWaitlistExpiresStudent2');
        Book__c book = ApexTestUtil.createTestBook('testWaitlistExpiresBook');
        Book_copy__c bookCopy = ApexTestUtil.createTestBookCopy(book);
        waitlist_entry__c firstWaitlistEntry = ApexTestUtil.createWaitlistEntry(student1, book);
        waitlist_entry__c secondWaitlistEntry = ApexTestUtil.createWaitlistEntry(student2, book);
        ApexTestUtil.notifyWaitlistForCopy(firstWaitlistEntry, bookCopy);
        firstWaitlistEntry.status__c = 'Expired';
        update firstWaitlistEntry;
        secondWaitlistEntry = [SELECT id, status__c from Waitlist_entry__c where id = :secondWaitlistEntry.id];
        System.assert(secondWaitlistEntry.status__c == 'Notified');
    }
    
    static testmethod void testNotifyOnCheckin() {
        Contact student1 = ApexTestUtil.createTestStudent('testWaitlistExpiresStudent1');
        Contact student2 = ApexTestUtil.createTestStudent('testWaitlistExpiresStudent2');
        Book__c book = ApexTestUtil.createTestBook('testWaitlistExpiresBook');
        Book_copy__c bookCopy = ApexTestUtil.createTestBookCopy(book);
        Checkout__c checkout = ApexTestUtil.createCheckout(bookCopy, student1);
        Waitlist_entry__c waitlistEntry = ApexTestUtil.createWaitlistEntry(student2, book);
        checkout.is_current__c = false;
        update checkout;
        waitlistEntry = [SELECT id, status__c from Waitlist_entry__c where id = :waitlistEntry.id];
        System.assert(waitlistEntry.status__c == 'Notified');
    }
    
    static testmethod void testTitleToName() {
        Book__c book = new Book__c();
        book.Title__c = 'Foo';
        book.Isbn__c = 'XXXXXXX';
        insert book;
        book = [SELECT Title__c, Name, isbn__c from book__c where id = :book.id];
        System.assertEquals(book.Name, 'Foo');
        System.assertEquals(book.ISBN__c, 'XXXXXXX');
        System.assertEquals(book.Title__c, 'Foo');
    }
}