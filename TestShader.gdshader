shader_type canvas_item;
//render_mode blend_add;
uniform float width = 16.0f;
uniform float height = 16.0f;

uniform sampler2D noise_tex:repeat_enable;
uniform sampler2D gradient_tex;
uniform sampler2D screen_texture:hint_screen_texture;

float f(float x,float offset){
	return sin(x+TIME*5.0)+offset;
}

vec3 palette(float t)
{
	vec3 a = vec3(0.010,0.428,1.018);
	vec3 b = vec3(5.297,0.457,0.457);
	vec3 c = vec3(6.157,0.137,2.197);
	vec3 d = vec3(2.737,0.602,0.935);
	
    return a + b*cos( 6.28318*(c*t+d) );
}

vec3 hash3( vec2 p ){
    vec3 q = vec3( dot(p,vec2(127.1,311.7)), 
				   dot(p,vec2(269.5,183.3)), 
				   dot(p,vec2(419.2,371.9)) );
	return fract(sin(q)*43758.5453);
}

float voronoi(vec2 uv, float voronoi_progress,float sharpness){
	float value = 0.0;
	float k = 1.0+63.0*pow(1.0-sharpness,6.0);
	vec2 i = floor(uv);
    vec2 f = fract(uv);
	
	vec2 a = vec2(0.0,0.0);
    for( int y=-2; y<=2; y++ ){
    	for( int x=-2; x<=2; x++ )
    	{
        	vec2 g = vec2( float(x), float(y) );
			vec3 o = hash3( i + g )*vec3(voronoi_progress,voronoi_progress,1.0);
			vec2 d = g - f + o.xy;
			float w = pow( 1.0-smoothstep(0.0,1.414,length(d)), k );
			a += vec2(o.z*w,w);
    	}
	}
	
	return a.x/a.y;
}

void fragment() {
	vec2 resolution = 1.0/TEXTURE_PIXEL_SIZE;
	vec2 new_UV = (UV * resolution);
	new_UV.x /= width;
	new_UV.y /= height;
	
	//vec2 p = 0.5 - 0.5*cos( TIME+vec2(0.0,2.0) );
	
	//p = p*p*(3.0-2.0*p);
	//p = p*p*(3.0-2.0*p);
	//p = p*p*(3.0-2.0*p);
	//p = p*p*(3.0-2.0*p);
	//p = p*p*(3.0-2.0*p);
	
	//float f = voronoi(10.0*new_UV,p.x,0.0);
	
	vec4 noise = texture(noise_tex,UV);
	vec4 gradient = texture(gradient_tex,UV);
	
	COLOR = texture(TEXTURE,UV);
}

void light(){
	vec3 texture_diff = texture(screen_texture,SCREEN_UV).rgb-texture(TEXTURE,UV).rgb * -1.0;
	LIGHT  = vec4(texture_diff,1.0);
	LIGHT = texture(screen_texture,SCREEN_UV)*LIGHT_COLOR;
	//LIGHT = LIGHT_COLOR;
}