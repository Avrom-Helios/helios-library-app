public class NewBookExtension {
    public ApexPages.StandardController controller {public get; set;}
    public boolean useDDN {public get; set;}
	
    public NewBookExtension(ApexPages.StandardController controller) {
        this.controller = controller;
        if (useDDN != true) {
	        useDDN = false;
        	relocate();
        }
    }
    
    public PageReference doSaveOrFindExisting() {
        Book__c enteredBook = (Book__c) controller.getRecord();
        if (enteredBook.Id != null) {
            //This is an edit; just save it
            return validateAndSaveInternal();
        }
        String title = enteredBook.Title__c;
        String authorLastName = enteredBook.Author_Last_Name__c;
        Book__c[] existingBooks;
        if (String.isBlank(authorLastName)) {
            existingBooks = [SELECT id from Book__c where Title__c = :title];
        } else {
            existingBooks = [SELECT id from Book__c where Title__c = :title and Author_Last_Name__c = :authorLastName];
        }
        if (existingBooks.size() > 0) {
            PageReference newBookCopy = Page.newBookCopy;
        	newBookCopy.getParameters().put('bookId', existingBooks[0].id);
        	return newBookCopy;
        } else {
            return validateAndSaveInternal();
        }
    }
    
    //For now, we don't want this in a trigger, because import can't set the DDN yet.
    PageReference validateandSaveInternal() {
        relocate();
        if (useDDN) {
            Book__c book = (Book__c) controller.getRecord();
            if (String.isBlank(book.DDN__c)) {
                book.DDN__c.addError('A dewey decimal number is required for a book in this location');
                return null;
            } 
        }
        return controller.save();
    }
    
    public PageReference relocate() {
        Book__c book = (Book__c) controller.getRecord();
        Id locId = book.location__c;
        boolean wasUseDDN = useDDN;
        if (book.Location__c != null) {
        	Location__c loc = [SELECT main_location__r.Uses_Dewey_Decimal_Coding__c from location__c where id=:locId];
        	useDDN = loc.main_location__r.Uses_Dewey_Decimal_Coding__c;
        }
        if (wasUseDDN && !useDDN) {
            book.DDN__c = null;
            book.Manual_Cutter_Code__c = null;
        }
        return null;
    }
}