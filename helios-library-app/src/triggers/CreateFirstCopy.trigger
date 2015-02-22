trigger CreateFirstCopy on Book__c (after insert) {
    List<Book_Copy__c> copies = new List<Book_Copy__c>();
    for (Book__c book : Trigger.new) {
        Book_Copy__c copy = new Book_Copy__c();
        copy.Book__c = book.Id;
        copies.add(copy);
    }
    insert copies;
}