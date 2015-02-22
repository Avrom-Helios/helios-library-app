public class MainLocationCreateExtension {

    Main_Location__c location;
    
    public MainLocationCreateExtension(ApexPages.StandardController controller) {
        location = (Main_Location__c) controller.getRecord();
    }
    
    public PageReference doInsert() {
        insert location;
        return Page.locations;
    }

}