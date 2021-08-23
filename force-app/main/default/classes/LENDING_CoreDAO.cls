public  Interface LENDING_CoreDAO {
    /***************************
     * data access class.
     * function of getting records / record
     * 
     * @created Aug,21,2021 Ray
     */
    Object getRecordByID(String recordId);

    List<Object> getRecords(); 

    List<Object> getRecordsByIdSet(Set<Id> idSet);

    List<Object> getRecordsByParentId(String recordId);
}