@IsTest
public class DedupeBooksBatchTest {
    public static testmethod void testDedupeBooks() {
        Main_Location__c mainLoc = ApexTestUtil.createMainLocation('foo');
        Location__c loc = ApexTestUtil.createLocation('bar', mainLoc);
        List<Book__c> books = new List<Book__c>();
        
        Book__c book = makeBook('John');
        book.DDN__c = '765';
        book.Location__c = loc.id;
        book.Copyright_Date__c = '1970';
        books.add(book);
        
        book = makeBook('John');
        book.ISBN__c = '1234567890';
        book.Newberry_Book__c = true;
        book.Summary__c = 'Every good boy does fine. Kings play chess on fine-grained sand.';
        books.add(book);
        
        //Now one that doesn't match the author first name
        book = makeBook('Jane');
        book.DDN__c = '775';
        book.Location__c = loc.id;
        book.Copyright_Date__c = '1971';
        book.ISBN__c = '1234567891';
        book.Newberry_Book__c = false;
        book.Summary__c = 'Oh, be a fine girl; kiss me.';
        books.add(book);
        
        insert books;
        List<Id> bookIds = new List<Id>();
        for (Book__c parent : books) {
            bookIds.add(parent.id);
            //Plus the original == 5
            for (Integer i=0; i<4; i++) {
            	ApexTestUtil.createTestBookCopy(parent);
            }
        }
        Test.startTest();
        Database.executeBatch(new DedupeBooksBatch(), 3);
        Test.stopTest();
		Book__c[] results = [select name, title__c, author_last_name__c, author_first_name__c,
                            ddn__c, location__c, copyright_date__c, isbn__c, newberry_book__c, 
                            summary__c, (SELECT id from copies_of_books__r) 
                            from Book__c
                            where id in :bookIds
                            order by author_first_name__c];
		System.assertEquals(2, results.size());
        //John Doe
        book = results.get(1);
        System.assertEquals(books[0].title__c, book.title__c);
        System.assertEquals(books[0].author_first_name__c, book.Author_First_Name__c);
        System.assertEquals(books[0].author_last_name__c, book.Author_Last_Name__c);
        System.assertEquals(books[0].DDN__c, book.DDN__c);
        System.assertEquals(books[0].Location__c, book.Location__c);
        System.assertEquals(books[0].Copyright_date__c, book.Copyright_Date__c);
        System.assertEquals(books[1].ISBN__c, book.ISBN__c);
        System.assertEquals(books[1].Newberry_Book__c, book.Newberry_Book__c);
        System.assertEquals(books[1].Summary__c, book.Summary__c);
        System.assertEquals(10, book.copies_of_books__r.size());
		//Jane Doe
		book = results.get(0);
        System.assertEquals(books[2].title__c, book.title__c);
        System.assertEquals(books[2].author_first_name__c, book.Author_First_Name__c);
        System.assertEquals(books[2].author_last_name__c, book.Author_Last_Name__c);
        System.assertEquals(books[2].DDN__c, book.DDN__c);
        System.assertEquals(books[2].Location__c, book.Location__c);
        System.assertEquals(books[2].Copyright_date__c, book.Copyright_Date__c);
        System.assertEquals(books[2].ISBN__c, book.ISBN__c);
        System.assertEquals(books[2].Newberry_Book__c, book.Newberry_Book__c);
        System.assertEquals(books[2].Summary__c, book.Summary__c);
        System.assertEquals(5, book.copies_of_books__r.size());
    }
    
    static Book__c makeBook(String authorFirstName) {
        Book__c book = new Book__c();
        book.Title__c = 'A Book';
        book.Author_Last_Name__c = 'Doe';
        book.Author_First_Name__c = authorFirstName;
        return book;
    }
}