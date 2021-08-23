/***************************************************************
 * 2021 Ray.
 * core behavior for all sub wrapper classes
 * 
 * Created by Ray, Aug 21,2021
 *
 * 
 * ***********************************************************/
public Interface LENDING_CoreFeature {
  
    /*********************
     * data, records init
     * 
     */
    void dataInitialization(Map<String,List<Object>> recordData);
    
    
    /*********
     * execute after constructor
     */
     void execute();
}