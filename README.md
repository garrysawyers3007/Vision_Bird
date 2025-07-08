# Flappy Bird with Wing Tracking (MATLAB)

## Introduction  
This is a MATLAB implementation of the classic Flappy Bird game controlled by computer vision. The game tracks the user's "wings" — colored objects of the user's choice — and detects flapping motions to make the bird fly. This hands-free interaction offers a unique, physical way to play Flappy Bird.

## How to Play  
- Show a colored object (your "wings") in front of your camera, and when prompted, drag a box around the color of the wings to calibrate. 
- Flap your wings (move the colored objects up and down) to make the bird flap and fly. Ensure the wings exit the marked box for the program to detect a flap.
- If you don't flap, the bird starts falling due to gravity. Avoid the pipes and keep flying as long as possible.

## Implementation Details

Image Processing Toolbox – for color space conversion, masking, and morphological operations
Computer Vision Toolbox – for video input (webcam), frame capture, and live preview

### User Interface (UI)  
The game window includes:
- A live webcam feed showing the player's movements.
- A mask preview showing the detected colored regions, which later disappears once the user starts the game.
- A main gameplay area displaying the bird, pipes, and score.
- After the game is over, the interface displays “Game Over” and provides Restart and Exit buttons.
- The layout is built using MATLAB’s UI components like axes, rectangles, and text.

### Computer Vision  
- The program captures video frames using MATLAB’s webcam interface, mirrored for natural interaction.
- The player selects a color to represent their "wings" using a calibration step.
- The system converts video frames to HSV color space for reliable color detection under different lighting.
- Binary masks are created to isolate regions matching the selected color. 
- Contours or blobs of the specified color are tracked to identify wing positions.  
- The game defines detection zones on each side of the camera feed. Flapping is detected by analyzing vertical motion patterns of the wings, triggered when the wing object exits the detection zone. 
- A “flap” is triggered when the colored objects enter and then leave both zones simultaneously.

## Demo

## Credits
picture goes here

Vaibhav Mahapatra - Computer Vision Wizard; Niranjan Sundararajan - Flappiest Bird; Gauransh Sawhney - Consolidation King; Hamsitha Challagundla - Marketing Magician; Akanksha Tanwar - Project Manager (self-declared); Seher Bhaskar - Documentation Duchess
