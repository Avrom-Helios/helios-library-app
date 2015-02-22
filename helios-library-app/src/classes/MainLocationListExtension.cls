public class MainLocationListExtension {

    public Id selectedMainLoc {public get; public set;}
    
    public Id selectedLoc {public get; public set;}
    
    public MainLocationListExtension(ApexPages.StandardSetController controller) {

    }
    
    public PageReference doDelete() {
        Main_Location__c loc = [select id from Main_location__c where id = :selectedMainLoc];
        delete loc;
        PageReference reload = Page.locations;
        reload.setRedirect(true);
        return reload;
    }
    
    public PageReference createLocation() {
        PageReference create = Page.editLocation;
        create.getParameters().put('mainLocId', selectedMainLoc);
        return create;
    }
    
    public PageReference viewLocation() {
        Location__c selectedLocation = [select id from Location__c where id = :selectedLoc];
        return new ApexPages.StandardController(selectedLocation).view();
    }
    
    static testMethod void testDelete() {
        Main_Location__c mainLoc = ApexTestUtil.createMainLocation('testMainLoc');
        Id mainLocId = mainLoc.id;
        ApexPages.StandardSetController controller = new ApexPages.StandardSetController([SELECT id from main_location__c]);
        MainLocationListExtension extension = new MainLocationListExtension(controller);
        extension.selectedMainLoc = mainLoc.Id;
        extension.doDelete();
        Main_Location__c[] isMainLocStillThere = [SELECT id from main_location__c where id = :mainLocId];
        System.assert(isMainLocStillThere.size() == 0);
    }
    
    static testMethod void testCreateLoc() {
        Main_Location__c mainLoc = ApexTestUtil.createMainLocation('testMainLoc');
        Id mainLocId = mainLoc.id;
        ApexPages.StandardSetController controller = new ApexPages.StandardSetController([SELECT id from main_location__c]);
        MainLocationListExtension extension = new MainLocationListExtension(controller);
        extension.selectedMainLoc = mainLoc.Id;
        PageReference target = extension.createLocation();
    }
    
    static testMethod void testViewLoc() {
        Main_Location__c mainLoc = ApexTestUtil.createMainLocation('testMainLoc');
        Location__c loc = ApexTestUtil.createLocation('testLoc', mainLoc);
        Id mainLocId = mainLoc.id;
        ApexPages.StandardSetController controller = new ApexPages.StandardSetController([SELECT id from main_location__c]);
        MainLocationListExtension extension = new MainLocationListExtension(controller);
        
        extension.selectedLoc = loc.id;
        PageReference target = extension.viewLocation();
    }

}