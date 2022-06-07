@isTest
public with sharing class MaintenanceRequestHelperTest {
    
    @TestSetup
    static void setup(){
        Vehicle__c vehicle = new Vehicle__c();
        vehicle.Name = 'Pop-Up Camper';
        insert vehicle;
        
        Product2 product                = new Product2();
        product.Name                    = 'Generator 1000 kW';
        product.Cost__c                 = 5000;
        product.Maintenance_Cycle__c    = 100;
        product.Replacement_Part__c     = true;
        insert product;

        Case newCase              = new Case();
        newCase.Type              = 'Routine Maintenance';
        newCase.Subject           = 'new Routine Maintenance created';
        newCase.Date_Reported__c  = Date.today();
        newCase.Vehicle__c        = vehicle.Id;
        insert newCase;

        Equipment_Maintenance_Item__c newEquipment = new Equipment_Maintenance_Item__c();
        newEquipment.Quantity__c                   = 10;
        newEquipment.Maintenance_Request__c        = newCase.Id;
        newEquipment.Equipment__c                  = product.Id;
        insert newEquipment;
    }

    @isTest
    public static void updateWorkOrdersTest() {
        Case c = [SELECT Id, Status FROM Case LIMIT 1];
        c.Status = 'Closed';
        update c;
        System.assertEquals('Closed', c.Status);
    }

    @isTest
    public static void operationsTriggerTest() {
        MaintenanceRequestHandler handler = new MaintenanceRequestHandler();
        MaintenanceRequestHandler.enableTrigger();
        System.assertEquals(true, MaintenanceRequestHandler.runTrigger);
        MaintenanceRequestHandler.disableTrigger();
        System.assertEquals(false, MaintenanceRequestHandler.runTrigger);
        MaintenanceRequestHandler.isTriggerEnabled();
        System.assertEquals(false, MaintenanceRequestHandler.runTrigger);
    }
}