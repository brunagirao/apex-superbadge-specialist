global with sharing class WarehouseSyncSchedule implements Schedulable {
    // run this code in anonymous block:
    /*  
        WarehouseSyncSchedule reminder = new WarehouseSyncSchedule();
        Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
        String sch = '0 0 1 * * ? *';
        System.schedule('WarehouseSyncScheduleJob', sch, reminder);
    */
    global void execute(SchedulableContext sc) {
        System.enqueueJob(new WarehouseCalloutService());
    }   
}