public with sharing class WarehouseCalloutService implements Queueable, Database.AllowsCallouts {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';

    public void execute(QueueableContext qc) {
        getInventory();
       
    }

    public static HttpResponse getInventory() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        //set endpoint
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        //send request to heroku
        HttpResponse response = http.send(request);

        if(response.getStatusCode() >= 200 && response.getStatusCode() < 300) {
            //get body of response
            List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());
            //auxiliar list to do upsert in the products
            List<Product2> productList = new List<Product2>();
            
            //iterate to results
            for(Object result : results) {
                //casting each result(product) in a map
                Map<String, Object> productMap = (Map<String, Object>) result;
                System.debug('productMap' + productMap);
                //create a new product in each iteration
                Product2 product = new Product2();
                
                //fill products fields with values get of the productMap
                product.Replacement_Part__c     = (Boolean)productMap.get('replacement');
                product.Current_Inventory__c    = (Integer)productMap.get('quantity');
                product.Name                    = (String)productMap.get('name');
                product.Maintenance_Cycle__c    = (Integer)productMap.get('maintenanceperiod');
                product.Lifespan_Months__c      = (Integer)productMap.get('lifespan');
                product.Cost__c                 = (Integer)productMap.get('cost');
                product.Warehouse_SKU__c        = (String)productMap.get('_id');
                product.ProductCode             = (String)productMap.get('sku');
                
                //add to list
                productList.add(product);
            }
            System.debug('productList' + productList);
            //if the list has records
            if(!productList.isEmpty()) {
                //then, upsert products
                upsert productList Warehouse_SKU__c;
            }
        }
        return response;
    } 
}