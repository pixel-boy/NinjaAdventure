shader_type canvas_item;

uniform sampler2D old_gradient;
uniform sampler2D gradient;
uniform float amount : hint_range(0.0,1.0) = 0.1;
uniform sampler2D screen:hint_screen_texture;


void fragment(){
	vec4 input_color = texture(screen, SCREEN_UV);
	vec4 old_input_color = input_color;
	input_color.r = texture(gradient, vec2(input_color.r, 0.0)).r;
	input_color.g = texture(gradient, vec2(input_color.g, 0.0)).g;
	input_color.b = texture(gradient, vec2(input_color.b, 0.0)).b;

	old_input_color.r = texture(old_gradient, vec2(old_input_color.r, 0.0)).r;
	old_input_color.g = texture(old_gradient, vec2(old_input_color.g, 0.0)).g;
	old_input_color.b = texture(old_gradient, vec2(old_input_color.b, 0.0)).b;

	vec4 final_color = mix(old_input_color,input_color,amount);
	COLOR = final_color;
}