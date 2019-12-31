shader_type canvas_item;
render_mode unshaded;

void fragment()
{
	vec2 size = 1.0 / vec2(textureSize(SCREEN_TEXTURE,0));
	vec4 color = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x + size.x * 10.0,SCREEN_UV.y));
	
	
	COLOR = color;
}