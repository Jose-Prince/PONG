# PONG

A classic Pong game implementation using the LÖVE 2D (Love2D) game engine and Lua programming language.

## Table of Contents
- [Overview](#overview)
- [Requirements](#requirements)
- [Installation](#installation)
- [Game Features](#game-features)
- [Controls](#controls)
- [File Structure](#file-structure)
- [Code Architecture](#code-architecture)
- [Classes and Components](#classes-and-components)
- [Game States](#game-states)
- [Settings and Customization](#settings-and-customization)
- [Technical Details](#technical-details)

## Overview

This is a modern implementation of the classic Pong arcade game featuring:
- Two-player local gameplay
- Customizable settings (background colors, screen sizes)
- Score tracking
- Winner announcement system
- Menu-driven interface
- Object-oriented design using Lua classes

## Requirements

- **LÖVE 2D Engine** (Love2D) - version 11.0 or higher
- **Font File**: `font/Minecraft.ttf` (included in project)
- **Operating System**: Windows, macOS, or Linux (Love2D is cross-platform)

## Installation

1. Download and install [LÖVE 2D](https://love2d.org/) for your operating system
2. Clone or download this repository
3. Ensure the `font/Minecraft.ttf` file is in the correct directory
4. Run the game by either:
   - Dragging the game folder onto the Love2D executable
   - Running `love .` from the command line in the game directory
   - Creating a `.love` file by zipping the game files

## Game Features

### Core Gameplay
- **Two-player Pong**: Classic paddle-based ball bouncing game
- **Dynamic Ball Physics**: Ball direction changes based on paddle collision point
- **Score System**: Points awarded when opponent misses the ball
- **Round-based Play**: Game pauses between points with winner announcement

### Customization Options
- **Background Colors**: Black, Blue, Green, Orange, Red
- **Screen Sizes**: Small (400x300), Medium (800x600), Big (1200x1000), Full Screen
- **Responsive Design**: Game elements scale and reposition based on screen size

## Controls

### Menu Navigation
- **Arrow Keys (Up/Down)**: Navigate menu options
- **Enter/Return**: Select menu option
- **Escape**: Return to previous menu (from settings)

### Gameplay
- **Player 1 (Left Paddle)**:
  - `W` - Move up
  - `S` - Move down

- **Player 2 (Right Paddle)**:
  - `Up Arrow` - Move up
  - `Down Arrow` - Move down

- **Game Controls**:
  - `Escape` (hold for 3 seconds) - Return to main menu

### Settings Menu
- **Arrow Keys (Up/Down)**: Navigate settings
- **Arrow Keys (Left/Right)**: Change setting values
- **Escape**: Return to main menu

## File Structure

```
pong-game/
├── main.lua           # Main game loop and state management
├── classic.lua        # Object-oriented programming library
├── player.lua         # Player/Paddle class
├── ball.lua          # Ball physics and collision class
├── scorepoint.lua    # Score display and tracking
├── winnerScreen.lua  # Winner announcement (referenced but not provided)
├── font/
│   └── Minecraft.ttf # Game font
├── .gitignore        # Git ignore file
└── README.md         # This documentation
```

## Code Architecture

The game follows an object-oriented design pattern using the `classic.lua` library for class inheritance.

### Main Game Loop (`main.lua`)

The main file handles:
- **Game State Management**: Menu, Settings, Gameplay states
- **Input Processing**: Keyboard input handling for all game states
- **Rendering**: Drawing all game elements based on current state
- **Game Logic**: Collision detection, scoring, and round management

### Key Variables and States

```lua
local gameStarted = false    # Controls gameplay state
local optionStarted = false  # Controls settings menu state
local roundEnd = false       # Controls round-end state
local lastScorer = 0         # Tracks who scored last point
```

## Classes and Components

### Player Class (`player.lua`)
Represents the paddles controlled by players.

**Properties:**
- `width, height` - Paddle dimensions
- `x, y` - Position coordinates
- `up, down` - Assigned control keys

**Methods:**
- `new(width, height, x, y, up, down)` - Constructor
- `draw()` - Renders the paddle
- `move(dt)` - Handles paddle movement based on input
- `relocate(newX, newY)` - Updates paddle position

### Ball Class (`ball.lua`)
Manages ball physics, movement, and collision detection.

**Properties:**
- `x, y` - Ball position
- `radius` - Ball size
- `direction` - Movement angle in radians

**Methods:**
- `new(x, y, radius, direction)` - Constructor
- `draw()` - Renders the ball
- `move(dt)` - Updates ball position and handles wall bouncing
- `bounceOff(player)` - Calculates ball bounce off paddle
- `checkPoint()` - Determines if a point was scored
- `relocate(newX, newY)` - Resets ball position

**Physics Details:**
- Ball speed: 100 pixels per second
- Bounce angle calculation based on paddle hit position
- Maximum bounce angle: 60 degrees

### Scorepoint Class (`scorepoint.lua`)
Handles score tracking and display.

**Properties:**
- `player1_score, player2_score` - Score counters

**Methods:**
- `new()` - Initializes scores to 0
- `draw()` - Renders scores and center line
- `update(player)` - Increments score for specified player

## Game States

### 1. Main Menu
- Displays game title and menu options
- Options: PLAY, SETTINGS, QUIT GAME
- Navigation with arrow keys and Enter

### 2. Settings Menu
- Background color selection (5 colors available)
- Screen size selection (4 sizes including fullscreen)
- Real-time preview of changes
- Navigation with arrow keys

### 3. Gameplay
- Active game with ball physics and paddle movement
- Collision detection between ball and paddles
- Score tracking and display
- Round-end announcements

### 4. Round End
- Temporary pause after each point
- Winner announcement display
- Automatic return to gameplay

## Settings and Customization

### Background Colors
```lua
local colors = { "BLACK", "BLUE", "GREEN", "ORANGE", "RED" }
local rgb_colors = { {0, 0, 0}, {0, 0, 255}, {0, 255, 0}, {255, 165, 0}, {255, 0, 0} }
```

### Screen Sizes
```lua
local sizes = { "SMALL", "MEDIUM", "BIG", "FULL SCREEN" }
local num_sizes = {{400, 300}, {800, 600}, {1200, 1000}}
```

## Technical Details

### Collision Detection
The game uses AABB (Axis-Aligned Bounding Box) collision detection:

```lua
function checkCollision(player, ball)
  -- Calculates overlapping rectangles between paddle and ball
  return player_right > ball_left and player_left < ball_right and 
         player_bottom > ball_top and player_top < ball_bottom
end
```

### Ball Physics
- **Direction**: Stored in radians for trigonometric calculations
- **Speed**: Constant 100 pixels/second in current direction
- **Bounce Calculation**: Dynamic angle based on paddle hit position
- **Wall Bouncing**: Automatic reflection off top and bottom walls

### Performance Considerations
- Delta time (`dt`) used for frame-rate independent movement
- Efficient collision detection only when ball is near paddles
- Minimal object creation during gameplay loop

### Font and Graphics
- Custom Minecraft-style TTF font
- Scalable UI elements that adapt to screen size
- Clean vector graphics using Love2D's drawing functions

## Extending the Game

The modular design makes it easy to add features:

- **New Game Modes**: Modify ball physics or add power-ups
- **AI Players**: Replace keyboard input with AI logic in Player class
- **Sound Effects**: Add audio using Love2D's audio system
- **Particle Effects**: Enhance visual feedback for collisions
- **More Settings**: Add difficulty levels, ball speed options
- **Tournament Mode**: Extend scoring system for multi-game matches

## Troubleshooting

**Common Issues:**
1. **Missing Font Error**: Ensure `font/Minecraft.ttf` exists in the correct path
2. **Game Won't Start**: Verify Love2D is properly installed
3. **Controls Not Working**: Check that keyboard input isn't blocked by other applications
4. **Fullscreen Issues**: Some systems may require specific fullscreen settings

**Performance Tips:**
- The game is optimized for 60 FPS gameplay
- Reduce screen size if experiencing frame drops on older hardware
- Ensure Love2D version compatibility (11.0+)

## License

This project uses the classic.lua library which is licensed under the MIT License. The game code is available for educational and personal use.
