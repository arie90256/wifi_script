def main_menu():
    while True:
        print("1. Start Game")
        print("2. Load Game")
        print("3. Save Game")
        print("4. Exit")
        choice = input("Choose an option: ")

        if choice == '1':
            # Start a new game
            game_state = GameState(Player("Hero", 100, 10, 5, 1, 0), Inventory([]), [], Settings({}, {}))
            # Start game loop here
        elif choice == '2':
            game_state = load_game()
            if game_state:
                # Continue the game with loaded state
                pass
        elif choice == '3':
            if game_state:
                save_game(game_state)
            else:
                print("No game to save.")
        elif choice == '4':
            break
        else:
            print("Invalid choice. Please try again.")
