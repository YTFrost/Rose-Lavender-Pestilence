shader_type spatial;

uniform vec2 plane_size = vec2(1.0, 1.0);
uniform vec3 color = vec3(1.0, 1.0, 1.0);
uniform float time_multiplier = 1.0;
uniform float background_size = 1.0;
uniform float outline_width = 0.1;
uniform float alpha_mod = 1.0;

bool is_outline(vec2 uv){
	float x = ( uv.x - 0.5 );
	float y = ( uv.y - 0.5 );
	float a = 0.5 - outline_width/plane_size.x;
	float b = 0.5 - outline_width/plane_size.y;
	return (x*x)/(a*a) + (y*y)/(b*b) > 1.0;
}

bool is_background(vec2 uv){
	return sin(
		((uv.x * plane_size.x + uv.y * plane_size.y) / background_size ) * PI * 2.0 + TIME * time_multiplier
	) > 0.0;
}

bool is_in_circle(vec2 uv){
	return sqrt( (uv.x - 0.5)*(uv.x - 0.5) + (uv.y - 0.5)*(uv.y - 0.5) ) < 0.5;
}

void fragment() {
	ALBEDO = color;
	ALPHA = 0.0;
	
	if(
		is_in_circle(UV) && (
			is_outline(UV) ||
			is_background(UV)
		)
	) ALPHA = 1.0 * alpha_mod;
}

