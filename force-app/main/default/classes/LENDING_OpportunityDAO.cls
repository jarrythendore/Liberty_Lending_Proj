/****************************************************
 *  data access class - control records query / generation
 *  
 *  created Aug 21,2021 Ray
 */

public class LENDING_OpportunityDAO implements LENDING_CoreDAO{
    public LENDING_OpportunityDAO() {

    }

    // implements core method
    public static List<Opportunity> getRecords(){
        return null;
    }

    // implement core method
    public static Opportunity getRecordByID(String recordId){
        return null;
    }

    // implement core method
    public static List<Opportunity> getRecordsByIdSet(Set<Id> idSet){
        List<Opportunity> oppList = [
            SELECT
                    Id,
                    Name,
                    createdDate,
                    CloseDate,
                    StageName,
                    Amount,
                    OwnerId
            FROM
                    Opportunity
            WHERE   ownerId IN: idSet
        ];
        return oppList;

    }

    // implement core method
    public static List<Opportunity> getRecordsByParentId(String recordId){
        
        return null;
    }
}