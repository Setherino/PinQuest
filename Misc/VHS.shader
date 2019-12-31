shader_type canvas_item;
render_mode unshaded;

uniform float redX : hint_range(-10.0,10.0);

uniform float blueX : hint_range(-10.0,10.0);

uniform float greenX : hint_range(-10.0,10.0);
void fragment()
{
	vec4 color = texture(SCREEN_TEXTURE,SCREEN_UV);
	vec2 size = 1.0 / vec2(textureSize(SCREEN_TEXTURE,0));
	
	vec4 red = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x + size.x*redX,SCREEN_UV.y + size.y * redX));
	vec4 blue = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x + size.x*blueX,SCREEN_UV.y + size.y * blueX));
	vec4 green = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x + size.x*greenX,SCREEN_UV.y + size.y * greenX));
	
	vec4 final_color = vec4(red.r,blue.g* 0.9,green.b* 0.8,1.0);
	
	COLOR = final_color;
}