# MacOS-Metal Particle Sim for Visualizing Emergent Behaviors

## Description:
This is a simple MacOS+Metal application that uses the GPU to render millions of dynamic particles with a zooming feature to observe behaviors at multiple scales. 
When the system is observed from a smaller spatial scale at approximately 30X zoom, hundreds of particles can be seen that would appear to predominantly adhere to 
the random walk equation, highlighted in green at the top of the window. However, upon zooming out to roughly 15X zoom and beyond, an observer would come to describe 
the system of particles and their motion logic as being governed by a wavelike equation, where the scale of a million particles is reached at 1X zoom. Although an 
observer would see something akin to a perspective and scale-based phase transition, both random walk and wave equations simultaneously govern the motion logic of the 
particles at all times. Therefore, coarse-grained phase transitions can be concluded to be an observer perspective-relative phenomenon of emergent systems.

## Installation:
1. Clone the repository:
   ```bash
   git clone https://github.com/taylorhinchliffe/GPU-Based-Emergence-Visualization.git
2. Open the Xcode project file ParticlePaintingsV2.xcodeproj
3. Build and run the project in Xcode.

## Usage:
1. Use the slider to cycle between 30 zoom levels. Dynamics will begin automatically. Equations at the top of the screen will change their highlight based on current zoom level,
   indicating which is most visually dominant in its appearance on observable particle motion logic.

## Contributing
	1.	Fork the repository.
	2.	Create a new branch (git checkout -b feature/your-feature).
	3.	Commit your changes (git commit -m 'Add some feature').
	4.	Push to the branch (git push origin feature/your-feature).
	5.	Open a Pull Request.

## License
This project is licensed under the Creative Commons Attribution 4.0 International License (CC BY 4.0). 
You are free to:
- Share: copy and redistribute the material in any medium or format
- Adapt: remix, transform, and build upon the material for any purpose, even commercially.
Under the following terms:
- **Attribution**: You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in
any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
For more details, please refer to the [full license](https://creativecommons.org/licenses/by/4.0/).

![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)

## Credits
	•	Developed by Taylor Hinchliffe.
	•	Inspired by the intersection of art and science.

## Contact
For questions, please open an issue or contact tehinchliffe@gmail.com 
