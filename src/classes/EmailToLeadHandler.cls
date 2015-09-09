global without sharing class EmailToLeadHandler implements Messaging.InboundEmailHandler {
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
	    
		    Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();  		 
		    
			try 
			 {
			
		     Lead newLead = new Lead();
			 newLead.FirstName = email.fromname.substring(0,email.fromname.indexOf(' '));
			 newLead.LastName = email.fromname.substring(email.fromname.indexOf(' '));
			 newLead.Email = envelope.fromAddress;
			 
			 if(email.plainTextBody!= null)
			 {
			 	newLead.Description = email.plainTextBody; 
			 
			 }else
			 {
			 	newLead.Description = email.htmlBody; 
			 }
			 				
			 newLead.Company=envelope.fromAddress.substring(envelope.fromAddress.indexOf('@')+1,envelope.fromAddress.lastIndexOf('.'));	 
			 insert newLead;
			 result.success = true; 
			 return result;
			 		
			 }
		     catch (DMLException dex) 
			 {   
			   Log__c dmlLog = new Log__c();
			   dmlLog.Name = 'DMLException';
			   dmlLog.Description__c = 'DMLException ====>'+dex.getMessage();
			   insert dmlLog;
			   result.success = false; 
			   return result;
			        
			 }
			 catch(Exception ex)
			 {
			   Log__c log = new Log__c();
			   log.Name = 'Exception';
			   log.Description__c = 'Exception ====>'+ex.getMessage();
			   insert log;
			   result.success = false; 
			   return result;
			   
			 }		
			
			}  
	}