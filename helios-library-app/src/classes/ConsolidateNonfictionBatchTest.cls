@IsTest
public class ConsolidateNonfictionBatchTest {
    public static testmethod void testConsolidateNonfiction() {
        Main_Location__c mainLoc = ApexTestUtil.createMainLocation('Non-Fiction');
        Location__c proper = ApexTestUtil.createLocation('Non-Fiction', mainLoc);
        Location__c improper = ApexTestUtil.createLocation('Fluffy Puppies', mainLoc);
        Main_Location__c otherMainLoc = ApexTestUtil.createMainLocation('Fiction');
        Location__c otherLoc = ApexTestUtil.createLocation('Illustrated Fiction', otherMainLoc);
        Book__c correctlyFiled = ApexTestUtil.createTestBook('Fluffy Puppies: A Definitive Guide');
        correctlyFiled.Location__c = proper.Id;
        Book__c badlyFiled = ApexTestUtil.createTestBook('All About Fluffy Puppies');
        badlyFiled.Location__c = improper.Id;
        update new Book__c[] {correctlyFiled, badlyFiled};
        Test.startTest();
        Database.executeBatch(new ConsolidateNonfictionBatch(), 3);
        Test.stopTest();
        Book__c[] nonFictionBooks = [SELECT Id from Book__c where Location__c = :proper.Id];
        System.assertEquals(2, nonFictionBooks.size());
        Location__c[] nonFictionLocations = [SELECT Id from Location__c where Main_Location__c = :mainLoc.Id];
        System.assertEquals(1, nonFictionLocations.size());
        System.assertEquals(proper.id, nonFictionLocations[0].Id);
        Location__c[] otherLocations = [SELECT Id from Location__c where Main_Location__c = :otherMainLoc.Id];
        System.assertEquals(1, otherLocations.size());
        System.assertEquals(otherLoc.Id, otherLocations[0].Id);
    }
}