shader_type canvas_item;

uniform sampler2D noise_tex:repeat_enable;
uniform sampler2D gradient_tex;

uniform vec4 brighter_color : source_color = vec4(1.0, 0.8, 0.0, 1.0);
uniform vec4 middle_color : source_color  = vec4(1.0, 0.56, 0.0, 1.0);
uniform vec4 darker_color : source_color  = vec4(0.64, 0.2, 0.05, 1.0);

uniform float width = 16.0f;
uniform float height = 16.0f;
//uniform float spread:hint_range(0.0, 1.0) = 1.0;



float noise(vec2 co,float offset){
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453 + TIME + offset);
}


void fragment() {
	vec4 col = vec4(1,0,0,1);
	vec2 resolution = 1.0/TEXTURE_PIXEL_SIZE;
	vec2 new_UV = (UV * resolution);
	new_UV.x /= width;
	new_UV.y /= height;
	
	float pixelsize = max(width,height);
	
	//square
	vec2 v = vec2(.5) -new_UV; //Move UVs to center
	vec2 v_abs = abs(v);
	float d_square = max(v_abs.x,v_abs.y)*2.;
	float thick_ratio_square = 1. - (abs(d_square - max(0., 0.8)) / 0.2);
	
	//Make square gradient
	//float square_gradient = abs(d_square-0.6) / 2.0;
	//Make fire
	//vec2 normalized_v = new_UV*2.0 - 1.0; 
	//noise_dir = normalize(noise_dir);
	//float noise_value = texture(noise_tex, UV/0.5 + vec2(0,1) * TIME*0.8).x;
	// The .yx swizzle is when using the built in horizontal gradient texture. If you have a vertical gradient texture remove .yx
	//float gradient_value = texture(gradient_tex, UV.yx).x;
	//gradient_value -= smoothstep(spread, spread + 0.5, length(UV + vec2(-0.5, -0.5)) / spread);
	
	float noise_value = noise(floor(UV*pixelsize),0);
	float noise_value2 = noise(floor(UV*pixelsize),4);
	
	
	COLOR = brighter_color * thick_ratio_square * noise_value;
	COLOR += middle_color * thick_ratio_square * noise_value2;
	COLOR += darker_color * thick_ratio_square*(1.0-COLOR.a);
	COLOR.a = 0.0;
	COLOR.a += thick_ratio_square;
	
	//COLOR = vec4(noise(floor(UV*32.0),0)*thick_ratio_square,0,0,1.0);
	//COLOR = vec4(d_square*0.7,0,0,1);
	//COLOR = vec4(square_gradient,0,0,1);
	//COLOR = vec4(noise_dir,0,1.0);
}
