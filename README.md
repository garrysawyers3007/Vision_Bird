# Flappy Bird with Wing Tracking (MATLAB)

## Introduction  
This is a MATLAB implementation of the classic Flappy Bird game controlled by computer vision. The game tracks the user's "wings" — colored objects of the user's choice — and detects flapping motions to make the bird fly. This hands-free interaction offers a unique, physical way to play Flappy Bird.

## How to Play  
- Show a colored object (your "wings") in front of your camera, and when prompted, drag a box around the color of the wings to calibrate. 
- Flap your wings (move the colored objects up and down) to make the bird flap and fly. Ensure the wings exit the marked box for the program to register a flap.
- If you don't flap, the bird starts falling due to gravity. Avoid the pipes and keep flying as long as possible.

## Implementation Details

### User Interface (UI)  
- The game window displays the classic Flappy Bird gameplay with scrolling pipes and a bird sprite.
- Real-time camera feed is used on the side for wing tracking.  

### Computer Vision  
- The program captures video frames using MATLAB’s webcam interface.  
- It filters the frames based on the user-selected color range (HSV threshold).  
- Contours or blobs of the specified color are tracked to identify wing positions.  
- Flapping is detected by analyzing vertical motion patterns of the wings, triggered when the wing object exits a box. 
- When a flap motion is detected, a bird flap action is triggered in the game.

## Demo

## Credits
