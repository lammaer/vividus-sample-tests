Description: GoRest API call, simple GET user tests

!-- a test user needs to be created if it is removed from the system. Users are unique by email address
Lifecycle:
Before:
Scope: STORY
Given I initialize story variable `TestUserEmailAddress` with value `testUser@frami-schinner.test`
When I set request headers:
|name        |value           |
|Authorization|Bearer ${bearer-token}|
!-- Check if the user with $TestUserEmailAddress exists
When I execute HTTP GET request for resource with relative URL `${user-endpoint}/?email=${TestUserEmailAddress}`
When I save number of elements from `${response}` found by JSON path `$` to story variable `NumberOfElements`
!-- If user returned, set it's ID to the story variable what is used by the scenarios below
When the condition `#{eval(${NumberOfElements} == 1)}` is true I do
|step|
|When I save JSON element value from `${response}` by JSON path `$.[0].id` to story variable `TestUserID`|
!-- If the user does not exist, create it using a composite step what creates the user and sets the variable
When the condition `#{eval(${NumberOfElements} == 0)}` is true I do
|step|
|Then I create test user with details from jsonfile `/data/responses/TestUserForGet.json`|

Scope: SCENARIO
!-- Setting bearer token from variable defined in suite properties
When I set request headers:
|name        |value           |
|Authorization|Bearer ${bearer-token}|
!-- Setting Bearer token directly
!-- |Authorization|Bearer 04205cf229c4db4be54a03441b1638c7ce612b119895e38ff0b20dedd5653ec0|



Scenario: GET001 - verify the number of returned users
When I execute HTTP GET request for resource with relative URL `${user-endpoint}`
Then response code is equal to `200`
Then number of JSON elements by JSON path `$` is equal to 10

Scenario: GET002 - verify the json response contains a string
When I execute HTTP GET request for resource with relative URL `${user-endpoint}`
Then response code is equal to `200`
Then content type of response body is equal to `application/json`
!-- deprecated way
Then the response body contains 'status'
!-- recommended vay
Then `${response}` matches `.*status.*`


Scenario: GET003 - Verify a JSON response, perfect match, json response hardcoded
When I execute HTTP GET request for resource with relative URL `${user-endpoint}/${TestUserID}`
Then response code is equal to `200`
Then JSON element from `${response}` by JSON path `$` is equal to `
{
        "id": ${TestUserID},
        "name": "Test user",
        "email": "${TestUserEmailAddress}",
        "gender": "female",
        "status": "active"
}
`

Scenario: GET004 - Verify a JSON response, perfect match, field by field with JSON path
When I execute HTTP GET request for resource with relative URL `${user-endpoint}/${TestUserID}`
Then response code is equal to `200`
Then JSON element from `${response}` by JSON path `$.id` is equal to `${TestUserID}`
Then JSON element from `${response}` by JSON path `$.name` is equal to `Test user`
Then JSON element from `${response}` by JSON path `$.email` is equal to `${TestUserEmailAddress}`
Then JSON element from `${response}` by JSON path `$.gender` is equal to `female`
Then JSON element from `${response}` by JSON path `$.status` is equal to `active`


Scenario: GET006 - Verify a JSON response, load expected response body from file, ignore extra fields
Given I initialize scenario variable `expected-json` with value `#{loadResource(/data/responses/TestUserForGet-Partial.json)}`
When I execute HTTP GET request for resource with relative URL `${user-endpoint}/${TestUserID}`
Then response code is equal to `200`
Then JSON element from `${response}` by JSON path `$` is equal to `${expected-json}` IGNORING_EXTRA_FIELDS

Scenario: GET005 - Existing user but no bearer token
!-- make auth header empty, because it is set for every scenario in the story scope on the top
When I set request headers:
|name        |value           |
|Authorization||
When I execute HTTP GET request for resource with relative URL `${user-endpoint}/${TestUserID}`
Then response code is equal to `404`
Then JSON element from `${response}` by JSON path `$.message` is equal to `Resource not found`


Scenario: GET007 - Negative case - non existing user
When I execute HTTP GET request for resource with relative URL `${user-endpoint}/-9999999`
Then response code is equal to `404`
Then JSON element from `${response}` by JSON path `$.message` is equal to `Resource not found`


Scenario: GET008 - Existing user but bad bearer token
When I set request headers:
|name        |value           |
|Authorization|Bearer BadToken229c4db4be54a03441b1638c7ce612b119895e38ff0b20dedd5653ec0|
When I execute HTTP GET request for resource with relative URL `${user-endpoint}/${TestUserID}`
Then response code is equal to `401`
Then JSON element from `${response}` by JSON path `$.message` is equal to `Invalid token`


Scenario: GET009 - Get by status = active, all returned users active
When I execute HTTP GET request for resource with relative URL `${user-endpoint}?status=active`
Then response code is equal to `200`
When I find > `0` JSON elements from `${response}` by `$.*` and for each element do
|step                                                                                                         |
|Then JSON element from `${json-context}` by JSON path `$.status` is equal to `active` |

Scenario: GET010 - Get by gender=male and status=active , all returned users are male active
When I execute HTTP GET request for resource with relative URL `${user-endpoint}?gender=male&status=active`
Then response code is equal to `200`
When I find > `0` JSON elements from `${response}` by `$.*` and for each element do
|step                                                                                                         |
|Then JSON element from `${json-context}` by JSON path `$.status` is equal to `active` |
|Then JSON element from `${json-context}` by JSON path `$.gender` is equal to `male` |

Scenario: GET011 - Number of returned users is maximum 15
When I execute HTTP GET request for resource with relative URL `${user-endpoint}?page=1&per_page=15`
Then response code is equal to `200`
Then number of JSON elements from `${json-context}` by JSON path `$` is less than or equal to 15

Scenario: GET012 - user doesn't exist, lookup by email address
!-- doublechecking the user doesnt exist
When I execute HTTP GET request for resource with relative URL `${user-endpoint}/?email=get012@notexist.com`
Then response code is equal to `200`
Then JSON element from `${response}` by JSON path `$` is equal to `[]`
