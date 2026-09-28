//(a)

public static void updateContacts(List<Account> accounts) {
    for (Account acc : accounts) {
            List<Contact> contacts = [
            SELECT Id, AccountId, Description
            FROM Contact
            WHERE AccountId = :acc.Id
            ]; // SOQL query inside loop
        for (Contact con : contacts) {
        if (acc.Industry == 'Technology') {
            con.Description = 'Technology Customer';
            update con; // update inside loop
            }
        }
    }
}

//(B)

public static void safe(List<Account> accounts) {

    List<Contact> contacts = [
            SELECT Id, Description
            FROM Contact
            WHERE account.Industry = 'Technology'
            ];

    for (Contact con : Contacts) {
            
        con.Description = 'Technology Customer';
    }

    update Contacts;
}

//C
public static void safe(List<Account> accounts) {

    List<Contact> contacts = [
            SELECT Id, Description
            FROM Contact
            WHERE account.Industry = 'Technology'
            ];

    List<Contact> toUpdate = new list<Contact>
    for (Contact con : Contacts) {

        if (con.Description != 'Technology Customer'){
            con.Description = 'Technology Customer';
            toUpdate.add(con);
        }

    }

    update con;
}

// some contacts might already have that description from before so re updating it only wastes resources


// (d)

