/************************************************
 * Wrapper class for one user behaviors
 * 
 * created Aug 21,2021 Ray
 * 
 * handle related opportunity/lead list logic
 * 
 ***/
public class LENDING_UtilityUserWrapper implements LENDING_CoreFeature,Comparable {
    
    // hold user record
    public User u {get; set;}

    // record object type
    public String objType {get; set;}

    //user object related items
    public List<LENDING_UtilityLeadWrapper> leadWrapperList {get; set;}

    // current user opportunity list
    public List<LENDING_UtilityOppWrapper> oppWrapperList {get; set;}



    /****************************************************************************
     * 
     * User Wrapper specific attributes
     * 
     * 
     *******************************/

    //conversion rate per user
    public Decimal conversionRate {get; set;}

    //conversion Max Created Date
    public String maxCreatedDate {get; set;}

    // total amount for opps
    public Decimal totalAmount {get; set;}

    // record created date
    public Date recordCreatedDate {get; set;}

    // record closed date
    public Date recordClosedDate {get; set;}

    // basic init
    public LENDING_UtilityUserWrapper(User u) {
        this.u = u;
        this.objType = LENDING_GlobalValue.USER_OBJECTTYPE;
        
        // init related list
        this.leadWrapperList = new List<LENDING_UtilityLeadWrapper>();
        this.oppWrapperList = new List<LENDING_UtilityOppWrapper>();

    }


    /*************************************************
     *  data, records init per user
     * 
     * **************/ 

    public void dataInitialization(Map<String,List<Object>> recordData){
        
        if(recordData != null && recordData.containsKey(LENDING_GlobalValue.LEAD_OBJECTTYPE)){
            List<Lead> orgLeadList = (List<Lead>)recordData.get(LENDING_GlobalValue.LEAD_OBJECTTYPE);

            if(!orgLeadList.isEmpty()){
                for(Lead ld : orgLeadList){
                    if(String.valueOf(ld.ownerId).equals(String.valueOf(u.Id))){
                        this.leadWrapperList.add(new LENDING_UtilityLeadWrapper(ld,u));
                    }
                }
            }
        }

        if(recordData != null && recordData.containsKey(LENDING_GlobalValue.OPP_OBJECTTYPE)){
            List<Opportunity> orgOppList = (List<Opportunity>)recordData.get(LENDING_GlobalValue.OPP_OBJECTTYPE);

            if(!orgOppList.isEmpty()){
                for(Opportunity opp : orgOppList){
                    if(String.valueOf(opp.ownerId).equals(String.valueOf(u.Id))){
                        this.oppWrapperList.add(new LENDING_UtilityOppWrapper(opp,u));
                    }
                }
            }
        }
    }
    

    // execute logic after initial construction (per user)
    public void execute(){
        this.conversionRate = this.calculateConvRate();

        DateTime dt = this.calculateMaxCreatedDate();
        if(dt != null){
            this.maxCreatedDate = dt.format('MMMMM dd, yyyy');
        }

        this.totalAmount = calculateOppTotalValue();
    }


    // implements comparable interface, for sort list by Total Leads column purpose
    public Integer compareTo(Object compareTo) {
        LENDING_UtilityUserWrapper compareUserWrapper = (LENDING_UtilityUserWrapper)compareTo;
        Integer result = 0;

        if(this.leadWrapperList.size() < compareUserWrapper.leadWrapperList.size()){
            return 1;
        }

        else if(this.leadWrapperList.size() > compareUserWrapper.leadWrapperList.size()){
            return -1;
        }

        return result;
    }


    /******************************************************
     *  UserWrapper specific util methods per one User below
     * 
     * 
     ********************************************/

    // get lead list size
    public Integer fetchLeadListSize(){
        return this.leadWrapperList.size();
    }

    // get opp list size
    public Integer fetchOppListSize(){
        return this.oppWrapperList.size();
    }

    // calculate conversion rate
    public Decimal calculateConvRate(){
        Decimal percentage = 0.00;
        
        if(this.leadWrapperList.size() > 0 && this.oppWrapperList.size() > 0){
            percentage = (Decimal.valueOf(this.fetchOppListSize()) / Decimal.valueOf(this.fetchLeadListSize()));
        }
        
        return percentage*100;
    }

    // calculate opp total value
    public Decimal calculateOppTotalValue(){
        if(oppWrapperList != null && oppWrapperList.size() > 0){
            Decimal totalVal = 0.00;
                for(LENDING_UtilityOppWrapper oppWrapper : oppWrapperList){
                    if(oppWrapper.amount != null){
                        totalVal += oppWrapper.amount;
                }
            }

            return totalVal;
        }
        return -1;
    }

    // calculate opp Max created Date
    public DateTime calculateMaxCreatedDate(){
        if(this.oppWrapperList.size() > 0){
            if(this.oppWrapperList.get(0) != null){
                DateTime currDateTime = this.oppWrapperList.get(0).oppCreatedDate;

                for(LENDING_UtilityOppWrapper oppWrapper : this.oppWrapperList){
                    if(currDateTime < oppWrapper.oppCreatedDate){
                        currDateTime = oppWrapper.oppCreatedDate;
                    }
                }

                return currDateTime;
            }
            
        }

        return null;
    }


    /********************************************************************************************
     * filter methods collection
     *
     *  description: 
     * 
     *  1) the filter will get the lead records created date > filter record created date AND
     *  2) the filter will get the opportunity records closed date < filter record closed date
     * 
     */

     public void filterTheRecords(Date startDate, Date endDate){

        // corner validation logic
        Integer daysDifference = startDate.daysBetween(endDate);
        if(startDate != null && endDate != null && endDate > startDate && daysDifference >= 31){
            this.recordCreatedDate = startDate;
            this.recordClosedDate = endDate;
            filterLeadsRecord();
            filterOppsRecord();
        }
        // filter the lead, opp wrapper list
     }

     // filter lead records by record created date
     public void filterLeadsRecord(){
         if(this.leadWrapperList != null && this.leadWrapperList.size() > 0){
            for(Integer i=0; i < leadWrapperList.size(); i++){
                if(this.leadWrapperList[i].leadCreatedDate != null){
                    if(this.recordCreatedDate < this.leadWrapperList[i].leadCreatedDate.date()){
                        this.leadWrapperList.remove(i);
                    }
                }
            }
         }
     }

     // filter opportunity records by record closed date
     public void filterOppsRecord(){
        if(this.oppWrapperList != null && this.oppWrapperList.size() > 0){
            for(Integer i = 0; i < this.oppWrapperList.size(); i++){
                if(this.oppWrapperList[i].closeDate != null){
                    if(this.recordClosedDate > this.oppWrapperList[i].closeDate){
                        this.oppWrapperList.remove(i);
                    }
                }
            }
         }
     }
}