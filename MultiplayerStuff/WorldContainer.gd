extends Viewport

var level

var outside

func _ready():
	main.connect("unload",self,"unload")
	var level_instance = load(level).instance()
	if level_instance.has_node("TaskManager"):
		outside = true
	else:
		outside = false
	add_child(level_instance)

func unload(var world2d):
	if world2d == get_world_2d():
		Hud.saveToTemp(self)
		queue_free()