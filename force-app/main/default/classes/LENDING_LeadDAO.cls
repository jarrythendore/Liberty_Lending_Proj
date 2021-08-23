/*************************************
 * implements Core DAO interface, 
 * 
 * provide service for all lead records generation/Query
 * 
 */
public class LENDING_LeadDAO implements LENDING_CoreDAO{
    
    public LENDING_LeadDAO() {
   
    }

    // implements core method
    public static List<Lead> getRecords(){
        return null;
    }

    // implement core method
    public static Lead getRecordByID(String recordId){
        return null;
    }

    // implement core method
    public static List<Lead> getRecordsByIdSet(Set<Id> idSet){

        List<Lead> leadList = [
            SELECT
                    Id,
                    Name,
                    createdDate,
                    Company,
                    LeadSource,
                    OwnerId
            FROM
                    Lead
            WHERE   ownerId IN: idSet
        ];
        return leadList;
    }

    // implement core method
    public static List<Lead> getRecordsByParentId(String recordId){
        List<Lead> leadList = [
            SELECT
                    Id,
                    Name,
                    createdDate,
                    Company,
                    LeadSource
            FROM
                    Lead
            WHERE   ownerId =: recordId
        ];
        return leadList;
    }
}