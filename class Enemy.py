class Enemy:
    def __init__(self, name, health, attack_power):
        self.enemy = any
        self.name = name
        self.level = 1
        self.experience = 1200
        self.health = 100000
        self.attack_power = 1000
        self.inventory = [2, 3, 4, 5, 6, 7, 8, 9, 10]
        self.difficulty = 10
        self.drop_rate = 0.5
        self.drop_items = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        self.drop_item = 1
        self.drop_item_amount = 1
        self.drop_item_type = "gold"
        self.drop_item_name = "gold"
        self.drop_item_description = "gold"
        self.drop_item_rarity = "common"
        self.drop_item_level = 1
        self.drop_item_value = 100
        self.drop_item_weight = 1
        self.drop_item_quality = "normal"
        
    def attack(self, player):
        player.health -= self.attack_power
        print(f"{self.name} attacks {player.name} for {self.attack_power} damage!")
