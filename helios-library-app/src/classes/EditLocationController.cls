public class EditLocationController {

    public Location__c location {public get; public set;}

    public EditLocationController() {
        Map<String, String> parameters = ApexPages.currentPage().getParameters();
        if (parameters.get('id') != null) {
            location = [select id, name, Check_Out_Allowed__c, main_location__r.name from location__c where id = :parameters.get('id')];
        } else {
           location = new Location__c();
           location.main_location__r = [SELECT id, name from main_location__c where id = :parameters.get('mainLocId')];
           location.main_location__c = parameters.get('mainLocId');
        }
    }
    
    public PageReference doSave() {
        upsert location;
        return Page.locations;
    }
    
        public PageReference cancel() {
        return Page.locations;
    }
}