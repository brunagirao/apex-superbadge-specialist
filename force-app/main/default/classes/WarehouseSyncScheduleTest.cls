@isTest
public with sharing class WarehouseSyncScheduleTest {
    @isTest
    public static void scheduleWarehouseSyncTest() {
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
            WarehouseSyncSchedule reminder = new WarehouseSyncSchedule();
            String sch = '0 0 1 * * ? *';
            reminder.execute(null);
            System.assertEquals('0 0 1 * * ? *', sch);
        Test.stopTest();       
    }

}