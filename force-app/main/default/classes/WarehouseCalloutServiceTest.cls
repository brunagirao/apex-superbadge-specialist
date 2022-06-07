@IsTest
private class WarehouseCalloutServiceTest {
    
    @IsTest
    public static void getInventoryTest() {

        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        WarehouseCalloutService service = new WarehouseCalloutService();
        HttpResponse response = WarehouseCalloutService.getInventory();
        service.execute(null);
        // Verify that the response received contains fake values
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = response.getBody();
        System.debug(response.getBody());
        String expectedValue =  
        +'['
            +'   {'
            +'      "_id":"55d66226726b611100aaf741",'
            +'      "replacement":false,'
            +'      "quantity":5,'
            +'      "name":"Generator 1000 kW",'
            +'      "maintenanceperiod":365,'
            +'      "lifespan":120,'
            +'      "cost":5000,'
            +'      "sku":"100003"'
            +'   },'
            +'   {'
            +'      "_id":"55d66226726b611100aaf742",'
            +'      "replacement":true,'
            +'      "quantity":183,'
            +'      "name":"Cooling Fan",'
            +'      "maintenanceperiod":0,'
            +'      "lifespan":0,'
            +'      "cost":300,'
            +'      "sku":"100004"'
            +'   },'
            +'   {'
            +'      "_id":"55d66226726b611100aaf743",'
            +'      "replacement":true,'
            +'      "quantity":143,'
            +'      "name":"Fuse 20A",'
            +'      "maintenanceperiod":0,'
            +'      "lifespan":0,'
            +'      "cost":22,'
            +'      "sku":"100005"'
            +'   }'
        +']';
        System.assertEquals(expectedValue, actualValue);
        System.assertEquals(200, response.getStatusCode());
    }

}