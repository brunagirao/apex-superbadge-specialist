public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(List<Case> newRecordsList) {
        //set of type cases 
        Set<String> caseTypes = new Set<String>{'Repair', 'Routine Maintenance'};
        
        //auxiliar lists to insert requests and equipments
        List<Case> casesToInsertList = new List<Case>();
        List<Equipment_Maintenance_Item__c> equipmentsToInsertList = new List<Equipment_Maintenance_Item__c>();
        
        //map to get de older case and them equipments
        Map<Id, List<Equipment_Maintenance_Item__c>> parentCaseIdToEquipmentsMap = new Map<Id, List<Equipment_Maintenance_Item__c>>();

        //get all cases and equipments
        List<Case> caseList = [
            SELECT Id, Type, Status, Vehicle__c, ParentId, Subject,
                (
                  SELECT Id, Equipment__r.Maintenance_Cycle__c, 
                         Equipment__c, Maintenance_Request__c, Quantity__c
                    FROM Equipment_Maintenance_Items__r 
                ORDER BY Equipment__r.Maintenance_Cycle__c
                )
            FROM Case
           WHERE Id IN: newRecordsList
             AND Status = 'Closed'
             AND Type   IN: caseTypes
        ];
        
        for(Case thisCase : caseList) {
            //create a clone case
            Case caseClone              = new Case();
            caseClone.Vehicle__c        = thisCase.Vehicle__c;
            caseClone.Type              = 'Routine Maintenance';
            caseClone.Subject           = thisCase.Subject != null ? thisCase.Subject : 'new Routine Maintenance created';
            caseClone.Date_Reported__c  = Date.today();
            caseClone.ParentId          = thisCase.ParentId != null ? thisCase.ParentId : null;
            caseClone.Date_Due__c       = Date.today().addDays(Integer.valueOf(thisCase.Equipment_Maintenance_Items__r[0].Equipment__r.Maintenance_Cycle__c));
            casesToInsertList.add(caseClone);

            //get parent case equipments
            if(!parentCaseIdToEquipmentsMap.containsKey(thisCase.ParentId)) {
                parentCaseIdToEquipmentsMap.put(thisCase.ParentId, new List<Equipment_Maintenance_Item__c>());
                parentCaseIdToEquipmentsMap.get(thisCase.ParentId).addAll(thisCase.Equipment_Maintenance_Items__r);
            }
        }

        //insert cases to create Id
        if(!casesToInsertList.isEmpty()) {
            insert casesToInsertList;
        }

        //I go through the cases inserted
        for(Case insertedCase : casesToInsertList) {
            //verify if has equipments
            if(parentCaseIdToEquipmentsMap.get(insertedCase.ParentId) != null) {
                //if yes, i get the parent equipments
                List<Equipment_Maintenance_Item__c> parentEquipments = parentCaseIdToEquipmentsMap.get(insertedCase.ParentId);
                
                //clone the equipments to new case
                for(Equipment_Maintenance_Item__c equipment : parentEquipments) {
                    Equipment_Maintenance_Item__c newEquipment = new Equipment_Maintenance_Item__c();
                    newEquipment.Equipment__c                  = equipment.Equipment__c;
                    newEquipment.Quantity__c                   = equipment.Quantity__c;
                    newEquipment.Maintenance_Request__c        = insertedCase.Id;
                    equipmentsToInsertList.add(newEquipment);
                }
            }
        }

        if(!equipmentsToInsertList.isEmpty()) {
            insert equipmentsToInsertList;
        }
    }          
    
}