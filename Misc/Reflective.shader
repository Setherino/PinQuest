shader_type canvas_item;

uniform vec4 blue_tint : hint_color;
uniform float x;

void fragment() {
	vec2 uv = SCREEN_UV;
	float y;
	
	y = SCREEN_UV.y;
	
	//y -= UV.y;
	
	vec4 color = textureLod(SCREEN_TEXTURE,vec2(uv.x,y),0.0);
	
	color = mix(color,blue_tint,0.3);
	color.rgb = mix(vec3(0.5),color.rgb, 1.4);
	
	
	COLOR = color;
	}