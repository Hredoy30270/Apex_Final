// An organization has created a custom object called Customer_Assessment__c.
// A developer writes an Apex class that:
// ● Retrieves Customer Assessment records.
// ● Reads the fields Risk_Score__c and Internal_Comment__c.
// ● Updates Approval_Status__c.
// The class is called by users with different profiles and permission sets. During a security review, it is
// discovered that some users can execute the Apex code even though they should not be able to view certain
// assessment records or access Internal_Comment__c.
// a) Explain the difference between record-level access and object/field-level access in the context of this
// scenario. (2 Marks)
// b) Show how you would design the Apex class declaration and data-access operations so that the user’s
// record-level access is appropriately considered. (2 Marks)
// c) Describe how CRUD and field-level security should be enforced when querying or updating the fields used
// by this service. Include appropriate modern Apex security mechanisms where relevant. (3 Marks)
// d) Assume the class currently executes its query and DML operations without considering the running user’s
// access. Identify the security risks this creates and describe how you would redesign the service securely.



//(a)


// in this scenario record level access would be the ability of the user to create edit delete the records owned by them or are explicitly shared with them
// object/field level access in this scenario would be the ability to create a record for than object/ or access a field of that object.

//(B)
public with sharing class CustomClass {

    public static void exampleMethod() {

        list<Customer_Assessment__c> cust = [select id, name from Customer_Assessment__c With USER]; // also ans for C

        // this SOQL will only return records the running user has access to

        // do operations 
        update cust AccessLevel User; // ans for C
    }
}




//(d) as the query and dml operation dont enforce users accesslevel this could mean users could read edit or delet data that they shouldn't have access to, this could also mean users could get access to classified data

// to fix this we should implement 'with sharing' in class declaration , use With USER in soql query and use AccessLevel User in DML operations. 