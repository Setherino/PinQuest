tool
extends Node2D




export(String, "Debug/", "LevelOne/", "LevelTwo/","LevelThree/","LevelFour/") var Folder
#this is the NPC's name, obviously
export var npcName = "john"
#this is the file where all the dialogue is stored
export var dialogueSourceName = "Template"

export(String, "Dog", "FemaleBaker", "FemaleElder","FemaleOfficeWorker","FemaleStudent","FemaleTrendy","FemaleYouth","MaleBusinessMan","OldBusinessMan","MaleCasual","MalePunk","MaleStudent","MaleStudent1","MaleTraditional","MaleTrafficCop","MaleYouth","Witch","NONE") var Appearance setget setChar

export var dialogueIcon : Texture

var appear

#whether or not the NPC will walk around randomly
export var wander = false setget setWander
export var stillness = 2
export var speed = 100
export var wanderArea = Vector2(200,80) setget setSpawnArea
export var areaColor = Color(0.517184, 0.375366, 0.960938, 0.298039) setget setAreaColor
export var useTaskName = false
export var taskName = "none"
func setWander(var wand):
	wander = wand
	update()

#we use these setters so that it can update whenever
#brad changes the color...
func setAreaColor(var color):
	areaColor = color
	update() #updates the rectangle

#or the size
func setSpawnArea(var area):
	wanderArea = area
	update() #updates the rectangle

func setChar(var charac):
	Appearance = charac
	get_node("KinematicBody2D").setChar(charac)


func _draw():
	if Engine.editor_hint && wander: #if we're in the editor & wander is enabled
		#draw the rectangle
		draw_rect(Rect2(Vector2(wanderArea.x*-1,wanderArea.y*-1),wanderArea*2),areaColor,true)

