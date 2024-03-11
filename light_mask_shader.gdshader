shader_type canvas_item;

uniform sampler2D screen_texture:hint_screen_texture;

void light(){
	LIGHT = texture(screen_texture,SCREEN_UV);
}