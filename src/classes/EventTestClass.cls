@isTest
public with sharing class EventTestClass {
	
	@testSetup static void setupData() {
		
		Account account1 = new Account();
		account1.Name ='TestAccount1';
		insert account1;
		
		Account account2 = new Account();
		account2.Name ='TestAccount2';
		insert account2;
		
		Account refAccount1 = [SELECT id, Activity_Count__c FROM Account WHERE Name = 'TestAccount1'];
		List <Event> events = new List <Event>(); 
		
		for (Integer counter1 = 0; counter1 < 10; counter1++)
		{
		
			Event newEvent = new Event(); 
			newEvent.Subject ='Test'+counter1;
			newEvent.ActivityDateTime= DateTime.newInstance(2016, 7, 19, 10, 7, 12);
			newEvent.DurationInMinutes=10;
			newEvent.WhatId = refAccount1.id;
	        events.add(newEvent);
	
		}	
		
		insert events;	
	}
	static testMethod void validateActivityCountEvent ()
	{		
		
	
		
		Account validateAccount1 = [SELECT id, Activity_Count__c FROM Account WHERE Name = 'TestAccount1' Limit 10];
		System.Assert(Integer.valueof(validateAccount1.Activity_Count__c) == 10,'Test1: Counter fuer TestAccount1 falsch.');
		
		Account refAccount2 = [SELECT id, Activity_Count__c FROM Account WHERE Name = 'TestAccount2' Limit 10];
		List <Event> changeEvents= [SELECT Subject,ActivityDateTime,DurationInMinutes,WhatId FROM Event Limit 10];
		
		 for(Integer counter2 = 0; counter2 < 10; counter2)
		 {
		 	//changeEvents[counter2].WhatId = refAccount2.id; 
		 }
		 
				
	}
}