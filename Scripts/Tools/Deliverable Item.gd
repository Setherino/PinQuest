tool

extends Node2D
export var sourceTask = "none"
export var DeliverTo = "person"
export var texture : Texture setget setTexture

func setTexture(var text : Texture):
	get_node("Sprite").texture = text
	texture = text

func _ready():
	if Engine.editor_hint:
		return
	
	main.connect("taskStarted",self,"_taskStart")
	get_node("Sprite").visible = false
	get_node("Sprite").texture = texture

func _taskStart():
	if Engine.editor_hint:
		return
	
	print("meme")
	if main.taskName == sourceTask:
		print("equal")
		get_node("Sprite").visible = true

func _on_Area2D_body_entered(body):
	print("entered")
	if main.taskName == sourceTask:
		Hud.showMessage("Item Collected","You've collected the " + main.taskGoal + 
		". Now you have to deliver it too " + DeliverTo + 
		". \nYou can follow the arrow at the top of your screen to find " + DeliverTo + ".")
		main.taskGoal = DeliverTo
		main.taskAmmountNeeded = 1
		queue_free()
