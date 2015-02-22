trigger CopyParentEmails on Checkout__c (after insert) {
    Checkout__c[] toSet = [SELECT 
                           	Parent_Email_1__c, 
                           	Parent_Email_2__c, 
                            Student__r.Parent_Email_1__c,
                            Student__r.Parent_Email_2__c
                           FROM Checkout__c
                           WHERE Id In :Trigger.newMap.keySet()
                          ];
    for (Checkout__c checkout : toSet) {
        checkout.Parent_Email_1__c = checkout.Student__r.Parent_Email_1__c;
        checkout.Parent_Email_2__c = checkout.Student__r.Parent_Email_2__c;
    }
    update toSet;
}