tool

extends Node2D
export var sourceTask = "none"
export var DeliverTo = "person"
export var texture : Texture setget setTexture
export var spriteScale = 1.0 setget setScale

func setScale(var scal):
	spriteScale = scal
	get_node("Sprite").scale = Vector2(scal,scal)


func setTexture(var text : Texture):
	get_node("Sprite").texture = text
	texture = text

func timeout():
	get_node("Sprite").visible = false
	pass

func _ready():
	if Engine.editor_hint:
		return
	main.connect("taskTimeout",self,"timeout")
	if main.taskName == sourceTask:
		main.taskTargetX = position.x
		get_node("Sprite").visible = true
	else:
		get_node("Sprite").visible = false
	
	main.connect("taskStarted",self,"_taskStart")
	
	get_node("Sprite").texture = texture
	
	_taskStart()

func _taskStart():
	if Engine.editor_hint:
		return
	
	if main.taskName == sourceTask:
		main.taskTargetX = position.x
		get_node("Sprite").visible = true

func _on_Area2D_body_entered(body):
	if body.name != "Player":
		return
	
	if main.taskName == sourceTask:
		Hud.showMessage("Item Collected","You've collected the " + main.taskGoal + 
		". Now you have to deliver it too " + DeliverTo + 
		". \nYou can follow the arrow at the bottom of your screen to find " + DeliverTo + ".")
		main.taskGoal = DeliverTo
		main.taskAmmountNeeded = 1
		main.updateTaskTarget()
		get_node("Sprite").visible = false
