# Define the chatbot node
node chatbot {
    # Store some basic responses
    has greeting_responses = [
        "Hello! Nice to meet you!",
        "Hi there! How can I help you today?",
        "Greetings! I'm your friendly chatbot.",
        "Hey! What's up?"
    ];
    
    has capabilities_responses = [
        "I'm a simple chatbot that can greet you and tell you about my capabilities!",
        "My purpose is to have basic conversations - I can greet you and explain what I do.",
        "I'm here to demonstrate simple chatbot functionality with greetings and self-introduction.",
        "I can respond to your greetings and tell you about my limited but friendly capabilities!"
    ];
    
    has fallback_responses = [
        "I'm not sure how to respond to that. I'm still learning!",
        "Sorry, I didn't understand that. Try saying hello or asking what I can do!",
        "My responses are limited. You can greet me or ask about my capabilities.",
        "I'm a simple bot - try 'hello' or 'what can you do?'"
    ];
    
    # Main conversation handler
    can chat {
        std.out("Chatbot: Hello! I'm a simple JAC chatbot. Type 'quit' to exit.");
        
        while true {
            user_input = std.in("You: ");
            
            if (user_input == "quit") {
                std.out("Chatbot: Goodbye! Thanks for chatting!");
                break;
            }
            
            response = here.generate_response(user_input);
            std.out("Chatbot: " + response);
        }
    }
    
    # Generate appropriate response based on user input
    can generate_response(input) {
        input_lower = input::lower;
        
        # Check for greetings
        if (here.is_greeting(input_lower)) {
            random_index = std.rand() % here.greeting_responses.length;
            return here.greeting_responses[random_index];
        }
        
        # Check for capability inquiries
        if (here.is_capability_question(input_lower)) {
            random_index = std.rand() % here.capabilities_responses.length;
            return here.capabilities_responses[random_index];
        }
        
        # Default fallback response
        random_index = std.rand() % here.fallback_responses.length;
        return here.fallback_responses[random_index];
    }
    
    # Check if input is a greeting
    can is_greeting(input) {
        greetings = ["hello", "hi", "hey", "greetings", "good morning", "good afternoon", "good evening"];
        for greeting in greetings {
            if (greeting in input) {
                return true;
            }
        }
        return false;
    }
    
    # Check if input is asking about capabilities
    can is_capability_question(input) {
        capability_keywords = ["what can you do", "what do you do", "capabilities", "abilities", "help", "features"];
        for keyword in capability_keywords {
            if (keyword in input) {
                return true;
            }
        }
        return false;
    }
}

# Main execution
walker init {
    # Create and start the chatbot
    bot = spawn here --> node::chatbot;
    bot.chat;
}