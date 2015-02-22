global class ConsolidateNonfictionBatch implements Database.Batchable<sObject> {
    Id nonFictionLocId {get; set;}
    boolean hasErrors {get; set;}
    
    public ConsolidateNonfictionBatch() {
        Location__c properLoc = [SELECT ID from Location__c where Name = 'Non-Fiction' and Main_Location__r.Name ='Non-Fiction'];
        nonFictionLocId = properLoc.Id;
        hasErrors = false;
    }
    
    global Database.QueryLocator start(Database.BatchableContext ctx) {
        return Database.getQueryLocator('SELECT Location__c from Book__c ' + 
                                        'WHERE Location__r.Name != \'Non-Fiction\' AND Location__r.Main_Location__r.Name = \'Non-Fiction\''
                 );
    }
    
    global void execute(Database.BatchableContext ctx, List<Sobject> books) {
        for (SObject book : books) {
            book.put(Book__c.fields.Location__c, nonFictionLocId);
        }
        try {
            update books;
        } catch (System.DmlException e) {
            this.hasErrors = true;
            throw e;
        }
        
    }
    
    global void finish(Database.BatchableContext ctx) {
        if (!this.hasErrors) {
            Location__c[] toDelete = [SELECT Id from Location__c WHERE Name != 'Non-Fiction' AND Main_Location__r.Name = 'Non-Fiction'];
            delete toDelete;
        }
    }
}