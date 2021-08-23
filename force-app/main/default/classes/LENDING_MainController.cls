/*************************************************************
 * page controller 
 * 
 * perform page action logic
 * button click, filter, re-navigation
 * 
 *  created Aug,21,2021 Ray
 * 
 ***/
public  class LENDING_MainController implements LENDING_CoreFeature{

    // user Wrapper list
    public List<LENDING_UtilityUserWrapper> userWrapperList {get ;set;}
    public List<User> userList {get;set;}


    // search attribute
    public String recordCreatedDate {get; set;}
    public String recordClosedDate {get; set;}

    public LENDING_MainController() {
        this.userWrapperList = new List<LENDING_UtilityUserWrapper>();
    }

    public void build(){
        // data generation, user, lead, opps
        if(!Test.isRunningTest()){
            userList = LENDING_UserDAO.getRecords();
        }
        else{
            userList = LENDING_UserDAO.getTestRecords();
        }
        
        Set<Id> uIds = new Set<Id>();
        for (User u : userList) {
            uIds.add(u.Id);
        }

        // get init data, lead, opp ... if add more in future
        List<Lead> leadList = LENDING_LeadDAO.getRecordsByIdSet(uIds);
        List<Opportunity> oppList = LENDING_OpportunityDAO.getRecordsByIdSet(uIds);

        // init data
        Map<String,List<Object>> usersData = new Map<String,List<Object>>();
        usersData.put(LENDING_GlobalValue.LEAD_OBJECTTYPE,leadList);
        usersData.put(LENDING_GlobalValue.OPP_OBJECTTYPE,oppList);
        this.dataInitialization(usersData); 
        execute();
    }
   
    // data, records init - add lead,opp...data to object list with object type
    public void dataInitialization(Map<String,List<Object>> recordData){
        if(!this.userList.isEmpty()){
            for(User u : this.userList){
                LENDING_UtilityUserWrapper uWrapper = new LENDING_UtilityUserWrapper(u);
                this.userWrapperList.add(uWrapper);

                // leave each user data init work to user object
                uWrapper.dataInitialization(recordData);
                uWrapper.execute();
            }
        }
        
    }

    // execute logic after initial construction
    public void execute(){
        dataListClean();
    }

    public void dataListClean(){
        if(this.userWrapperList != null && this.userWrapperList.size() > 0){
            for(Integer i = 0; i < this.userWrapperList.size(); i++){
                if(this.userWrapperList[i].fetchLeadListSize() ==0 || this.userWrapperList[i].fetchOppListSize() ==0){
                    this.userWrapperList.remove(i);
                }
            }
        }
    }





    /*******************************************************************
     *  Controller Utility methods
     *  
     * @needs to build utility class to hold utility methods
     * 
     ******************************************************************/

    // controler actions like filters
    public PageReference runSearch(){
        Date day1 = null;
        Date day2 = null;

        try{
            if(this.recordCreatedDate != null && this.recordCreatedDate != ''){
                day1 = this.parseDateString(recordCreatedDate);
            }

            if(this.recordClosedDate != null && this.recordClosedDate != ''){
                day2 = this.parseDateString(recordClosedDate);
            }
        }
        
        
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }
        

        for(LENDING_UtilityUserWrapper ur : userWrapperList){
            ur.filterTheRecords(day1, day2);
            ur.execute();
        }

        return null;
    }

    // parse the date string to date type
    public Date parseDateString(String str){
        if(str != null && str != ''){
            Date returnDate = Date.parse(str);
            return returnDate;
        }
        return null;
    }



    // sort by table columns, col onclick action
    public void sortTableCol(){
        // passing col type as parameters to determine sort what column

        // sort the userWrapper list
        
        this.userWrapperList.sort();
        
        // vf page action rerender userWrapperlist on page

    }
}