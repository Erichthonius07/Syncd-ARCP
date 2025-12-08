package com.syncd.syncd_backend.config;

import com.syncd.syncd_backend.model.User;
import com.syncd.syncd_backend.repository.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Random;
import java.util.UUID;

@Component
public class DataInitializer implements CommandLineRunner {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public DataInitializer(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(String... args) throws Exception {
        // Only seed if the database is empty
        if (userRepository.count() == 0) {
            System.out.println("🌱 Starting Database Seed...");
            List<User> users = new ArrayList<>();

            // --- 1. Specific Test Users (The ones you know) ---
            User player1 = createUser("player1", "player1@syncd.com", "👾", Arrays.asList("Cyber Racer", "Space Tanks"));
            User player2 = createUser("player2", "player2@syncd.com", "👽", Arrays.asList("Pixel Arena"));
            User player3 = createUser("navistha", "navistha@syncd.com", "🦁", Arrays.asList("Cyber Racer", "Pixel Arena", "Galaxy Jump"));
            
            users.add(player1);
            users.add(player2);
            users.add(player3);

            // --- 2. Generate 10 Random Users ---
            String[] avatars = {"🤖", "💀", "👻", "🤡", "💩", "👹", "👺", "🎃", "😺", "🦄", "🐲", "🍄"};
            String[] allGames = {"Cyber Racer", "Space Tanks", "Pixel Arena", "Galaxy Golf", "Dungeon Drop", "Mecha City"};
            Random random = new Random();

            for (int i = 4; i <= 13; i++) {
                String username = "Player_" + i;
                String email = "player" + i + "@syncd.com";
                String avatar = avatars[random.nextInt(avatars.length)];
                
                // Assign 1-3 random games
                List<String> myGames = new ArrayList<>();
                int numGames = random.nextInt(3) + 1;
                for (int j = 0; j < numGames; j++) {
                    String game = allGames[random.nextInt(allGames.length)];
                    if (!myGames.contains(game)) {
                        myGames.add(game);
                    }
                }

                users.add(createUser(username, email, avatar, myGames));
            }

            // --- 3. Save Everyone ---
            userRepository.saveAll(users);

            System.out.println("✅ Database seeded with " + users.size() + " users!");
            System.out.println("👉 Main Login: 'player1' / 'password'");
        } else {
            System.out.println("⚡ Database already contains data. Skipping seed.");
        }
    }

    private User createUser(String username, String email, String icon, List<String> games) {
        User user = new User(
                UUID.randomUUID().toString(),
                username,
                email,
                passwordEncoder.encode("password"), // Default password for everyone
                icon
        );
        user.setGameLibrary(games);
        user.setOnline(true); // Make them look online for testing
        return user;
    }
}