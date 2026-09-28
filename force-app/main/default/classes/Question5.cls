// A company imports Leads from several external partners. A nightly Apex process receives 500 Lead records
// and attempts to insert them into Salesforce.
// Some records may fail because of validation rules, duplicate rules, missing required information, or other
// DML errors. The current implementation is:
// try {
// insert leadsToInsert;
// } catch (Exception e) {
// System.debug('Error');
// }
// Management does not want the entire import to fail because a small number of Leads contain invalid data.
// Failed records must be identified for further investigation, while valid records should still be processed when
// appropriate.
// a) Identify the weaknesses in the current error-handling implementation. (2 Marks)
// b) Design or write Apex logic that allows valid Lead records to succeed while capturing detailed information
// about records that fail. (3 Marks)
// c) Explain how meaningful exception handling should be structured when an operation may encounter DML
// errors. Include the role of try, catch, and finally where each is appropriate. (2 Marks)
// d) Describe what error information should be recorded or returned so that support teams can investigate
// individual failed records without relying only on debug logs. (3 Marks)


//(a)

// the current implementation is of DML operation where if there is problem with a single record, the entire operation fails, and no information about which records failed or why is captured except for a generic debug message. There is no partial success,


//(b)




public with sharing class Question5 {
    public Question5() {

        Database.SaveResult[] results = Database.insert(leadsToInsert, false);

        for (Database.Saveresult result: results){
            if (result.isSuccess()) {

                System.debug(result.getId());

            } else {

                for (Database.Error error :
                    result.getErrors()) {

                    System.debug(error.getMessage());
                }
            }
        }
     }
}


//(c) a way to handle exceptions meaningfully when an error has occured is by catching the error and investigating the error message. we can do it by using system.debug to show the error message in the log, or we can sent the error message to external sites where engineers can debug the error message.


//(d) error.getMessage(), the line and column of the error should be recorded for debugging later on 
