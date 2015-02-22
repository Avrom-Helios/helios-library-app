trigger TitleToNameTrigger on Book__c (before insert, before update) {
    for (Book__c book : Trigger.new) {
        book.name = book.title__c.substring(0, Math.min(book.title__c.length(), 80));
    }
}