# HomePage.feature
# This feature file tests the home page endpoints of the Conduit API.
# It validates tags retrieval, article listing, and response structure integrity.
# These tests ensure the API serves correct tag collections, article counts, and proper data types.

Feature: Tests for home page

Background: Define URL
    Given url apiUrl

    # Scenario: Verify that the tags endpoint returns a collection containing expected tags
    # Purpose: Ensures tag data is present and searchable
    Scenario: Tags should contain QA Skills and Zoom
        Given path 'tags'
        When method GET
        Then status 200
        And match response.tags contains ['GitHub', 'Zoom']

    # Scenario: Verify that unexpected tags are not in the tags collection
    # Purpose: Ensures data integrity and validates negative test cases
    Scenario: Tags should not contain deranzo
        Given path 'tags'
        When method GET
        Then status 200
        And match response.tags !contains 'deranzo'

    # Scenario: Verify that tags response structure is an array type
    # Purpose: Ensures response schema compliance
    Scenario: Tags should be in array
        Given path 'tags'
        When method GET
        Then status 200
        And match response.tags == "#array"

    # Scenario: Verify that all items in the tags array are string type
    # Purpose: Validates data type consistency
    Scenario: Each tag should be string
        Given path 'tags'
        When method GET
        Then status 200
        And match each response.tags == '#string'
        

    # Scenario: Verify that the articles endpoint returns exactly 10 articles with default params
    # Purpose: Tests pagination and response size limits
    Scenario: Get 10 articles from the page
        Given params {limit: 10, offset: 0}
        Given path 'articles'
        When method GET
        Then status 200
        And match response.articles == '#[10]'

    # Scenario: Verify that the articlesCount property matches the returned articles limit (10)
    # Purpose: Ensures count field accuracy and pagination consistency
    Scenario: Article count should be 500 most
        Given params {limit: 10, offset: 0}
        Given path 'articles'
        When method GET
        Then status 200
        And match response.articlesCount == 10

    # Scenario: Verify that the response is array, articlesCount is 10
    # Purpose: Ensures response is in correct format
    Scenario: Check response format
        Given params {limit: 10, offset: 0}
        Given path 'articles'
        When method GET
        Then status 200
        And match response == {"articles": "#array", "articlesCount": 10}

    # Scenario: Verify article is created at specific year
    # Purpose: Checks newly created articles is in correct year
    Scenario: Check year
        Given params {limit: 10, offset: 0}
        Given path 'articles'
        When method GET
        Then status 200
        And match response.articles[0].createdAt contains '2025'

    # Scenario: Check at least 1 bio property is null
    Scenario: Check bio is null
        Given params {limit: 10, offset: 0}
        Given path 'articles'
        When method GET
        Then status 200
        And match response.articles[*].author.bio contains null

    # Scenario: Check every following property is false
    Scenario: Check following property
        Given params {limit: 10, offset: 0}
        Given path 'articles'
        When method GET
        Then status 200
        And match each response..following == false


    # Scenario: Check bio property is either null or string
    Scenario: Check bio property either available, if yes string or null. 
        Given params {limit: 10, offset: 0}
        Given path 'articles'
        When method GET
        Then status 200
        And match each response..bio == '##string'
       
    # Scenario: Check all property types as schema validation. Used global time validation function (helpers/timeValidator)    
    @homepage
    Scenario: Check bio property either available, if yes string or null. 
        * def timeValidator = read('classpath:helpers/timeValidator.js')
        * def urlValidator = read('classpath:helpers/urlValidator.js')
        Given params {limit: 10, offset: 0}
        Given path 'articles'
        When method GET
        Then status 200
        And match each response.articles ==
        """
        {
            "slug": "#string",
            "title": "#string",
            "description": "#string",
            "body": "#string",
            "tagList": "#array",
            "createdAt": "#? timeValidator(_)",
            "updatedAt": "#? timeValidator(_)",
            "favorited": '#boolean',
            "favoritesCount": '#number',
            "author": {
                "username": "#string",
                "bio": "##string",
                "image": "#string",
                "following": '#boolean'
            }
        }
        """