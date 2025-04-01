import pygame
import sys
import random
import math
import time

# Initialize Pygame
pygame.init()

# Constants
SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
MAP_WIDTH = 3000  # Adjusted map width
MAP_HEIGHT = 2000  # Adjusted map height
FPS = 60
BOMB_RADIUS = 30
ENEMY_RADIUS = 10
PLAYER_RADIUS = 25
WALL_COLOR = (139, 69, 19)  # Brown color for walls
DOOR_COLOR = (150, 75, 0)
NUM_MAPS = 10  # Updated number of maps

# Set up the display
screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT), pygame.FULLSCREEN)
pygame.display.set_caption("Infinite Dungeon with Variety of Enemies and Treasure")

# Wall class
class Wall:
    def __init__(self, x, y, width, height):
        self.rect = pygame.Rect(x, y, width, height)

    def draw(self, surface, camera):
        pygame.draw.rect(surface, WALL_COLOR, camera.apply(self.rect))

# Door class
class Door:
    def __init__(self, x, y, width, height):
        self.rect = pygame.Rect(x, y, width, height)
        self.open = False

    def toggle(self):
        self.open = not self.open

    def draw(self, surface, camera):
        color = (0, 255, 0) if self.open else DOOR_COLOR
        pygame.draw.rect(surface, color, camera.apply(self.rect))

# Player class
class Player:
    def __init__(self, x, y):
        self.rect = pygame.Rect(x, y, PLAYER_RADIUS * 2, PLAYER_RADIUS * 2)
        self.color = (0, 255, 0)
        self.speed = 10
        self.health = 50
        self.loot = []
        self.sword_active = False
        self.weapon = 'bullet'  # Start with bullet as the primary weapon
        self.direction = (0, 0)  # Add direction attribute

    def move(self, keys, walls, doors):
        original_position = self.rect.copy()
        direction_x, direction_y = 0, 0
        if keys[pygame.K_a]:
            self.rect.x -= self.speed
            direction_x = -1
        if keys[pygame.K_d]:
            self.rect.x += self.speed
            direction_x = 1
        if keys[pygame.K_w]:
            self.rect.y -= self.speed
            direction_y = -1
        if keys[pygame.K_s]:
            self.rect.y += self.speed
            direction_y = 1

        # Normalize direction vector
        if direction_x != 0 or direction_y != 0:
            length = math.hypot(direction_x, direction_y)
            self.direction = (direction_x / length, direction_y / length)

        for wall in walls:
            if self.rect.colliderect(wall.rect):
                self.rect = original_position

        for door in doors:
            if self.rect.colliderect(door.rect):
                if keys[pygame.K_e]:
                    door.toggle()
                else:
                    self.rect = original_position

        if keys[pygame.K_SPACE]:
            self.sword_active = True
        else:
            self.sword_active = False

    def switch_weapon(self):
        if self.weapon == 'bullet':
            self.weapon = 'sword'
        elif self.weapon == 'sword':
            self.weapon = 'black_hole'
        else:
            self.weapon = 'bullet'

    def draw(self, surface, camera):
        pygame.draw.circle(surface, self.color, camera.apply_pos(self.rect.center), PLAYER_RADIUS)
        if self.sword_active and self.weapon == 'sword':
            sword_length = 40
            sword_width = 10
            sword_x = self.rect.centerx + self.direction[0] * sword_length
            sword_y = self.rect.centery + self.direction[1] * sword_length
            sword_rect = pygame.Rect(sword_x, sword_y, sword_length, sword_width)
            pygame.draw.rect(surface, (255, 255, 255), camera.apply(sword_rect))
        elif self.weapon == 'black_hole':
            pygame.draw.circle(surface, (0, 0, 0), camera.apply_pos(self.rect.center), 50)

# Bullet class
class Bullet:
    def __init__(self, x, y, angle):
        self.rect = pygame.Rect(x, y, 5, 5)
        self.color = (255, 0, 0)
        self.speed = 10
        self.angle = angle

    def update(self):
        self.rect.x += self.speed * math.cos(self.angle)
        self.rect.y += self.speed * math.sin(self.angle)

    def draw(self, surface, camera):
        pygame.draw.rect(surface, self.color, camera.apply(self.rect))

# Black Hole class
class BlackHole:
    def __init__(self, x, y):
        self.rect = pygame.Rect(x - 50, y - 50, 100, 100)
        self.color = (0, 0, 0)
        self.active = True
        self.creation_time = time.time()

    def update(self, enemies):
        if time.time() - self.creation_time > 5:  # Black hole lasts for 5 seconds
            self.active = False
        if self.active:
            for enemy in enemies:
                direction_x = self.rect.centerx - enemy.rect.centerx
                direction_y = self.rect.centery - enemy.rect.centery
                distance = math.hypot(direction_x, direction_y)
                if distance > 0:
                    direction_x /= distance
                    direction_y /= distance
                enemy.rect.x += direction_x * 5
                enemy.rect.y += direction_y * 5

    def draw(self, surface, camera):
        if self.active:
            pygame.draw.circle(surface, self.color, camera.apply_pos(self.rect.center), 50)

# Base Enemy class
class Enemy:
    def __init__(self, x, y):
        self.rect = pygame.Rect(x, y, ENEMY_RADIUS * 2, ENEMY_RADIUS * 2)
        self.color = (255, 0, 0)
        self.speed = 1
        self.target = None
        self.loot = random.choice(['gold', 'silver', 'health_potion'])

    def move_towards(self, target, walls):
        if self.target is None:
            self.target = target

        direction_x = self.target.rect.centerx - self.rect.centerx
        direction_y = self.target.rect.centery - self.rect.centery
        distance_to_player = math.hypot(direction_x, direction_y)

        if distance_to_player > 0:
            direction_x /= distance_to_player
            direction_y /= distance_to_player

        future_rect = self.rect.move(direction_x * self.speed, direction_y * self.speed)
        if not any(future_rect.colliderect(wall.rect) for wall in walls):
            self.rect.x += direction_x * self.speed
            self.rect.y += direction_y * self.speed
        else:
            alternative_directions = [
                (direction_y, -direction_x),
                (-direction_y, direction_x),
            ]
            for alt_dir_x, alt_dir_y in alternative_directions:
                future_rect_alt = self.rect.move(alt_dir_x * self.speed, alt_dir_y * self.speed)
                if not any(future_rect_alt.colliderect(w.rect) for w in walls):
                    self.rect.x += alt_dir_x * self.speed
                    self.rect.y += alt_dir_y * self.speed
                    break

        if distance_to_player < 50:
            self.rect.x -= direction_x * self.speed
            self.rect.y -= direction_y * self.speed

    def draw(self, surface, camera):
        pygame.draw.circle(surface, self.color, camera.apply_pos(self.rect.center), ENEMY_RADIUS)

# Derived enemy classes
class FastEnemy(Enemy):
    def __init__(self, x, y):
        super().__init__(x, y)
        self.speed = 2
        self.color = (0, 0, 255)

class StrongEnemy(Enemy):
    def __init__(self, x, y):
        super().__init__(x, y)
        self.health = 100
        self.color = (0, 255, 0)

# Loot class to represent loot items
class Loot:
    def __init__(self, x, y, item_type):
        self.rect = pygame.Rect(x, y, 20, 20)
        self.item_type = item_type
        self.color = (255, 255, 0) if item_type == 'gold' else (192, 192, 192) if item_type == 'silver' else (255, 0, 0)

    def draw(self, surface, camera):
        pygame.draw.rect(surface, self.color, camera.apply(self.rect))

# Bomb class
class Bomb:
    def __init__(self, x, y):
        self.rect = pygame.Rect(x, y, BOMB_RADIUS * 2, BOMB_RADIUS * 2)
        self.color = (255, 255, 0)
        self.active = True
        self.hover_start_time = None  # Track the hover start time

    def update(self, player):
        if self.rect.colliderect(player.rect):
            if self.hover_start_time is None:
                self.hover_start_time = time.time()  # Start the hover timer
            elif time.time() - self.hover_start_time >= 2:  # Check if hovering for 2 seconds
                return True
        else:
            self.hover_start_time = None  # Reset the hover timer if not hovering
        return False

    def draw(self, surface, camera):
        if self.active:
            pygame.draw.circle(surface, self.color, camera.apply_pos(self.rect.center), BOMB_RADIUS)

# Camera class to keep player always visible
class Camera:
    def __init__(self, width, height):
        self.camera = pygame.Rect(0, 0, width, height)
        self.width = width
        self.height = height

    def apply(self, entity):
        return entity.move(self.camera.topleft)

    def apply_pos(self, pos):
        return pos[0] + self.camera.topleft[0], pos[1] + self.camera.topleft[1]

    def update(self, target):
        x = -target.rect.centerx + int(SCREEN_WIDTH / 2)
        y = -target.rect.centery + int(SCREEN_HEIGHT / 2)

        x = min(0, x)
        y = min(0, y)
        x = max(-(self.width - SCREEN_WIDTH), x)
        y = max(-(self.height - SCREEN_HEIGHT), y)

        self.camera = pygame.Rect(x, y, self.width, self.height)

# Function to generate a dungeon map with walls and doors
def generate_maze(structure):
    walls = []
    doors = []

    for y, row in enumerate(structure):
        for x, cell in enumerate(row):
            if cell == "#":
                walls.append(Wall(x * 100, y * 100, 100, 100))
            elif cell == " ":
                if (x > 0 and row[x - 1] == "#") or (x < len(row) - 1 and row[x + 1] == "#"):
                    doors.append(Door(x * 100, y * 100, 100, 20))
                if (y > 0 and structure[y - 1][x] == "#") or (y < len(structure) - 1 and structure[y + 1][x] == "#"):
                    doors.append(Door(x * 100, y * 100, 20, 100))

    return walls, doors

# Function to generate the starting area
def generate_starting_area():
    walls = [
        Wall(50, 50, 700, 20),  # Top wall
        Wall(50, 530, 700, 20),  # Bottom wall
        Wall(50, 50, 20, 500),  # Left wall
        # Removed the right wall
        Wall(200, 200, 400, 20),  # Inner top wall
        Wall(200, 380, 400, 20),  # Inner bottom wall
        Wall(200, 200, 20, 200),  # Inner left wall
        Wall(580, 200, 20, 200),  # Inner right wall
    ]

    doors = [
        Door(380, 200, 40, 20),  # Inner top door
        Door(380, 380, 40, 20),  # Inner bottom door
    ]

    return walls, doors

# Function to transition to the next map
def transition_to_next_map(current_map_index, player, enemy_positions):
    new_map_index = (current_map_index + 1) % NUM_MAPS
    structures = [
        [
            "######################",
            "#          #   #     #",
            "#### #######      ####",
            "#             ###    #",
            "# ####### ##         #",
            "#        ###     #####",
            "## ######  ####      #",
            "#         ##     #####",
            "# #############      #",
            "#               #    #",
            "################### ##"
        ],
        [
            "######################",
            "#     #              #",
            "####  #######  #######",
            "#                    #",
            "###  ############### #",
            "#                    #",
            "##################### #",
            "#                    #",
            "#######################",
        ],
        [
            "######################",
            "#######          #####",
            "#       #######      #",
            "#       #            #",
            "#       #######      #",
            "#             #      #",
            "#       #######      #",
            "#       #            #",
            "#       #######      #",
            "######################",
        ],
        [
            "######################",
            "#         #          #",
            "# ############### ####",
            "#                    #",
            "####### ########### ##",
            "#                    #",
            "########### ######## #",
            "#                    #",
            "######################",
        ],
        [
            "######################",
            "#                    #",
            "# ################### #",
            "#                    #",
            "####### ############ #",
            "#                    #",
            "# ################### #",
            "#                    #",
            "######################",
        ],
        [
            "######################",
            "#                    #",
            "#### ####### #########",
            "#                    #",
            "# ####### ####### ####",
            "#                    #",
            "### ### ## ###########",
            "#                    #",
            "######################",
        ],
        [
            "######################",
            "#                    #",
            "####### ###### #######",
            "#                    #",
            "# ### ###### #########",
            "#                    #",
            "### ######### ####### ",
            "#                    #",
            "######################",
        ],
        [
            "######################",
            "#                    #",
            "##### ##### ###### ###",
            "#                    #",
            "### ####### ##########",
            "#                    #",
            "##### ###### #########",
            "#                    #",
            "######################",
        ],
        [
            "######################",
            "#                    #",
            "# ###### ######## ####",
            "#                    #",
            "### ##### ######## ###",
            "#                    #",
            "###### ###############",
            "#                    #",
            "######################",
        ],
        [
            "######################",
            "#                    #",
            "# ###### ######## ####",
            "#                    #",
            "### ##### ######## ###",
            "#                    #",
            "###### ###############",
            "#                    #",
            "######################",
        ]
    ]
    walls, doors = generate_maze(structures[new_map_index])
    player.rect.topleft = (150, 150)
    enemies = [random.choice([Enemy(x, y), FastEnemy(x, y), StrongEnemy(x, y)]) for x, y in enemy_positions]
    loot_items = [Loot(random.randint(100, MAP_WIDTH - 100), random.randint(100, MAP_HEIGHT - 100), random.choice(['gold', 'silver', 'health_potion'])) for _ in range(5)]
    return new_map_index, walls, doors, enemies, loot_items

# Function to display the start menu
def show_start_menu(selected_option):
    screen.fill((0, 0, 0))
    font = pygame.font.Font(None, 74)
    title_text = font.render('Infinite Dungeon', True, (255, 255, 255))
    screen.blit(title_text, (SCREEN_WIDTH // 2 - title_text.get_width() // 2, SCREEN_HEIGHT // 2 - 200))

    font = pygame.font.Font(None, 36)
    options = ['Start', 'Quit']
    for i, option in enumerate(options):
        color = (255, 255, 255) if i != selected_option else (0, 255, 0)
        option_text = font.render(option, True, color)
        screen.blit(option_text, (SCREEN_WIDTH // 2 - option_text.get_width() // 2, SCREEN_HEIGHT // 2 - 100 + i * 50))

    pygame.display.flip()

# Starting points for player and enemies
player_start_x, player_start_y = 150, 150
enemy_start_positions = [
    (1650, 1250),
    (1500, 1300),
    (1400, 1400),
    (1300, 1500),
    (1450, 1350)
]

# Initialize selected menu option
selected_option = 0

# Create instances
player = None
bullets = []
black_holes = []
current_map_index = 0
walls, doors = generate_starting_area()  # Use the new starting area
enemies = [random.choice([Enemy(x, y), FastEnemy(x, y), StrongEnemy(x, y)]) for x, y in enemy_start_positions]
loot_items = [Loot(random.randint(100, MAP_WIDTH - 100), random.randint(100, MAP_HEIGHT - 100), random.choice(['gold', 'silver', 'health_potion'])) for _ in range(5)]
bomb = Bomb(random.randint(200, MAP_WIDTH - 200), random.randint(200, MAP_HEIGHT - 200))
camera = Camera(MAP_WIDTH, MAP_HEIGHT)

# Game loop
clock = pygame.time.Clock()
running = True
in_start_menu = True
score = 0
shoot_cooldown = 1

while running:
    if in_start_menu:
        show_start_menu(selected_option)
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_RETURN:
                    if selected_option == 0:
                        in_start_menu = False
                        player = Player(player_start_x, player_start_y)
                        print("Starting game...")  # Debug print
                    elif selected_option == 1:
                        running = False
                if event.key == pygame.K_ESCAPE:
                    running = False
                if event.key == pygame.K_UP:
                    selected_option = (selected_option - 1) % 2
                if event.key == pygame.K_DOWN:
                    selected_option = (selected_option + 1) % 2
    else:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_q:
                    player.switch_weapon()

        keys = pygame.key.get_pressed()
        player.move(keys, walls, doors)

        if shoot_cooldown > 0:
            shoot_cooldown -= 1

        if pygame.mouse.get_pressed()[0] and shoot_cooldown == 0 and player.weapon == 'bullet':
            angle = math.atan2(player.direction[1], player.direction[0])
            bullet = Bullet(player.rect.centerx, player.rect.centery, angle)
            bullets.append(bullet)
            shoot_cooldown = 10

        for bullet in bullets[:]:
            bullet.update()

        for bullet in bullets[:]:
            for wall in walls:
                if bullet.rect.colliderect(wall.rect):
                    bullets.remove(bullet)
                    break

        for enemy in enemies:
            enemy.move_towards(player, walls)

        for bullet in bullets[:]:
            for enemy in enemies[:]:
                if bullet.rect.colliderect(enemy.rect):
                    bullets.remove(bullet)
                    enemies.remove(enemy)
                    player.loot.append(enemy.loot)
                    score += 1
                    break

        if player.sword_active and player.weapon == 'sword':
            sword_rect = pygame.Rect(player.rect.centerx, player.rect.centery, 40, 10)
            for enemy in enemies[:]:
                if sword_rect.colliderect(enemy.rect):
                    enemies.remove(enemy)
                    player.loot.append(enemy.loot)
                    score += 1

        for enemy in enemies:
            if player.rect.colliderect(enemy.rect):
                player.health -= 1
                if player.health <= 0:
                    running = False

        for loot in loot_items[:]:
            if player.rect.colliderect(loot.rect):
                player.loot.append(loot.item_type)
                loot_items.remove(loot)

        # Update bomb and check for transition
        if bomb.update(player):
            # Transition to the next dungeon
            current_map_index, walls, doors, enemies, loot_items = transition_to_next_map(current_map_index, player, enemy_start_positions)
            bomb = Bomb(random.randint(200, MAP_WIDTH - 200), random.randint(200, MAP_HEIGHT - 200))
            print("Transitioning to next dungeon...")  # Debug print

        camera.update(player)

        screen.fill((0, 0, 0))

        for wall in walls:
            wall.draw(screen, camera)
        for door in doors:
            door.draw(screen, camera)

        player.draw(screen, camera)
        for bullet in bullets:
            bullet.draw(screen, camera)
        for enemy in enemies:
            enemy.draw(screen, camera)
        for loot in loot_items:
            loot.draw(screen, camera)
        bomb.draw(screen, camera)

        font = pygame.font.Font(None, 36)
        score_text = font.render(f'Score: {score}', True, (255, 255, 255))
        health_text = font.render(f'Health: {player.health}', True, (255, 255, 255))
        loot_text = font.render(f'Loot: {", ".join(player.loot)}', True, (255, 255, 255))
        screen.blit(score_text, (10, 10))
        screen.blit(health_text, (10, 40))
        screen.blit(loot_text, (10, 70))

        if player.health <= 0:
            game_over_text = font.render('Game Over', True, (255, 0, 0))
            screen.blit(game_over_text, (SCREEN_WIDTH // 2 - 50, SCREEN_HEIGHT // 2 - 20))
            pygame.display.flip()
            pygame.time.wait(2000)
            running = False

        pygame.display.flip()
        clock.tick(FPS)

pygame.quit()
sys.exit()
