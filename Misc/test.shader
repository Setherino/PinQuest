shader_type canvas_item;
uniform float amount : hint_range(0,10);
void fragment() {
    COLOR.rgb = textureLod(SCREEN_TEXTURE,UV,100).rgb;
}