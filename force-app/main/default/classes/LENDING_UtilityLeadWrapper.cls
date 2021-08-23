public class LENDING_UtilityLeadWrapper implements LENDING_CoreFeature{
    
    // lead record
    public Lead l {get; set;}

    // owner user record
    public User u {get; set;}

    // lead create date field
    public DateTime leadCreatedDate {get; set;}

    // object type
    public String objType {get; set;}

    public LENDING_UtilityLeadWrapper(Lead l, User u) {
             
        // initial setup in constructor
        this.u = u;
        this.l = l;
        this.objType = LENDING_GlobalValue.LEAD_OBJECTTYPE;
        dataInitialization(null);
    }

    // data, record init
    public void dataInitialization(Map<String,List<Object>> recordData){
        if(l.createdDate != null){
            this.leadCreatedDate = l.createdDate;
        }
        
    }

    // execute logic after initial construction
    public void execute(){

    }

}