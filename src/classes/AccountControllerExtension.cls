/* Hinzugefüg von Alexander:07.09.2015 9:44
   Hinzugefüg von Alexander:07.09.2015 10:07
* Controller Extension: Exercise 3  
* 
* @author      alexander.gyimah@accenture.com 
*
* @see		   Account_Extension.page	
*
* @version     1.0 2015-08-05  alexander.gyimah@accenture.com      first version 
* Änderung am Fork:07.09.2015 10:10
* Änderung am Master:07.09.2015 10:10
* Änderung am Master:07.09.2015 10:42
* Änderung am Master:07.09.2015 11:08
* Änderung am Master:07.09.2015 11:36
*/
public with sharing class AccountControllerExtension {

	private Account account;
	private ApexPages.StandardController stdController;

	public AccountControllerExtension(ApexPages.StandardController stdController)
	{
		this.account = (Account)stdController.getRecord();
		this.stdController = stdController;
	}
	
	public PageReference save()
	{ 
  		Savepoint sp = Database.setSavepoint();
  		this.stdController.save();
  		
  		this.account = (Account)stdController.getRecord();
  		
  		Opportunity opportunity = new Opportunity();
  		opportunity.Name = account.Name+' Generated Opportunity';
  		opportunity.AccountId =  this.account.Id;
  		opportunity.LeadSource = this.account.AccountNumber;
  		opportunity.CloseDate = Date.today();
  		opportunity.OwnerId = this.account.OwnerId;
  		opportunity.StageName = 'Qualification';
    	opportunity.Amount = 20000000;
    	
    	try{
    	
    	insert opportunity;
    	
    	} catch (DMLException de) 
        { 
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, de.getDmlMessage(0)));
        	Database.rollback(sp);
        	return null;
        }
        
    	
		Date startDate = Date.newInstance(Date.today().Year(), 1, 1); 
  		Date endDate = Date.today(); 
		AggregateResult aggregateresult = [SELECT SUM(Amount) sumrev FROM Opportunity WHERE CloseDate >= :startDate AND CloseDate<= :endDate AND AccountId =:  stdController.getId()];
  		account.Opportunity_Amount__c = (Decimal) aggregateresult.get('sumrev'); 
  		
  		
  		try{

  			update this.account;
  		
  		} catch (DMLException de) 
        { 
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, de.getDmlMessage(0)));
        	Database.rollback(sp);
        	return null;
        }
        
		PageReference pageRef = new PageReference('/'+this.account.Id);
		
  		return pageRef; 
	}
 

}