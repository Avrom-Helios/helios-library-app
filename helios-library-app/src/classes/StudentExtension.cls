public class StudentExtension {
    public List<Checkout__c> checkouts {get; set;}
    public StudentExtension(ApexPages.StandardController controller) {
        Id studentId = controller.getRecord().id;
        checkouts = [select id, book_copy__r.book__r.title__c, due_date__c from checkout__c where student__c = :studentId and is_current__c = true order by due_date__c];
    }

}