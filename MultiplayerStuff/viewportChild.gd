extends ViewportContainer

onready var camera = get_node("Viewport/Camera2D")
onready var viewport = get_node("Viewport")
var world

func worldFilename():
	if world:
		return world.filename
	else:
		return "N/A"

func loadLevel(var level):
	if viewport.has_node("World"):
		print(viewport.get_node("World").name)
		viewport.get_node("World").queue_free()
	
	
	world = load(level).instance()
	world.name = "World"
	
	viewport.add_child(world)
