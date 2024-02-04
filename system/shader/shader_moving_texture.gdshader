shader_type canvas_item;

uniform float speed = 0.01;
uniform vec4 color:source_color;
uniform float alpha:hint_range(0.0, 1.0, 0.1) = 1.0;


void fragment() {
	vec2 uv = UV;
	uv += vec2(TIME,TIME)*speed;
	vec4 new_color = texture(TEXTURE,uv);
	new_color.rgb = color.rbg;
	new_color.a = alpha*color.a*new_color.a;
	COLOR = new_color;
}
