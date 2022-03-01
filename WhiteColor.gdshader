shader_type canvas_item;
// particles
// spatial is for 3d
// canvas_item is for 2d
uniform  bool active = false;

void fragment() {
	vec4 previous_color = texture(TEXTURE, UV);
	vec4 white_color = vec4(1.0, 1.0, 1.0, previous_color.a);
	vec4 new_color = previous_color;
	if (active) {
		new_color = white_color;
	}
	COLOR = new_color;
}