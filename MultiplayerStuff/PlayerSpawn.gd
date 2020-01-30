extends Node2D

tool

export var spawnArea = Vector2(200,80) setget setSpawnArea
export var areaColor = Color(0.517184, 0.375366, 0.960938, 0.298039) setget setAreaColor

onready var player = preload("res://Scenes/Player.tscn")

#we use these setters so that it can update whenever
#brad changes the color...
func setAreaColor(var color):
	areaColor = color
	update() #updates the rectangle

var myPlayers = [ ]
var myPlayersPosition = [ ]
#or the size
func setSpawnArea(var area):
	spawnArea = area
	update() #updates the rectangle

func _draw():
	if Engine.editor_hint: #if we're in the editor & wander is enabled
		#draw the rectangle
		draw_rect(Rect2(Vector2(spawnArea.x*-1,spawnArea.y*-1),spawnArea*2),areaColor,true)

func addPlayer(var world2d,var replace = false,var id = 0):
	if get_world_2d() != world2d:
		return
	
	var playerInstance = player.instance()
	randomize()
	playerInstance.position.x = round(rand_range(spawnArea.x*-1,spawnArea.x))
	playerInstance.position.y = 944 - position.y
	print(main.players.size())
	main.appendPlayers(playerInstance)
	if !replace:
		myPlayers.append(playerInstance)
		myPlayersPosition.append(playerInstance.position)
	else:
		myPlayers.insert(id-1,playerInstance)
		myPlayers.remove(id)
	add_child(playerInstance)

func removePlayer(var player):
	var playerID = myPlayers.find(player)
	
	myPlayersPosition.insert(playerID,player.position)
	myPlayersPosition.remove(playerID+1)
	remove_child(player)
	
	main.playerSpawn.remove(main.playerSpawn.find(self))
	
	if get_child_count() < 1:
		main.unload(get_world_2d())

func replacePlayer(var world2d,var player):
	if get_world_2d() != world2d:
		return
	
	
	player.get_parent().removePlayer(player)
	var playerID = myPlayers.find(player)
	
	if playerID != -1:
		player.position = myPlayersPosition[playerID]
	else:
		player.position = Vector2(0,0)
	player.idleFrame = 0
	add_child(player)


func getPlayer(var world2d,var id):
	if get_world_2d() != world2d:
		return
	
	for player in myPlayers:
		if player.playerID == id:
			return player

func _ready():
	if Engine.editor_hint:
		return
	main.connect("spawnPlayer",self,"addPlayer")
	main.connect("replacePlayer",self,"replacePlayer")
	if !main.playerSpawn.has(self):
		main.playerSpawn.append(self)
	