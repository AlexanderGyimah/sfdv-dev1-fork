public with sharing class MultipleLeadsController {
	
	public list <Lead> leads { 
		get{
			if(leads == null ) leads = new list <Lead>();
			return leads;	
		}
			set;
	} 

	public PageReference saveAll()
	{
		set <String> leadsEmail = new set<String>(); 
		set <String> leadsName = new set<String>(); 
	
			for(Integer i = 0; i< Leads.size(); i++)
			{
				if(leadsEmail.contains(Leads[i].Email ) || leadsName.contains(Leads[i].FirstLast__c) || (Leads[i].FirstLast__c==''&&Leads[i].Email=='') )
				{
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'WARNING: Duplicate or empty record!'));
					Leads.remove(i);
				
				}else
				{
					leadsEmail.add(Leads[i].Email);
					leadsName.add(Leads[i].FirstLast__c);
				}
			}		

		
		List <Lead> dupleads = [SELECT Id, Email, FirstLast__c FROM Lead WHERE FirstLast__c IN :leadsEmail OR Email IN :leadsName];
		
		for(Lead dupLead: dupleads )
        {
        		for(Integer i = 0; i< Leads.size(); i++)
        		{
        			if((dupLead.Email == Leads[i].Email && Leads[i].Email != null) ||dupLead.FirstLast__c == leads[i].FirstLast__c  )
        			{
        				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'WARNING: '+leads[i].FirstName+', '+ leads[i].FirstLast__c+' is a duplicate!' ));
        				leads.remove(i);
        			}	
        		}
        }
        
       	try
       	{
        	insert leads;		 
        }
        catch (DMLException de) 
        { 
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, de.getDmlMessage(0)));
        	return null;
        }
        
        return null;
	}  

    public PageReference add() {
        	
        	Lead lead = new Lead();
        	leads.add(lead);
        	 
            return null;
        }    
}