global class DedupeBooksBatch implements Database.Batchable<AggregateResult> {
    global Iterable<AggregateResult> start(Database.BatchableContext BC) {
        return new AggregateResultIterable(
            'SELECT min(id), name, title__c, author_last_name__c, author_first_name__c ' +
            'FROM Book__c ' + 
            'GROUP BY name, title__c, author_last_name__c, author_first_name__c ' +
            'HAVING count(id) > 1');
    }
    
    global void execute(Database.BatchableContext BC, List<Sobject> scope) {
        for (SObject res : scope) {
            Book__c[] dups = [SELECT id,
                              DDN__c,
                              ISBN__c,
                              Location__c,
                              Newberry_Book__c,
                              Copyright_Date__c,
                              Summary__c,
                              (SELECT id,
                              Book__c from
                              Copies_of_books__r),
                              (select id,
                              Book__c from waitlist__r)
                              from Book__c where 
                        name = :(String)res.get('name') and
                        title__c = :(String)res.get('title__c') and
                        author_last_name__c = :(String)res.get('author_last_name__c') and
                        author_first_name__c = :(String)res.get('author_first_name__c')];
            Book__c master = dups[0];
            List<Book_Copy__c> copiesToUpdate = new List<Book_Copy__c>();
            List<Waitlist_Entry__c> waitlistsToUpdate = new List<Waitlist_Entry__c>();
            List<Book__c> booksToDelete = new List<Book__c>();
            //Start with 1, since 0 is the master
            for (Integer i=1; i < dups.size(); i++) {
                Book__c dup = dups[i];
                booksToDelete.add(dup);
                if (dup.DDN__c != null && (master.DDN__c == null || master.DDN__c < dup.DDN__c)) {
                    master.DDN__c = dup.DDN__c;
                }
                if (dup.ISBN__c != null && !dup.ISBN__c.startsWith('X') && 
                    (master.ISBN__c == null || master.ISBN__c.startsWith('X'))) {
                        master.ISBN__c = dup.ISBN__c;
                    }
                if (master.Location__c == null && dup.Location__c != null) {
                    master.Location__c = dup.Location__c;
                }
                if (dup.Newberry_Book__c) {
                    master.Newberry_Book__c = true;
                }
                if (dup.Copyright_Date__c != null && (master.Copyright_Date__c == null || master.Copyright_Date__c > dup.Copyright_Date__c)) {
                    master.Copyright_Date__c = dup.Copyright_Date__c;
                }
                if (dup.Summary__c != null && (master.Summary__c == null || master.Summary__c.length() < dup.Summary__c.length())) {
                    master.Summary__c = dup.Summary__c;
                }
                if (dup.copies_of_books__r != null) {
                    for (Book_copy__c copy : dup.Copies_of_books__r) {
                        copy.book__c = master.id;
                        copiesToUpdate.add(copy);
                    }
                }
                if (dup.Waitlist__r != null) {
                    for (Waitlist_entry__c waitlist : dup.Waitlist__r) {
                        waitlist.book__c = master.id;
                        waitlistsToUpdate.add(waitlist);
                    }
                }
            }
            update master;
            update copiesToUpdate;
            update waitlistsToUpdate;
            delete booksToDelete;
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
}