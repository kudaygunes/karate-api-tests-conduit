Feature: Create token

Scenario: Create token
    Given url apiUrl
    Given path 'users/login'
    # The email and password are dynamically inserted from variables
    And request {"user": {"email": "#(userEmail)","password": "#(userPassword)"}}
    When method POST
    Then status 200
    # The token is extracted from the response body under the "user" object
    * def authToken = response.user.token