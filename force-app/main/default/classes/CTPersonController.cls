public with sharing class CTPersonController {
  public static string getToken(String mobileNumber){
    Blob value = Blob.valueOf(mobileNumber);
    Blob hash = Crypto.generateDigest('MD5', value);

    //string sonuc
    return EncodingUtil.base64encode(hash);
  }

public static List<Person__c> getRecentHealthChanges(){
 return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
 FROM Person__c 
 ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
}
public static List<Person__c> searchpeople(String SearchTerm){
  SearchTerm = SearchTerm + '%';
return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c FROM Person__c WHERE Name LIKE :SearchTerm OR Mobile__c LIKE :SearchTerm OR Token__c LIKE :SearchTerm ORDER BY Status_Update_Date__c DESC NULLS LAST];
}
public static Person__c getpersonbyid(String personID){
  list<Person__c> people = [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c FROM Person__c WHERE Id =:personId];
   if (people != null && people.size() > 0){
    return people[0];
   }
   return null;
}
}