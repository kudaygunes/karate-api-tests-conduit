
Feature: Sign up new user

Background: Preconditions
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * def timeValidator = read('classpath:helpers/timeValidator.js')
    Given url apiUrl

# Verify successful user creation with random data created in helpers/DataGenerator.java
@createuser
Scenario: Create new user

Given def userData = {"email": "deranzo@sumsin.com","username": "deranzo2"}
    * def randomEmail = dataGenerator.getRandomEmail()
    * def randomUsername = dataGenerator.getRandomUsername()
    
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