/*************************************
 * implements Core DAO interface, 
 * 
 * provide service for all user records generation/Query
 * 
 */

public class LENDING_UserDAO implements LENDING_CoreDAO{
    public LENDING_UserDAO() {

    }

    // implements core method
    public static List<User> getRecords(){
        List<User> userList = [
            SELECT 
                    Id,
                    Name,
                    username,
                    Email,
                    LanguageLocaleKey,
                    EmailEncodingKey,
                    TimeZoneSidKey,
                    profileId,
                    LocaleSidKey
            FROM
                    User
            WHERE   
                    username != 'automatedclean@00d5f000000hfzceag' 
            AND     
                    username != 'chatty.00d5f000000hfzceag.zhcxq8mymty9@chatter.salesforce.com'
        ];

        /**
         * filter system assigned user records
         */
        return userList;
    }

    public static List<User> getTestRecords(){
        List<User> userList = [
            SELECT 
                    Id,
                    Name,
                    username,
                    Email,
                    LanguageLocaleKey,
                    EmailEncodingKey,
                    TimeZoneSidKey,
                    profileId,
                    LocaleSidKey
            FROM
                    User
            WHERE
                    username
            LIKE
                    'testUserName%'
            
            LIMIT   5
        ];
        return userList;
    }
    
    /*
    public List<User> getRecords(){
        List<User> userList = [
            SELECT
                    Id,
                    Name,
            (SELECT
                    Id,
                    Name
            FROM    Owner),
            (SELECT Id,
                    Name
            FROM    Owner)

            FROM    User
            LIMIT   5
        ];
        return null;
    }
    */

    // implement core method
    public static User getRecordByID(String recordId){
        return null;
    }

    // implement core method
    public static List<User> getRecordsByIdSet(Set<Id> idSet){

        return null;
    }

    // implement core method
    public static List<User> getRecordsByParentId(String recordId){
        
        return null;
    }
}