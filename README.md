# old_processing_ascii_filter
ACII Video filter from 2011 by Andy Wallace

Note: I made this while I was attending Parsons in 2011 and it will need to be tweaked to work with current verisons of Processing.

video example: https://vimeo.com/27380117

Based on an example project by Ben Fry packaged with the Processing language, this program takes incoming video and converts it to a text output. Pixels from the original image are considered as a group, and each letter is chosen based on both its overall weight as well as how well the shape fits the 2x2 pixel group.

Ben Fry's original required the use of color to show the image, but to have a filter that felt authentic to ASCII art, I wanted to create one that worked in simple black and white.

ASCIIvideo is the main project, but I used a secondary project, ASCIIvideoCharacterWeights to anazlyze the font being used. The results from ASCIIvideoCharacterWeights are copy/pasted into the code of ASCIIvideo.