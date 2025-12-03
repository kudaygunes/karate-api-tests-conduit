# Articles.feature
# This feature file tests article creation and deletion workflows.
# It validates article CRUD operations, authentication, and API contract integrity.
# Background authenticates a test user and retrieves an auth token for subsequent requests.

Feature: Articles
    Background: Define URL and authenticate
        Given url 'https://conduit-api.bondaracademy.com/api'
        # Login with test credentials to obtain auth token
        Given path 'users/login'
        And request {"user": {"email": "sertmulayim@protonmail.com","password": "Mulayim123"}}
        When method POST
        Then status 200
        # Store token for use in subsequent authenticated requests
        * def token = response.user.token

        
    # Scenario: Test article creation with full validation of response fields
    # Purpose: Ensures articles are created successfully with correct data structure and values
    # Validates: POST /articles returns 201, response contains all input fields correctly
    Scenario: Create an article
        Given header Authorization = 'Token ' + token
        Given path 'articles'
        And request {"article": {"title": "Warhammer 40000","description": "İmparatorla alakali","body": "İmparator korur","tagList": ["warhammer40000, imparator"]}}
        When method POST
        Then status 201
        And match response.article.title == 'Warhammer 40000'
        And match response.article.description == 'İmparatorla alakali'
        And match response.article.body == 'İmparator korur'
        And match response.article.tagList == ['warhammer40000, imparator']

    # Scenario: Test complete article lifecycle: create, retrieve, and delete
    # Purpose: Validates article CRUD operations, authentication, and deletion verification
    # Validates: POST creates article (201), GET retrieves it, DELETE removes it (204), GET returns 404 after deletion
    @create
    Scenario: Delete an article
        # Create article with unique title and capture slug for later use
        Given header Authorization = 'Token ' + token
        Given path 'articles'
        And request {"article": {"title": "Delete Warhammer 40000","description": "İmparatorla alakali","body": "İmparator korur","tagList": ["warhammer40000, imparator"]}}
        When method POST
        Then status 201
        * def articleId = response.article.slug

        # Retrieve articles list and verify newly created article is present
        Given header Authorization = 'Token ' + token
        Given params {limit: 10, offset: 0}
        Given path 'articles'
        When method GET
        Then status 200
        And match response.articles[0].title == 'Delete Warhammer 40000'

        # Delete the article by slug and expect 204 No Content
        Given header Authorization = 'Token ' + token
        Given path 'articles',articleId
        When method DELETE
        Then status 204

        # Verify article has been deleted: list should no longer contain it
        Given header Authorization = 'Token ' + token
        Given params {limit: 10, offset: 0}
        Given path 'articles'
        When method GET
        Then status 200
        And match response.articles[0].title != 'Delete Warhammer 40000'
