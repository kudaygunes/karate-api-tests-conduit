function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    // Variable is created for using in various features
    apiUrl: 'https://conduit-api.bondaracademy.com/api',
  }

  // For development environment
  // These credentials will be used when running tests with the "dev" environment flag
  // For example: mvn test '-Dkarate.options=--tags @create' '-Dkarate.env="dev"'
  if (env == 'dev') {
    config.userEmail = 'sertmulayim@protonmail.com',
    config.userPassword = 'Mulayim123'
  }
  // For production environment
  // These credentials will be used when running tests with the "prod" environment flag
  // For example: mvn test '-Dkarate.options=--tags @create' '-Dkarate.env="prod"'
  if (env == 'prod') {
    config.userEmail = 'babaninoglukemal@protonmail.com',
    config.userPassword = 'Baba12345'
  }

  // Fetch an access token by calling the CreateToken feature
  var accessToken = karate.callSingle('classpath:helpers/CreateToken.feature', config).authToken
  // Configure a header with the authentication token for all subsequent requests
  karate.configure('headers', {Authorization: 'Token ' + accessToken})

  // This returns all config objects for every feature files used
  return config;
}