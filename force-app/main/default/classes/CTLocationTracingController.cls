public with sharing class CTLocationTracingController {
    public static list<Location_Tracing__c> getVisitors(String locationId){
        return [SELECT Id, Person__c, Visit_Date__c, Location__c, Person__r.Token__c, Person__r.Health_Status__c
        FROM Location_Tracing__c
        WHERE Id =:locationId
        ORDER BY Visit_Date__c DESC ];
    }

    public static List<Location_Tracing__c> getLocationsByPersonIds(Set<Id> personIds){
     return [SELECT Id, Person__c, Location__c
            FROM Location_Tracing__c
            WHERE Person__c IN :personIds
            AND Visit_Date__c = LAST_N_DAYS:10];
    }

    public static List<Location_Tracing__c> getLocationsByLocationIds(Set<Id> locationIds){
        return [SELECT Id, Person__c, Location__c
               FROM Location_Tracing__c
               WHERE Location__c IN :locationIds
               AND person__r.Health_Status__c = 'Green'
               AND Visit_Date__c = LAST_N_DAYS:10];
}
    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> newLocationTraces){
        Set<Id> locationIds = new Set<Id>();
        Set<Id> personIds = new Set<Id>();
        for (location_tracing__c trace : newLocationTraces) {
            locationIds.add(trace.Location__c);
            personIds.add(trace.Person__c);
        }
        Map<Id, Set<Id>> MapOfExistingRecords = new Map<Id, Set<Id>>();
        List<Location_Tracing__c> existingRecords = [SELECT Id, Person__c, Location__c
                                                        FROM Location_Tracing__c
                                                        WHERE Location__c IN :locationIds
                                                        AND person__c IN :personIds];
            List<Location_Tracing__c> duplicates = new List<Location_Tracing__c>();
            if(existingRecords != null && existingRecords.size() > 0){
            for (Location_Tracing__c trace : existingRecords) {
                if(! MapOfExistingRecords.containsKey(trace.Location__c)){
                    MapOfExistingRecords.put(trace.Location__c, new Set<Id>());
                }

                MapOfExistingRecords.get(trace.Location__c).add(trace.Person__c);                
            }
            for (Location_Tracing__c trace : newLocationTraces) {
                if(MapOfExistingRecords.containsKey(trace.Location__c) && MapOfExistingRecords.get(trace.Location__c).contains(trace.Person__c)){
                    duplicates.add(trace);
                }
            }
        }

        return duplicates;
    }
}