//(a) responsibility of start() is to fetch the relavant data to work with in the batch. pass that data to execute()

// execute() gets data from  start() and starts batching the data appropriately, if the batch size is not given it defaults to 200 per batch

// finish () is there to perform tasks after the batch process has ended like sending an email or to show statistics of the batch process


//(b)
public with sharing class question6 implements Database.Batchable<Accounts> {

    public Database.QueryLocator start(Database.BatchableContext context) {
        // TODO: add a WHERE clause to filter records
        return Database.getQueryLocator([SELECT Id,annualRevenue,Customer_Tier__c FROM Accounts where status = 'Active' ]);
    }

    public void execute(Database.BatchableContext context, List<Accounts> scope) {
        for (Accounts acc: scope){
            acc.Customer_Tier__c = getTier(acc.annualRevenue);
        }

        update scope;
    }

    public void finish(Database.BatchableContext context) {

    }

    private static string getTier(Decimal ar){

        if (ar>=10000000){
            return 'Enterprise';
        }
        else if ( ar >=1000000){
            return 'Medium';
        }
        else {
            return 'Small';
        }
        
    }
}



///(c)

// the scope size matters because salesforce is a multi-tenent system and there are limits to how many SOQL or DML operations or callouts can we make in a single transaction. it may be higher for asynchronous processing but it still has limits. if we have 1m data and we try a batch size of 10 we will need 100000 soql invocations, which will get over the limit we have. so wee need to be mindful while choosing the size of scope.


//(d)

// do get the final summary the batch class must implement 'Database.stateful'
// this is what lets us preserve variables or other things that need to stay without being distroyed among each batch execution runs. 

// and then we can show them in the finally() section which will run after all the batch has been processes.