/**
* Generate the enviroment for the Unit Tests
* @author Sebastian Muñoz - Force.com Labs
* @createddate 06/08/2010
*/
public with sharing class AccountHierarchyTestData{
	
	/**
	* Set the necesary attributes used during test
	*/
    public static void createTestHierarchy(){
    	
    	InlineAcountHerachy_TestUtilities testUtils = new InlineAcountHerachy_TestUtilities();
    	//Set of Fields should be checked
    	Set<String> fieldsToCheck = new Set<String>{'AnnualRevenue', 'BillingCity','BillingCountry','BillingPostalCode','BillingState', 'BillingStreet', 'Description', 'ShippingCity', 'ShippingStreet', 'Name', 'ShippingState', 'ShippingPostalCode', 'ShippingCountry' };
		
		//Create my Parent Account 
		testUtils.createAccounts( 1 , fieldsToCheck );
 		testUtils.testAccList[0].Name = 'HierarchyTest0';
 		testUtils.updateAccountList( fieldsToCheck );
 		
 		Account parentAccount = testUtils.testAccList[0];
        Id parentID = parentAccount.Id;
        System.Assert( parentID != null , 'Parent Id not found' );
        
        // Create 10 sub accounts
    	testUtils.createAccounts( 10 , fieldsToCheck );
    	Integer i = 0;
        for ( Account accAux : testUtils.testAccList ){ //Now i need change the names
        	accAux.Name = 'HierarchyTest' + String.valueOf( i );
            i++;
        }
        testUtils.updateAccountList( fieldsToCheck );        
        
        List<Account> accountList = [ Select Id, parentID, name from account where name like 'HierarchyTest%' ORDER BY Name limit 10 ];
                
        for ( Integer x = 0; x < accountList.size(); x++ ){
            if ( accountList[x].name != 'HierarchyTest0' ){
                accountList[x].parentID = parentID;
                parentID = accountList[x].Id; 
            }
        }
        
        testUtils.testAccList.clear();
        testUtils.testAccList.addAll( accountList );
        testUtils.updateAccountList( fieldsToCheck );

		// Create 10 sub accounts
		Account subTreeParent = [ Select id, parentID, name from account where name = 'HierarchyTest4' limit 10 ];
        parentID = subTreeParent.Id;
        testUtils.createAccounts( 10, fieldsToCheck );
    	 
		i = 0;
		for ( Account accAux : testUtils.testAccList ){ //Now i need change the names
        	accAux.Name = 'HierarchyTest' + '4.' + String.valueOf( i );
        }
		testUtils.updateAccountList( fieldsToCheck );

        List<Account> subAccountsList = [ Select Id, parentID, Name from Account where Name like 'HierarchyTest4%' limit 10  ];
        for ( Integer z = 1; z < subAccountsList.size(); z++ ){
            subAccountsList[z].parentID = parentID;
            parentID = accountList[z].Id; 
        }
        
        testUtils.testAccList.clear();
        testUtils.testAccList.addAll( subAccountsList );
    }
}