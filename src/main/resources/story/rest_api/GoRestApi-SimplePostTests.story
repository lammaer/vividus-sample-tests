Description: GoRest API call, simple POST user tests

Scenario: POST001 Create user with random email and verify JSON response.
!-- problem: the email address can be used only once. Lets use a random email address
Given I initialize scenario variable `randomemail` with value `#{generate(Internet.emailAddress)}`
Given request body: {
    "name": "Test user",
    "email": "${randomemail}",
    "gender": "female",
    "status": "active"
}
!-- need bearer token header, variable defined in the suite properties
When I set request headers:
|name        |value           |
|Authorization|Bearer ${bearer-token}|
|Content-Type|application/json|
When I execute HTTP POST request for resource with relative URL `${user-endpoint}`
Then response code is equal to `201`
Then JSON element from `${response}` by JSON path `$` is equal to `
{
    "name": "Test user",
    "email": "${randomemail}",
    "gender": "female",
    "status": "active"
}
` IGNORING_EXTRA_FIELDS
When I save JSON element value from `${response}` by JSON path `$.id` to scenario variable `userID`
!-- check if userID is integer
Then `${userID}` matches `^\d+$`
!-- cleanup part: delete the freshly created user
When I execute HTTP DELETE request for resource with relative URL `${user-endpoint}/${userID}`
