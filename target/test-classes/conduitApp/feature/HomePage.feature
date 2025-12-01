Feature: Tests for home page

Background: Define URL
    Given url 'https://conduit-api.bondaracademy.com/api'

    Scenario: Tags should contain QA Skills and Zoom
        Given path 'tags'
        When method GET
        Then status 200
        And match response.tags contains ['QA Skills', 'Zoom']

    Scenario: Tags should not contain deranzo
        Given path 'tags'
        When method GET
        Then status 200
        And match response.tags !contains 'deranzo'

    Scenario: Tags should be in array
        Given path 'tags'
        When method GET
        Then status 200
        And match response.tags == "#array"

    Scenario: Each tag should be string
        Given path 'tags'
        When method GET
        Then status 200
        And match each response.tags == '#string'
        

    Scenario: Get 10 articles from the page
        Given params {limit: 10, offset: 0}
        Given path 'articles'
        When method GET
        Then status 200
        And match response.articles == '#[10]'

    Scenario: Article count should be 500 most
        Given params {limit: 10, offset: 0}
        Given path 'articles'
        When method GET
        Then status 200
        And match response.articlesCount == 10