package helpers;

import com.github.javafaker.Faker;

/**
 * This class generates random email addresses and usernames for test scenarios.
 * It uses the Java Faker library to create realistic data.
 */
public class DataGenerator {
    
    /**
     * Generates a random email address.
     * @return The generated random email address
     */
    public static String getRandomEmail(){
        Faker faker = new Faker();
        // Use a random first name in lowercase as the prefix for the email
        String emailPrefix = faker.name().firstName().toLowerCase();
        // Add a random number between 0 and 100 to make each email unique
        int randomNumber = faker.random().nextInt(0, 100);
        // Combine all parts to create the final email address
        String email = emailPrefix + randomNumber + "@test.com";
        return email;
    }
    
    /**
     * Generates a random username.
     * @return The generated random username
     */
    public static String getRandomUsername(){
        Faker faker = new Faker();
        // Use Java Faker's built-in method to generate a random username
        String username = faker.name().username();
        return username;
    }
}