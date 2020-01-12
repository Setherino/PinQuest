extends Control


const MAXIMUM = 14

onready var display = get_node("CanvasLayer/CharacterDisplay")

onready var label = get_node("CanvasLayer/Label")
var current = 1

var nextLevelLoad = "res://UI/mainMenu.tscn"

var characters = ["Dog", "Baker",
 "Elder","OfficeWorker",
"Student1","Trendy","NO",
"BusinessMan","OldBusinessMan",
"Casual","Punk","Student2",
"Student3","Robes",
"TrafficCop","NO"]

var currentFrame = 0

func _ready():
	randomize()
	current = randi()%14-1
	update()

func rotate():
	if display.get_frame() < 3:
		display.set_frame(display.get_frame()+1)
	else:
		display.set_frame(0)
	currentFrame = display.get_frame()

func update():
	display.set_animation(characters[current])
	display.set_frame(currentFrame)
	label.text = characters[current]

func _on_Left_pressed():
	if current > 0:
		current -= 1
		if characters[current] == "NO":
			current -=1
	else:
		current = MAXIMUM
	update()


func _on_Right_pressed():
	if current < MAXIMUM:
		current += 1
		if characters[current] == "NO":
			current +=1
	else:
		current = 0
	update()


func _on_Rotate_pressed():
	rotate()


func _on_Select_pressed():
	main.playerCharacter = current
	get_tree().change_scene(nextLevelLoad)
	queue_free()
