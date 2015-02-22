public class CheckoutExtension {
    public Book_Copy__c theCopy {public get; private set;}
    public CheckoutExtension(ApexPages.StandardController controller) {
        Checkout__c checkout = (Checkout__c) controller.getRecord();
        checkout.Book_Copy__c = ApexPages.currentPage().getParameters().get('bcid');
        theCopy = [SELECT Copy_Number__c, Book__r.Title__c from Book_Copy__c where Id = :checkout.Book_Copy__c];
    }
}