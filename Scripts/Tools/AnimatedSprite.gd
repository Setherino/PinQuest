extends Node2D
tool

export(String, "BannerBlue", "BannerRed", "Lanterns","Plant","Tree") var Anim setget setAnim

export var speedScale = 1  setget setSpeed

export var playBackwards = false setget playset

export var automaticallyDesync = true

func setSpeed(var this):
	speedScale = this
	
	if Engine.editor_hint:
		get_node("animation").set_speed_scale(this)

func setAnim(var this):
	Anim = this
	
	if Engine.editor_hint:
		get_node("animation").play(this,playBackwards)

func _ready():
	if automaticallyDesync:
		get_node("animation").set_speed_scale(speedScale * rand_range(0.95,1.05))
	
	get_node("animation").play(Anim,playBackwards)

func playset(var this):
	playBackwards = this
	
	if Engine.editor_hint:
		get_node("animation").play(Anim,playBackwards)