extends Node2D
tool


export var spawnArea = Vector2(250,100) setget setSpawnArea
export var areaColor = Color(1,.5,.5) setget setAreaColor
export var randomRotation = true
export var spriteScale = 1.0
export var sourceTask = "none"
export var ammountToSpawn = 5
export var texture : Texture


const spawner = preload("res://Scenes/Objects/Collectables/Collectable.tscn")

#we use these setters so that it can update whenever
#brad changes the color...
func setAreaColor(var color):
	areaColor = color
	update() #updates the rectangle

#or the size
func setSpawnArea(var area):
	spawnArea = area
	update() #updates the rectangle

var ammountSpawned = 0
var prevCoins = 0

func _process(delta):
	if Engine.editor_hint:
		return
	if main.taskType == 0:
		ammountSpawned = 0
	
	if main.taskType == 1:
		print("task started")
		if main.taskName == sourceTask:
			print("my task")
			if prevCoins != main.taskAmmountCollected:
				ammountSpawned -= abs(prevCoins - main.taskAmmountCollected)
				prevCoins = main.taskAmmountCollected
			
			
			
			var spawn = spawner.instance()
			randomize()
			spawn.position = Vector2(round(rand_range(spawnArea.x*-1,spawnArea.x)),round(rand_range(spawnArea.y*-1,spawnArea.y)))
			spawn.texture = texture
			spawn.taskSource = sourceTask
			spawn.scale = Vector2(spriteScale,spriteScale)
			if randomRotation:
				spawn.rotation_degrees = randi()%360
			if ammountSpawned < ammountToSpawn:
				add_child(spawn) #create the items
				ammountSpawned += 1
	
	

func _draw():
	if Engine.editor_hint: #if we're in the editor
		#draw the rectangle
		draw_rect(Rect2(Vector2(spawnArea.x*-1,spawnArea.y*-1),spawnArea*2),areaColor,false)


func _ready():
	main.connect("taskStarted",self,"_taskStart")
	
	if main.taskName == sourceTask:
		main.taskTargetX = position.x

func _taskStart():
	if main.taskName == sourceTask:
		main.taskTargetX = position.x