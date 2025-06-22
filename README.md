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
- Customizable settings (background colors, screen sizes, ball speed)
- Score tracking with visual scoreboard
- Winner announcement system with countdown timer
- Menu-driven interface with pause functionality
- Object-oriented design using Lua classes
- Background music and sound effects
- Dynamic ball physics with speed increase on paddle hits

## Requirements

- **LÖVE 2D Engine** (Love2D) - version 11.0 or higher
- **Font File**: `font/Minecraft.ttf` (included in project)
- **Audio Files**: Background music and sound effects (included)
- **Game Icon**: `logo/NNugSj.png` (included)
- **Operating System**: Windows, macOS, or Linux (Love2D is cross-platform)

## Installation

### Manual:

For manual installation follow this steps:

1. Download and install [LÖVE 2D](https://love2d.org/) for your operating system
2. Clone or download this repository
3. Ensure all required files are in the correct directories:
   - `font/Minecraft.ttf`
   - `music/Undertale-Papyrus-Theme.ogg`
   - `music/gameboy-pluck-41265.ogg`
   - `logo/NNugSj.png`
4. Run the game by either:
   - Dragging the game folder onto the Love2D executable
   - Running `love .` from the command line in the game directory
   - Creating a `.love` file by zipping the game files

### Automatic:

For automatic installation in Linux just download this bash script: [bash script](./pong.sh)

For windows download this zip and execute the pong.exe file: [zip file](./pong_game.zip)

**IMPORTANT: With the automatic installation you don't have to download manually love, I don't confirm the script works in all linux distributions**

## Game Features

### Core Gameplay
- **Two-player Pong**: Classic paddle-based ball bouncing game
- **Dynamic Ball Physics**: Ball direction changes based on paddle collision point
- **Progressive Speed**: Ball speed increases with each paddle hit
- **Score System**: Points awarded when opponent misses the ball
- **Round-based Play**: Game pauses between points with winner announcement and countdown
- **Pause Functionality**: Space bar to pause/unpause during gameplay

### Audio Features
- **Background Music**: Undertale Papyrus Theme playing continuously
- **Sound Effects**: Collision sounds for paddle hits and wall bounces
- **Volume Control**: Optimized audio levels for gameplay

### Customization Options
- **Background Colors**: Black, Blue, Green, Orange, Red
- **Screen Sizes**: Small (400x300), Medium (800x600), Big (1200x1000), Full Screen
- **Ball Speed**: Adjustable initial ball speed in increments of 10
- **Responsive Design**: Game elements scale and reposition based on screen size

## Controls

### Menu Navigation
- **Arrow Keys (Up/Down)**: Navigate menu options
- **Enter/Return**: Select menu option
- **Escape**: Return to main menu (from settings or gameplay)

### Gameplay
- **Player 1 (Left Paddle)**:
  - `W` - Move up
  - `S` - Move down

- **Player 2 (Right Paddle)**:
  - `Up Arrow` - Move up
  - `Down Arrow` - Move down

- **Game Controls**:
  - `Escape` - Return to main menu
  - `Space` - Pause/Unpause game

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
├── msgScreen.lua     # Winner announcement and pause screen
├── font/
│   └── Minecraft.ttf # Game font
├── music/
│   ├── Undertale-Papyrus-Theme.ogg    # Background music
│   └── gameboy-pluck-41265.ogg        # Collision sound effect
├── logo/
│   └── NNugSj.png    # Game icon
├── .gitignore        # Git ignore file
└── README.md         # This documentation
```

## Code Architecture

The game follows an object-oriented design pattern using the `classic.lua` library for class inheritance.

### Main Game Loop (`main.lua`)

The main file handles:
- **Game State Management**: Menu, Settings, Gameplay, Pause states
- **Input Processing**: Keyboard input handling for all game states
- **Rendering**: Drawing all game elements based on current state
- **Game Logic**: Collision detection, scoring, and round management
- **Audio Management**: Background music and sound effects
- **Window Management**: Dynamic resizing and fullscreen support

### Key Variables and States

```lua
local gameStarted = false    # Controls gameplay state
local optionStarted = false  # Controls settings menu state
local roundEnd = false       # Controls round-end state
local isPaused = false       # Controls pause state
local lastScorer = 0         # Tracks who scored last point
```

## Classes and Components

### Player Class (`player.lua`)
Represents the paddles controlled by players.

**Properties:**
- `width, height` - Paddle dimensions
- `x, y` - Position coordinates
- `up, down` - Assigned control keys
- `speed` - Movement speed (default: 75, dynamically calculated based on screen size)

**Methods:**
- `new(width, height, x, y, up, down, speed)` - Constructor
- `draw()` - Renders the paddle
- `move(dt)` - Handles paddle movement with boundary checking
- `relocate(newX, newY)` - Updates paddle position

### Ball Class (`ball.lua`)
Manages ball physics, movement, and collision detection.

**Properties:**
- `x, y` - Ball position
- `radius` - Ball size
- `direction` - Movement angle in radians
- `speed` - Current ball speed
- `inc` - Speed increment per collision

**Methods:**
- `new(x, y, radius, direction, speed)` - Constructor
- `draw()` - Renders the ball
- `move(dt)` - Updates ball position and handles wall bouncing
- `redirection()` - Handles top/bottom wall collisions with sound effects
- `bounceOff(player)` - Calculates ball bounce off paddle with speed increase
- `checkPoint()` - Determines if a point was scored

**Physics Details:**
- Ball speed: Configurable starting speed (default based on screen width)
- Speed increases by 10 units on right paddle hit, by increment value on left paddle
- Bounce angle calculation based on paddle hit position
- Maximum bounce angle: 60 degrees
- Sound effects on all collisions

### Scorepoint Class (`scorepoint.lua`)
Handles score tracking and display with visual elements.

**Properties:**
- `player1_score, player2_score` - Score counters
- `color` - Display color matching game theme

**Methods:**
- `new(color)` - Initializes scores to 0 with theme color
- `draw()` - Renders scores and animated center line
- `update(player)` - Increments score for specified player

**Visual Features:**
- Large font display of scores
- Animated center line with alternating colored squares
- Color-coordinated with game theme

### MsgScreen Class (`msgScreen.lua`)
Handles winner announcements and pause screen display.

**Properties:**
- `x, y, width, height` - Screen overlay dimensions
- `startTime` - Timer for countdown functionality
- `color` - Theme-matched background color
- `type` - Screen type ("score" or "pause")

**Methods:**
- `new(x, y, width, height, color)` - Constructor
- `draw(player)` - Renders message screen with countdown or pause message

**Features:**
- 3-second countdown timer for next round
- Pause screen overlay
- Winner announcement display
- Theme-coordinated visual design

## Game States

### 1. Main Menu
- Displays "PONG" title with game options
- Options: PLAY, SETTINGS, QUIT GAME
- Navigation with arrow keys and Enter
- Yellow highlight for selected option

### 2. Settings Menu
- Three configurable options:
  - **BACKGROUND**: 5 color choices
  - **SCREEN SIZE**: 4 size options including fullscreen
  - **BALL SPEED**: Adjustable in increments of 10
- Real-time preview of changes
- Left/right arrows to modify values
- Escape to return to main menu

### 3. Gameplay
- Active game with ball physics and paddle movement
- Collision detection with sound effects
- Score tracking and display
- Round-end announcements with countdown
- Pause functionality with overlay screen

### 4. Round End
- 3-second countdown display
- Winner announcement
- Automatic ball and paddle repositioning
- Ball speed reset to initial value

### 5. Pause State
- Game freeze with overlay message
- Toggle with spacebar
- Maintains game state while paused

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

### Ball Speed
- Default: `5 * screen_width / 8`
- Adjustable in settings menu
- Increases during gameplay with paddle hits

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
- **Speed**: Variable speed with progressive increase
- **Bounce Calculation**: Dynamic angle based on paddle hit position with sound
- **Wall Bouncing**: Automatic reflection off top and bottom walls with audio feedback
- **Initial Direction**: Random angle between -20° to +20°, with 50% chance of opposite direction

### Audio System
- **Background Music**: Looping Undertale theme at 30% volume
- **Sound Effects**: Collision sounds cloned for multiple simultaneous plays
- **Audio Management**: Proper volume levels and looping controls

### Performance Considerations
- Delta time (`dt`) used for frame-rate independent movement
- Efficient collision detection only when ball approaches paddles
- Audio cloning for simultaneous sound effects
- Optimized rendering with proper state management

### Font and Graphics
- Custom Minecraft-style TTF font with dynamic sizing
- Scalable UI elements that adapt to screen size
- Color-coordinated visual theme throughout interface
- Clean vector graphics using Love2D's drawing functions

### Window Management
- Dynamic window resizing with proper scaling
- Fullscreen support
- Object relocation on screen size changes
- Responsive font sizing based on screen dimensions

## Troubleshooting

**Common Issues:**
1. **Missing Font Error**: Ensure `font/Minecraft.ttf` exists in the correct path
2. **Audio Not Playing**: Check that audio files exist in `music/` directory
3. **Game Won't Start**: Verify Love2D is properly installed and version 11.0+
4. **Controls Not Working**: Check that keyboard input isn't blocked by other applications
5. **Fullscreen Issues**: Some systems may require specific fullscreen settings
6. **Missing Icon**: Ensure `logo/NNugSj.png` exists for proper window icon

**Performance Tips:**
- The game is optimized for 60 FPS gameplay with vsync disabled
- Reduce screen size if experiencing frame drops on older hardware
- Audio cloning may impact performance on very old systems
- Ensure Love2D version compatibility (11.0+)

## Audio Credits

- Background Music: Undertale - Papyrus Theme
- Sound Effects: Gameboy pluck sound effect

## License

This project uses the classic.lua library which is licensed under the MIT License. The game code is available for educational and personal use. Audio files may have separate licensing requirements.
