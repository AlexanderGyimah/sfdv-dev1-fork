/** 
* Triggers: exercise 2  
* 
* @author      alexander.gyimah@accenture.com 
*
* @version     1.0 2015-07-30  alexander.gyimah@accenture.com      first version 
*/

trigger ContactTrg on Contact ( before insert, before update) {


	if((trigger.isInsert||trigger.isUpdate)&&trigger.isBefore)
	{	
		map<String, Contact> tempContactsEmail = new map<String, Contact>();
		map<String, Contact> tempContactsName = new map<String, Contact>(); 
		set <String> contactsEmail = new set<String>(); 
		set <String> contactsName = new set<String>(); 
		
		for (Contact contact: trigger.new)
		{
			if(tempContactsName.containsKey(contact.FirstLast__c) == false)
			{
				tempContactsName.put(contact.FirstLast__c, contact);
			}else
			{
				contact.addError('Duplicate record');
			}
			if(tempContactsEmail.containsKey(contact.Email) == false)
			{
				tempContactsEmail.put(contact.Email, contact);
			}else
			{
				contact.addError('Duplicate record');
			}
			if(tempContactsEmail.containsKey(contact.Email) && tempContactsName.containsKey(contact.FirstLast__c) )
			{	
				contactsEmail.add(contact.Email);
				contactsName.add(contact.FirstLast__c);
			}		
		}
			
	     List<Contact> contacts = [SELECT id,Email,FirstLast__c FROM Contact WHERE Email IN :contactsEmail OR FirstLast__c IN :contactsName];
	        
	     for (Contact dupContacts: contacts)
	     {      
			for(Contact contact: trigger.new)
			{
				if(contact.Email == dupContacts.Email || contact.FirstLast__c == dupContacts.FirstLast__c )
				{
	
					contact.addError('Duplicate record: <a href=\'https://na1.salesforce.com/'  + dupContacts.id + '\'>Record ' + dupContacts.id + '</a>', false);
					
				}		
			}
	     }  
	}
}