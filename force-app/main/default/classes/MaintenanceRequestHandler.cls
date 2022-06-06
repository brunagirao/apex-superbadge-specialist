public with sharing class MaintenanceRequestHandler {
    private List<Case> newRecordsList {get; set;}
    private List<Case> oldRecordsList {get; set;}
    private Map<Id, Case> newRecordsMap {get; set;}
    private Map<Id, Case> oldRecordsMap {get; set;}
    
    public static Boolean runTrigger;

    static {
        runTrigger = true;
    }

    public static Boolean isTriggerEnabled() {
        return runTrigger;
    }

    public static Boolean enableTrigger() {
        return runTrigger = true;
    }

    public static Boolean disableTrigger() {
        return runTrigger = false;
    }

    public MaintenanceRequestHandler(){}

    public MaintenanceRequestHandler(
        List<Case> newRecordsList,
        List<Case> oldRecordsList,
        Map<Id, Case> newRecordsMap,
        Map<Id, Case> oldRecordsMap

    ){
        this.newRecordsList = newRecordsList;
        this.oldRecordsList = oldRecordsList;
        this.newRecordsMap  = newRecordsMap;
        this.oldRecordsMap  = oldRecordsMap;
    }

    public void afterUpdate() {
        MaintenanceRequestHelper.updateWorkOrders(this.newRecordsList);
    }
}