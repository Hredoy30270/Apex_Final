trigger OpportunityTrigger on Opportunity (after insert, after update) {
    for (Opportunity opp : Trigger.new) {
        Account acc = [
        SELECT Id, Strategic__c
        FROM Account
        WHERE Id = :opp.AccountId];
        List<Opportunity> opportunities = [
            SELECT Id, Amount
            FROM Opportunity
            WHERE AccountId = :opp.AccountId
            ];
        Decimal totalAmount = 0;
        for (Opportunity item : opportunities) {
            if (item.Amount != null) {
            totalAmount += item.Amount;
        }
        }
        if (totalAmount >= 5000000) {
            acc.Strategic__c = true;
            update acc;
        }
    }
}

// (a)

// SOQL query inside loop
// DML inside loop
// DML not using bulkified trigger pattern
// DML not using with user 
// governor limits violation

// (b)

// while querying for Opportunities inside the loop, a SOQL query is executed for each Opportunity record, which can quickly exceed governor limits in bulk operations. As Salesforce in multi-tenet Governor Limits are strictly followed

//(c)

// Redesign

//
trigger OpportunityTrigger_2 on Opportunity (after insert, after update) {

    Set<Id> accountIds = new Set<Id>();

    for (Opportunity opp : Trigger.new) {
        if (opp.AccountId != null) {
            accountIds.add(opp.AccountId);
        }
    }
    List<Opportunity> opps = [SELECT Id, Amount, AccountId FROM Opportunity WHERE AccountId IN :accountIds];

    Decimal total = 0;
    Map<Id, Decimal> accountIdToTotal = new Map<Id, Decimal>();
    for (Opportunity opp : opps) {
        if (opp.Amount != null) {
            if (!accountIdToTotal.containsKey(opp.AccountId))accountIdToTotal.put(opp.AccountId, opp.Amount);
            else accountIdToTotal.put(opp.AccountId, accountIdToTotal.get(opp.AccountId) + opp.Amount);
        }


        }
    List<Account> accountsToUpdate = new List<Account>();
    for (Id accId : accountIdToTotal.keySet()) {
        if (accountIdTotal.get(accId) >= 5000000) {
            accountsToUpdate.add(new Account(Id = accId, Strategic__c = true));
        }
    }

    if (!accountsToUpdate.isEmpty){
        update accountsToUpdate;
    }
};



//(d)


// I would  organize the trigger by creating trigger handler class separately and pass the trigger context to the apropriate trigger handler class based on the trigger type 