shader_type canvas_item;
render_mode unshaded;

uniform float multiply : hint_range(0.0,10.0);

void fragment()
{
	if (multiply == 0.0)
	{
		COLOR = texture(TEXTURE,UV);
	}
	else
	{
	vec4 red = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x * 1.1 * multiply,SCREEN_UV.y));
	vec4 blue = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x * -1.1,SCREEN_UV.y * multiply));
	vec4 green = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x * multiply,SCREEN_UV.y * 1.1 * multiply));
	
	vec4 final_color = vec4(red.r * multiply,green.g * (blue.b / red.r),blue.b * -multiply,multiply);
	
	COLOR = final_color;
	}
}