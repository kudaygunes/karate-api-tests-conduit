
Feature: Sign up new user

Background: Preconditions
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * def timeValidator = read('classpath:helpers/timeValidator.js')
    * def randomEmail = dataGenerator.getRandomEmail()
    * def randomUsername = dataGenerator.getRandomUsername()
    Given url apiUrl

# Verify successful user creation with random data created in helpers/DataGenerator.java
Scenario: Create new user
    
    Given path 'users'
    And request 
    """
    {
        "user": 
            {
                "email": #(randomEmail),
                "password": "deranzo123",
                "username": #(randomUsername)
            }
    }
    """
    When method POST
    Then status 201
    # Verify that the response matches the expected format with dynamic values. #regex https?://[\\w.-]+\\.[a-zA-Z]{2,}/.* this is used to validate url is in correct format
    And match response ==
    """
    {
        "user": {
            "id": "#number",
            "email": #(randomEmail),
            "username": #(randomUsername),
            "bio": null,
            "image": "#regex https?://[\\w.-]+\\.[a-zA-Z]{2,}/.*",
            "token": "#string"
        }
    }
    """
# Scenario: Data driven error message validation test
@createuser
Scenario Outline: Validate sign up error messages
    
    Given path 'users'
    And request 
    """
    {
        "user": 
            {
                "email": "<email>",
                "password": "<password>",
                "username": "<username>"
            }
    }
    """
    When method POST
    Then status 422
    And match response == <errorResponse>

    # These scenarios can be multipled according to error messages
    Examples:
        | email                       | password                 | username             | errorResponse
        | #(randomEmail)              | Deranzo123               | MulayimSert          | {"errors":{"username":["has already been taken"]}}
        | sertmulayim@protonmail.com  | Deranzo123               |#(randomUsername)     | {"errors":{"email":["has already been taken"]}}