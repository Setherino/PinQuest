extends Node

onready var viewportConatiner = preload("res://MultiplayerStuff/ViewportContainer1.tscn")
onready var container = get_node("HBoxContainer")
onready var activeWorldsContainer = get_node("activeWorlds")

onready var worldContainer = preload("res://MultiplayerStuff/WorldContainer.tscn")

var viewports = 0

var player

var activeWorlds = [ ]

func levelLoaded(var level):
	for viewport in main.viewports:
		if viewport.worldFilename() == level:
			return viewport
	return false

func changeScene(var level,var playerID):
	playerID -= 1
	var loaded = levelLoaded(level)
	
	var nextlevel = getLevel(level)
	
	main.viewports[playerID].camera.outside = nextlevel.outside
	
	main.viewports[playerID].viewport.world_2d = nextlevel.world_2d

	
	main.replacePlayer(main.viewports[playerID].viewport.world_2d,main.players[playerID])

func getLevel(var levelLocation):
	for world in activeWorlds: #loop through all the active worlds
		if world.level == levelLocation: #if we have one with that location
			return world #return it
	
	#if not, we have to make one
	var worldInstance = worldContainer.instance() #create instance of world container
	worldInstance.level = levelLocation #set the containers level
	activeWorldsContainer.add_child(worldInstance) #add it to the active worlds list
	activeWorlds.append(worldInstance) #add world to array to keep track of it
	worldInstance.set_pause_mode(Node.PAUSE_MODE_PROCESS)
	return worldInstance #return it

func makeScreen():
	if viewports > 2:
		print("set to " + str(round(sqrt(main.viewports.size()))))
		container.set_columns(round(sqrt(main.viewports.size())))
		pass
	
	var viewportInstance = viewportConatiner.instance()
	container.add_child(viewportInstance)
	main.appendViewport(viewportInstance)
	
	
	viewportInstance.viewport.world_2d = getLevel("res://Scenes/Levels/Level1/Level1Outdoor.tscn").world_2d
	
	viewports += 1
	main.spawnPlayer(viewportInstance.viewport.world_2d)
	viewportInstance.camera.target = main.players.back()

func _input(event):
	if Input.is_action_just_pressed("ui_end"):
		makeScreen()
	if Input.is_action_just_pressed("ui_home"):
		
		main.players.back().queue_free()
		main.players.pop_back()
		main.viewports.back().queue_free()
		main.viewports.pop_back()

func unload(var world2d):
	var index = 0
	
	for world in activeWorlds:
		if world == world2d:
			world2d.remove(index)
			index += 1


func _ready():
	main.connect("unload",self,"unload")
	main.splitscreen = self
	makeScreen()
	
	
	
	
	
	
	
	