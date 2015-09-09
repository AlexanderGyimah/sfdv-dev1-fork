trigger TaskTrg on Task (after insert, after update, after delete, after undelete) {

	if(trigger.isInsert== true || trigger.isUndelete )
	{
		Set <String> accountIds = new Set <String>();
		for(Task task: trigger.new)
		{
			accountIds.add(task.accountId);
		}
		
		ActivityCountHelper.activityCounter(accountIds);	
		
	}

	if(trigger.isUpdate == true)
	{	
		Set <String> accountIds = new Set <String>();
		map <Id, Task> oldTasks = new map <Id, Task>();
		 
		oldTasks.putAll(trigger.old); 
		
		for(Task task: trigger.new )
		{
			if(task.accountId != oldTasks.get(task.Id).accountId )
			{
				accountIds.add(task.accountId);
			}
		}
		
		ActivityCountHelper.activityCounter(accountIds);	
	}
	
	if(trigger.isDelete)
	{
		Set <String> accountIds = new Set <String>();
		for(Task task: trigger.old)
		{
			accountIds.add(task.accountId);
		}
		
		ActivityCountHelper.activityCounter(accountIds);		
	}	
}