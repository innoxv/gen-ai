import:py from random, randint;

node ChatBot {
    has responses: dict = {
        "hello": ["Hi there!", "Hello!", "Hey! How are you?"],
        "bye": ["Goodbye!", "See you later!", "Bye!"],  
        "how are you": ["I'm doing well, thanks!", "Great! And you?"],
        "default": ["I see.", "Tell me more.", "Interesting!"]
    };
    
    has message_count: int = 0;
}

walker chat_session {
    has keep_going: bool = True;
    
    can start with `root entry;
    
    can start with ChatBot entry {
        print("ChatBot: Hello! I'm a simple chatbot. Say 'bye' to exit.");
        
        while self.keep_going {
            user_input = input("You: ");
            
            if user_input.lower() == "bye" {
                response = here.responses["bye"][0];
                print("ChatBot: " + response);
                self.keep_going = False;
            } else {
                here.message_count += 1;
                
                if "hello" in user_input.lower() {
                    response = here.responses["hello"][0];
                } elif "how are you" in user_input.lower() {
                    response = here.responses["how are you"][0];
                } else {
                    response = here.responses["default"][0];
                }
                
                print("ChatBot: " + response);
            }
        }
        
        print("Total messages: " + str(here.message_count));
    }
}

with entry {
    bot_node = ChatBot();
    root spawn bot_node;
    root visit::<chat_session>();
}