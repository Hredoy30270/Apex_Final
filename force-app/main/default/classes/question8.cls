

//(a)

// we would need to first create a new external credential and add a principal to it. then give appropriate personnels access to that principal by either using permission sets or profiles.
// then we will assign the external credential to a named credential, where we will add the url of the host we want to fetch data from.
// we may need to configue header based on requrement.
// in apex we will use callout:<named_credential>/<rest_of_url> and quere the endpoint


//(b)

public with sharing class question8 {
    public question8(string cur) {

        Http http = new Http();

        HttpRequest request =
            new HttpRequest();

        request.setEndpoint(
            'callout/<named_credential>/<rest_of_url>'+ cur
        );

        request.setMethod('GET');

        request.setHeader(
            'Content-Type',
            'application/json'
        );

        HttpResponse response =
            http.send(request);


        if (response.getStatus() = 200){
            Map<String, Object> data =
                (Map<String, Object>)
                JSON.deserializeUntyped(
                    response.getBody()
            );

            Decimal rate =
                (Decimal) data.get('rate');
        }

        //(C)
        else {
            if (response.getStatus() = 400){
                return 'Invalid currency';
            }
            else if (response.getStatus() = 401){
                return 'Authentication failed';
            }
            else {
                return 'Database Unavailable';
            }
        }
        

    }
}


//(d)

// if we try to do all the callouts for 500 opportunities in a synchronous transaction we will hit the governor limit for apex callouts. 
//instead we must implement the following architechture:
//-fetch echangerates periodically (once everyday) and store them in a history object
// when fire a trigger on the history object to check if the data has updater or not. if the values have changed then run a batch operation on the database to process all the records
// with this aproach api's are only being called as many unique currecy that needs to fetched and not for 500 opportunities. and the stored value is what is being used to update the opportunities. 