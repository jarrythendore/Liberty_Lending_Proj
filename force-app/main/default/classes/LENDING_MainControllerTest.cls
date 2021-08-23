@IsTest(seeAllData=false)
public class LENDING_MainControllerTest {
    /**
     * dynmically set the created record size
     */
    public  static Integer leadLength;
    public  static Integer oppLength;
    public  static Integer userLength;

    public LENDING_MainControllerTest() {
        
    }

    @TestSetup
    static void initData(){
        List<User> testUsers = new List<User>();
        List<Lead> testLeads = new List<Lead>();
        List<Opportunity> testOpps = new List<Opportunity>();

        Profile userProfile = [
            SELECT
                    Id,
                    Name
            FROM
                    Profile
            WHERE   Name = 'System Administrator'
        ]; 

        for(Integer i=0; i < 5; i++){
            User testUser = new User(
                Alias = 'standt',
                Email = 'test'+i+'liberty_lending@email.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'userLastName'+i,
                LanguageLocaleKey = 'en_US',
                TimeZoneSidKey = 'America/Los_Angeles',
                UserName = 'testUserName'+i+'Lending@email.com',
                LocaleSidKey = 'en_US',
                profileId = userProfile.Id
            );

            testUsers.add(testUser);
        }

        insert testUsers;

        for(User userRecord : testUsers){
            for(Integer i = 0; i < 20; i++){
                Lead leadRecord = new Lead(
                    Status='New',
                    LastName='TestLast'+i,
                    FirstName='TestFirstName'+i,
                    Company='test company'+i,
                    Country='US', 
                    State='IL',
                    Phone='+8522345678'+i,
                    MobilePhone='+4522345678'+i,
                    Email='testemail'+i+'@test.com',
                    ownerId = userRecord.Id
                );
                testLeads.add(leadRecord);
            }

            for(Integer i = 0; i < 30; i++){
                Opportunity oppRecord = new Opportunity(
                    Name = 'TestOpp'+i,
                    StageName = 'Closed Won',
                    CloseDate = System.today()+(i*5),
                    Amount = (i * 200),
                    ownerId = userRecord.Id
                );
                testOpps.add(oppRecord);
            }
            
        }

        if(testLeads != null && testOpps != null){

                List<Database.SaveResult> leadResults = Database.insert(testLeads, false);
                List<Database.SaveResult> oppResults = Database.insert(testOpps, false);

                for (Database.SaveResult result : leadResults) {
                    if (!result.isSuccess()) {
                        System.debug(LoggingLevel.ERROR, result);
                    }
                }

                for (Database.SaveResult result : oppResults) {
                    if (!result.isSuccess()) {
                        System.debug(LoggingLevel.ERROR, result);
                    }
                }
            
        }
    }

    @IsTest
    public static void testInitializationMethod(){
        Test.startTest();
        Profile userProfile = [
            SELECT
                    Id,
                    Name
            FROM
                    Profile
            WHERE   Name = 'System Administrator'
        ]; 

        User testUser = new User(
                Alias = 'standt',
                Email = 'testQAliberty_lending@email.com',
                EmailEncodingKey = 'UTF-8',
                LocaleSidKey = 'en_US',
                LastName = 'userLastName',
                LanguageLocaleKey = 'en_US',
                TimeZoneSidKey = 'America/Los_Angeles',
                UserName = 'testUserNameQAlending@email.com',
                profileId = userProfile.Id
        );

        insert testUser;

        system.runAs(testUser){
            LENDING_MainController mainController = new LENDING_MainController();
            mainController.build();
            /**
             * assert Conv Rate before / after action
             */
            System.assertEquals(mainController.userWrapperList[0].calculateConvRate(),150.0);
            System.assertEquals(mainController.userWrapperList[1].calculateConvRate(),150.0);
            System.assertEquals(mainController.userWrapperList[2].calculateConvRate(),150.0);
            System.assertEquals(mainController.userWrapperList[3].calculateConvRate(),150.0);
            System.assertEquals(mainController.userWrapperList[4].calculateConvRate(),150.0);

            /***
             * assert lead / opp size before / after action
             */


             /*****
              * assert Max created date
              */


              /***
               * assert total value for opps
               * 
               */
            
            mainController.recordCreatedDate = '08/11/2021';
            mainController.recordClosedDate = '11/11/2021';
            mainController.runSearch();

            System.assertEquals(mainController.userWrapperList[0].calculateConvRate(),220.0);
            System.assertEquals(mainController.userWrapperList[1].calculateConvRate(),220.0);
            System.assertEquals(mainController.userWrapperList[2].calculateConvRate(),220.0);
            System.assertEquals(mainController.userWrapperList[3].calculateConvRate(),220.0);
            System.assertEquals(mainController.userWrapperList[4].calculateConvRate(),220.0);
            
        }

        Test.stopTest();
    }
}
