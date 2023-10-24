Description: GoRest API call, simple POST user tests


!-- requests have to set Bearer token
Lifecycle:
Before:
Scope: SCENARIO
!-- Setting bearer token from variable defined in suite properties
When I set request headers:
|name        |value           |
|Authorization|Bearer ${bearer-token}|
|Content-Type|application/json|
When I initialize the story variable `userID` with value `0`

After:
Scope: SCENARIO
!-- delete user if userID specified during test execution, composite step in gorest.steps
When the condition '#{eval(${userID} != 0)}' is true I do
|step                                                                   |
|Then I delete test user with id `${userID}`|


Scenario: POST001 Create user with random email and verify JSON response.
!-- problem: the email address can be used only once. Lets use a random email address
Given I initialize scenario variable `randomemail` with value `#{generate(Internet.emailAddress)}`
Given request body: {
    "name": "Test user",
    "email": "${randomemail}",
    "gender": "female",
    "status": "active"
}
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
When I save JSON element value from `${response}` by JSON path `$.id` to story variable `userID`
!-- check if userID is integer
Then `${userID}` matches `^\d+$`


Scenario: POST002 Missing name field
Given request body: {
    "email": "post002@shouldnotexist.com",
    "gender": "female",
    "status": "active"
}
When I execute HTTP POST request for resource with relative URL `${user-endpoint}`
Then response code is equal to `422`
Then JSON element from `${response}` by JSON path `$` is equal to `
[
    {
        "field": "name",
        "message": "can't be blank"
    }
]
`

Scenario: POST003 Missing multiple fields
Given request body: {
    "email": "post003@shouldnotexist.com",
    "gender": "female"
}
When I execute HTTP POST request for resource with relative URL `${user-endpoint}`
Then response code is equal to `422`
Then JSON element from `${response}` by JSON path `$` is equal to `
[
    {
        "field": "name",
        "message": "can't be blank"
    },
    {
        "field": "status",
        "message": "can't be blank"
    }
]
`

Scenario: POST004 Invalid email address
Given request body: {
"name": "POST004User Should not exist",
"email": "invalid_email_format",
"gender": "female",
"status": "active"
}
When I execute HTTP POST request for resource with relative URL `${user-endpoint}`
Then response code is equal to `422`
Then JSON element from `${response}` by JSON path `$` is equal to `
[
    {
        "message": "is invalid",
        "field": "email"

    }
]
`

Scenario: POST005 Invalid gender value
Given request body: {
"name": "POST005User Should not exist",
"email": "post005@notexist.com",
"gender": "whatever",
"status": "active"
}
When I execute HTTP POST request for resource with relative URL `${user-endpoint}`
Then response code is equal to `422`
Then JSON element from `${response}` by JSON path `$` is equal to `
[
    {
        "message": "can't be blank, can be male of female",
        "field": "gender"

    }
]
`
!-- doublechecking the user doesnt exist
When I execute HTTP GET request for resource with relative URL `${user-endpoint}/?email=post005@notexist.com`
Then response code is equal to `200`
Then JSON element from `${response}` by JSON path `$` is equal to `[]`

Scenario: POST006 - POST with missing authentication
When I set request headers:
|name        |value           |
|Authorization||
Given request body: {
"name": "POST6 User",
"email": "post006@notexist.com",
"gender": "male",
"status": "active"
}
When I execute HTTP POST request for resource with relative URL `${user-endpoint}`
Then response code is equal to `401`
Then JSON element from `${response}` by JSON path `$` is equal to `
{
    "message": "Authentication failed"
}
`

Scenario: POST007 - Unique email test
Given request body: {
    "name": "Test user",
    "email": "post007@existinguser.com",
    "gender": "female",
    "status": "active"
}
When I execute HTTP POST request for resource with relative URL `${user-endpoint}`
Then response code is equal to `422`
Then JSON element from `${response}` by JSON path `$` is equal to `
[
    {
        "field": "email",
        "message": "has already been taken"
    }
]
`

Scenario: POST008 - excessively long name
Given request body: {
    "name": "ExcessivelyLongNameExcessivelyLongNameExcessivelyLongNameExcessivelyLongNameExcessivelyLongNameExcessivelyLongNameExcessivelyLongNameExcessivelyLongNameExcessivelyLongNameongNameExcesongNameExcesongNameExcesongNameExcesongNameExcesongNameExcesongNameExcesongNameExcesongNameExcesongNameExcesongNameExcesongNameExcesongNameExcesongNameExcesongNameExcesongNameExcesongNameExcesongNameExcesongNameExcesongNameExcesongNameExcesongNameExces",
    "email": "excessively_long_name_test@example.com",
    "gender": "male",
    "status": "active"
}
When I execute HTTP POST request for resource with relative URL `${user-endpoint}`
Then response code is equal to `422`
Then JSON element from `${response}` by JSON path `$` is equal to `
[
    {
        "field": "name",
        "message": "is too long (maximum is 200 characters)"
    }
]
`

Scenario: POST009 - duplicated user name field (last will be taken)
!-- making sure the user does not exist
Given I delete the user with email address `duplicate_name_test@example.com` if exist
!-- here request token need to be set, because the previous composite test might already "took" the header setting
!-- as per document:  "The added HTTP headers are scoped to the first performed HTTP request and not available afterwards."
When I set the bearer token
Given request body: {
    "name": "Duplicate Name Test User",
    "name": "Duplicate Name Test User 2",
    "email": "duplicate_name_test@example.com",
    "gender": "male",
    "status": "active"
}
When I execute HTTP POST request for resource with relative URL `${user-endpoint}`
Then response code is equal to `201`
Then JSON element from `${response}` by JSON path `$` is equal to `
{
    "name": "Duplicate Name Test User 2",
    "email": "duplicate_name_test@example.com",
    "gender": "male",
    "status": "active"
}` IGNORING_EXTRA_FIELDS
When I save JSON element value from `${response}` by JSON path `$.id` to story variable `userID`
!-- check if userID is integer
Then `${userID}` matches `^\d+$`
