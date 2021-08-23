/*************************************************************
 * @ Opportunity wrapper class - deal with opportunity object
 * related feature and functions
 * 
 * Aug 21, 2021
 * 
 * Ray
 * 
 ****************/

public class LENDING_UtilityOppWrapper implements LENDING_CoreFeature{
    
    // opportunity
    public Opportunity o {get; set;}

    // related user
    public User u {get; set;}

    // object type
    public String objType {get; set;}

    // wrapper of stage field
    public String oppStage {get; set;}

    // wapper of close date field
    public Date closeDate {get; set;}

    // wrapper of created date field
    public DateTime oppCreatedDate {get; set;}

    // fields
    public Decimal amount {get; set;}

    public LENDING_UtilityOppWrapper(Opportunity o, User u) {

        // init basic information
        this.o = o;
        this.u = u;
        this.objType = LENDING_GlobalValue.OPP_OBJECTTYPE;

        dataInitialization(null);
    }

    // data,records init
    public void dataInitialization(Map<String,List<Object>> recordData){
        if(o.createdDate != null){
            this.oppCreatedDate = o.createdDate;
        }
        
        if(o.StageName != null){
            this.oppStage = String.valueOf(o.StageName);
        }

        if(o.CloseDate != null){
            this.closeDate = o.CloseDate;
        }

        if(o.Amount != null){
            this.amount = o.Amount;
        }
    }
    

    // execute logic after initial construction
    public void execute(){

    }
}