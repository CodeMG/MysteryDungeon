shader_type canvas_item;
render_mode unshaded;

uniform float radius : hint_range(0.0, 1.0, 0.01) = .7;

uniform float thickness : hint_range(0.0, 1.0, 0.01) = .2;

uniform vec4 color : source_color = vec4(0.9, 0.4, 0.1, 1.0);

uniform vec4 highlight_color: source_color = vec4(0.5,0.5,0.0,1.0);

uniform float brightness : hint_range(0.0, 15.0, 0.01) = 5.0;

uniform float angular_speed : hint_range(-5.0, 5.0, 0.01) = 2.5;

uniform float radial_speed : hint_range(-5.0, 5.0, 0.01) = 1.4;

uniform float alpha : hint_range(0.0, 1.0, 0.01) = .5;

uniform sampler2D noise;

void fragment() {
	vec2 v = vec2(.5) - UV; //Move UVs to center
	vec2 v_abs = abs(v);
	float d_square = max(v_abs.x,v_abs.y)*2.;
	float angle = atan(v.y, v.x)+ (TIME * angular_speed);
	float thick_ratio_square = 1. - (abs(d_square - max(0., radius)) / max(.0001, thickness));
	vec2 polar_square = fract(vec2(angle / 6.28, d_square + (TIME * radial_speed)));
	vec4 col = thick_ratio_square * brightness * color;
	
	vec3 tex = texture(noise, polar_square).rgb;
	//col.a = (alpha * (tex.r + tex.g + tex.b) * clamp(thick_ratio_square, 0., 1.)) / 1.;
	//col.rgb = (col.rgb)+ (thick_ratio_square * highlight_color.rgb * (1.0-col.a));
	COLOR = col;
	COLOR.a = length(tex) * thick_ratio_square;
	COLOR = COLOR + vec4(highlight_color.rgb,0.0)*(1.0-COLOR.a);
	COLOR.a = thick_ratio_square;
}