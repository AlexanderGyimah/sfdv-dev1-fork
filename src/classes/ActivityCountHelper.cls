public with sharing class ActivityCountHelper {

	public static void activityCounter (Set <String> accountIds )
	{	
		List <Account> accounts = [SELECT Id, (SELECT Id FROM OpenActivities) FROM Account WHERE (Id IN :accountIds)];
		
		for(Account account:  accounts)
		{
			account.Activity_Count__c=account.OpenActivities.Size();
		}			
				
		Database.saveResult[] saveResults = Database.update(accounts,false);
				
		for(Integer i = 0; i < saveResults.size(); i++)
		{
			Database.saveResult saveResult = saveResults[i];
			if(!saveResult.isSuccess())
			{
				for(Database.Error error : saveResult.getErrors()) accounts[i].addError(error.getMessage());
			}
		}
	}
		

}