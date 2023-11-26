shader_type canvas_item;

uniform sampler2D alpha_texture;
uniform vec2 offset;

void fragment() {
	//COLOR.rgb = texture(alpha_texture, UV + offset).rgb; 
	COLOR.a = texture(alpha_texture, UV + offset).a;
}