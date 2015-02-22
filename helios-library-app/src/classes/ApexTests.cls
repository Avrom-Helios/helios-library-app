@IsTest public class ApexTests {

    /* Ensure you can add a student without specifying an account */
    static testmethod void testSetAccountTrigger() {
        createTestStudent();
    } 
    /*
    static testmethod void testCheckExistingWaitlist() {
        Contact student = createTestStudent();
        Book__c book = createTestBook();
        createWaitlistEntry(student, book);
        try {
            createWaitlistEntry(student, book);
            System.assert(false, 'able to create duplicate waitlist entry');
        } catch (DmlException e) {
            //expected result
        }
    } */
    
    private static Contact createTestStudent() {
        Contact testStudent = new Contact();
        testStudent.lastName = 'testStudentLastName';
        insert testStudent;
        return testStudent;
    }
    /*
    private static Book__c createTestBook() {
        Book__c testBook = new Book__c();
        testBook.name = 'testIsbn';
        insert testBook;
        return testBook;
    }

    private static Waitlist_entry__c createWaitlistEntry(Contact student, Book__c book) {
        Waitlist_entry__c entry = new Waitlist_entry__c();
        entry.book__c = book.id;
        entry.student__c = student.id;
        insert entry;
        return entry;
    } */
}