public class BookExtension{
    public Book_Copy__c[] copies {public get; set;}
    public Waitlist_Entry__c[] extraWaitlist {public get; set;}
    
    public BookExtension(ApexPages.StandardController controller) {
        Id bookId = controller.getId();
        copies = [SELECT Id, St_Martin__c, Copy_Number__c, Donated_By__c,
                  Waiting_Student__c, Waiting_Student__r.Student__c, Waiting_Student__r.Student__r.Name, 
                  (SELECT Id, Times_renewed__c, Student__c, Student__r.Name FROM Checkouts__r WHERE is_current__c=true LIMIT 1) 
                  FROM Book_Copy__c
                  WHERE  Book__c=:bookId and Permanent_Status__c = null];
        extraWaitlist = [Select Id, Student__c, Student__r.Name, Wait_Time__c  
                         FROM Waitlist_Entry__c 
                         WHERE Status__c='Waiting' AND Book__c=:bookId];
    }
    
    public PageReference checkIn() {
        Checkout__c checkout = [SELECT Id, is_current__c FROM Checkout__c WHERE book_copy__c = :ApexPages.currentPage().getParameters().get('copyId') and is_current__c = true];
        checkout.Is_Current__c = false;
        update checkout;
        ApexPages.currentPage().setRedirect(true);
        return ApexPages.currentPage();
    }
    
    public PageReference renew() {
        Checkout__c checkout = [SELECT Id, Times_Renewed__c, Book_Copy__c, Student__c FROM Checkout__c WHERE book_copy__c = :ApexPages.currentPage().getParameters().get('copyId') and is_current__c = true];
        
        Checkout__c newCheckout = checkout.clone();
        newCheckout.Times_Renewed__c = checkout.Times_Renewed__c + 1;
        checkout.Is_Current__c = false;
        update checkout;
        insert newCheckout;
        ApexPages.currentPage().setRedirect(true);
        return ApexPages.currentPage();
    }
    
    public PageReference checkOutForReserved() {
        return WaitlistUtil.checkOutForWaitlist(ApexPages.currentPage().getParameters().get('copyId'));
    }
    

}