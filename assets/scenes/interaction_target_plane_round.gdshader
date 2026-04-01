shader_type spatial;

uniform vec2 plane_size = vec2(1.0, 1.0);
uniform vec3 color = vec3(1.0, 1.0, 1.0);
uniform float time_multiplier = 1.0;
uniform float background_size = 1.0;
uniform float outline_width = 0.1;
uniform float alpha_mod = 1.0;

bool is_outline(vec2 uv){
	return (
		uv.x < outline_width / plane_size.x ||
		uv.x > 1.0 - outline_width / plane_size.x ||
		uv.y < outline_width / plane_size.y ||
		uv.y > 1.0 - outline_width / plane_size.y
	);
}

bool is_background(vec2 uv){
	return sin(
		((uv.x * plane_size.x + uv.y * plane_size.y) / background_size ) * PI * 2.0 + TIME * time_multiplier
	) > 0.0;
}

void fragment() {
	ALBEDO = color;
	ALPHA = 0.0;
	
	if(
		is_outline(UV) ||
		is_background(UV)
	) ALPHA = 1.0 * alpha_mod;
}

