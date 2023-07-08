#version 120

uniform vec2      resolution;
uniform sampler2D sampler0;
varying vec2      textureCoord;

void main()
{
    const float Pi = 6.28318530718; // Pi*2
    
    // GAUSSIAN BLUR SETTINGS {{{
    const float Directions = 16.0; // BLUR DIRECTIONS (Default 16.0 - More is better but slower)
    const float Quality = 3.0; // BLUR QUALITY (Default 4.0 - More is better but slower)
    const float Size = 2.0; // BLUR SIZE (Radius)
    // GAUSSIAN BLUR SETTINGS }}}
   
    vec2 Radius = Size/resolution;
    
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = textureCoord;
    // Pixel colour
    vec4 Color = texture2D(sampler0, uv);
    
    // Blur calculations
    for( float d=0.0; d<Pi; d+=Pi/Directions)
    {
		for(float i=1.0/Quality; i<=1.0; i+=1.0/Quality)
        {
			Color += texture2D( sampler0, uv+vec2(cos(d),sin(d))*Radius*i);		
        }
    }
    
    // Output to screen
    Color /= Quality * Directions - 15.0;
    Color.rgb *= 0.4;
    gl_FragColor = Color;
}