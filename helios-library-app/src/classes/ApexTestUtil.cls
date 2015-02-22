@isTest
public class ApexTestUtil {

    public static User getSeeker() {
        User seeker = [SELECT id from User where profile.name='Seeker' limit 1];
        return seeker;
    }
    
    public static User getLibrarian() {
        User librarian = [SELECT id from User where profile.name='Librarian' limit 1];
        return librarian;
    }
    
    public static Contact createTestStudent(String lastName) {
        Account testAccount = new Account();
        testAccount.name = 'TestAcc';
        insert testAccount;
        Contact testStudent = new Contact();
        testStudent.lastName = lastName;
        insert testStudent;
        return testStudent;
    }
    
    public static Book__c createTestBook(String title) {
        Book__c testBook = new Book__c();
        //testBook.ISBN__c = 'XXX' + title.leftPad(10, 'X').substring(0,10);
        testBook.title__c = title;
        insert testBook;
        return testBook;
    }
    
    public static Waitlist_entry__c createWaitlistEntry(Contact student, Book__c book) {
        Waitlist_entry__c entry = new Waitlist_entry__c();
        entry.book__c = book.id;
        entry.student__c = student.id;
        entry.status__c = 'Waiting';
        insert entry;
        return entry;
    }
    
    public static void notifyWaitlistForCopy(Waitlist_entry__c waitlist, book_copy__c copy) {
        waitlist.status__c = 'Notified';
        copy.waiting_student__c = waitlist.id;
        update waitlist;
        update copy;
    }
    
    public static Book_copy__c createTestBookCopy(Book__c book) {
        Book_copy__c copy = new Book_copy__c();
        copy.book__c = book.id;
        insert copy;
        return copy;
    }
    
    public static Checkout__c createCheckout(Book_copy__c copy, Contact student) {
        Checkout__c checkout = new Checkout__c();
        checkout.book_copy__c = copy.id;
        checkout.student__c = student.id;
        insert checkout;
        return checkout;
    }
    
    public static Main_Location__c createMainLocation(String name) {
        Main_Location__c mainLocation = new Main_Location__c();
        mainLocation.name = name;
        insert mainLocation;
        return mainLocation;
    }
    
    public static Location__c createLocation(String name, Main_Location__c parent) {
        Location__c location = new Location__c();
        location.name = name;
        location.Main_Location__c = parent.id;
        insert location;
        return location;
    }
}