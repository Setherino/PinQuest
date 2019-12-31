shader_type canvas_item;
render_mode unshaded;

void fragment()
{
	vec2 size = 1.0 / vec2(textureSize(SCREEN_TEXTURE,0));
	
	vec4 red = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x * 1.1,SCREEN_UV.y));
	vec4 blue = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x * -1.1,SCREEN_UV.y));
	vec4 green = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x,SCREEN_UV.y * 1.1));
	
	vec4 mixed = mix(red,blue,green);
	
	vec4 final_color = vec4(red.r,green.g,blue.b,red.a);
	
	COLOR = final_color;
}