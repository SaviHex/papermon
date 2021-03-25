shader_type spatial;

uniform vec4 main_color : hint_color;
uniform vec4 intersection_color : hint_color;
uniform float intersection_max_threshold = 0.5;
uniform sampler2D displ_tex : hint_white;
uniform float displ_amount = 0.6;
uniform float near = 0.15;
uniform float far = 300.0;
uniform float speed = 1.0;

float linearize(float c_depth) {
	c_depth = 2.0 * c_depth - 1.0;
	return near * far / (far + c_depth * (near - far));
}

void fragment()
{
	float zdepth = linearize(texture(DEPTH_TEXTURE, SCREEN_UV).x);
	float zpos = linearize(FRAGCOORD.z);
	float diff = zdepth - zpos;
	
	vec2 displ = texture(displ_tex, UV - (TIME * speed)).rg;
	displ = ((displ * 2.0) - 1.0) * displ_amount;
	diff += displ.x;
	
	vec4 col = mix(intersection_color, main_color, step(intersection_max_threshold, diff));
	ALBEDO = col.rgb;
}