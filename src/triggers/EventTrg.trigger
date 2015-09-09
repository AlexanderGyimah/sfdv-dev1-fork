trigger EventTrg on Event (after insert, after update, after delete, after undelete ) {


	if(trigger.isInsert== true || trigger.isUndelete )
	{
		map <Id, Event> newEvents = new map <Id, Event>(trigger.new);
		Set <String> accountIds = new Set <String>();
		for(Event event: trigger.new)
		{
			accountIds.add(event.accountId);
		}
		
		ActivityCountHelper.activityCounter(accountIds);	
		
	}

	if(trigger.isUpdate == true)
	{	
		Set <String> accountIds = new Set <String>();
		map <Id, Event> oldEvents = new map <Id, Event>();
		 
		oldEvents.putAll(trigger.old); 
		
		for(Event event: trigger.new )
		{
			if(event.accountId != oldEvents.get(event.Id).accountId )
			{
				accountIds.add(event.accountId);
			}
		}
		
		ActivityCountHelper.activityCounter(accountIds);	
		
	}
	if(trigger.isDelete)
	{
		Set <String> accountIds = new Set <String>();
		for(Event event: trigger.old)
		{
			accountIds.add(event.accountId);
		}
		
		ActivityCountHelper.activityCounter(accountIds);		
	}
	
}