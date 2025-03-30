import random

def generate_dungeon(size):
    dungeon = [['.' for _ in range(size)] for _ in range(size)]
    for _ in range(size // 100):  # Place some enemies
        x, y = random.randint(0, size-1), random.randint(0, size-1)
        dungeon[x][y] = 'E'  # E for enemy
    return dungeon
