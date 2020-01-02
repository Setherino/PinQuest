extends Area2D
#Level door

#written by Seth Ciancio, 12/1/19
#updated by Seth Ciancio, 12/6/19
#-added linkObjects & stuff
onready var link : linkObject = linkObject.new("Door") 
#This is what allows us to interact with other linkObjects

#this is the level we go to
export var nextLevel = "start"
export var triggered = false
export var sourceName = "N/A"
export var doorType = 1 setget changeTexture

var doorSize = Vector2(70,70)

var onPlayer = false

var doorTextures = Array()

#creating vector 2's representing the open and closed states of door one.
var closedDoor1 = Vector2(0,32)
var openDoor1 = Vector2(0,0)
#create rect to open/close door
var openDoor1Rect = Rect2(openDoor1,Vector2(32,32))
var closedDoor1Rect = Rect2(closedDoor1,Vector2(32,32))
#for the other half of the door

#this allows us to access the two sound nodes, and the
#two sprite nodes. There's two sprites because -I̶ ̶h̶a̶t̶e̶ ̶m̶y̶s̶e̶l̶f̶- I looOOveee sprite sheets
onready var door1 = get_node("lowerDoor")
onready var sound2 = get_node("doorClose")
onready var sound = get_node("doorOpen")

var touchingBody = PhysicsBody2D

var hasBody = false

func changeTexture(var type):
	doorType = type
	type -= 1
	openDoor1.x = type * 32
	closedDoor1.x = type * 32
	
	openDoor1Rect = Rect2(openDoor1,Vector2(32,32))
	closedDoor1Rect = Rect2(closedDoor1,Vector2(32,32))
	
	get_node("lowerDoor").set_region_rect(closedDoor1Rect)

func _ready():
	if Engine.editor_hint:
		return
	
	
	if triggered:
		link.connect("whenChanged",self,"whenLinkChanged")
		link.initialize(sourceName,false)

#when the link changes state
func whenLinkChanged():
	pass
	if triggered:
		if link.enabled:
			sound2.play(0.5)
			door1.set_region_rect(openDoor1Rect)
		else:
			sound.play(0.5)
			door1.set_region_rect(closedDoor1Rect)


func _process(delta):
	if Engine.editor_hint:
		return
	link.update()
	
	if hasBody:
		if touchingBody.name == "Player" && !onPlayer:
			print("opening door... " + touchingBody.name)
			touchingBody = NAN
			onPlayer = true
			openDoor()
			hasBody = false


#when any key is pressed
func _input(event):
	if Engine.editor_hint:
		return
	#check if it was the one we care about, and if
	#we're touching the player
	if Input.is_action_pressed("interact") and onPlayer:
			#if so, change scenes
			Hud.startLoading(nextLevel)

func openDoor():
	#set onPlayer to true
	if triggered:
		if !link.enabled:
			return
	
	
	#open the door (switch door sprites to open version
	door1.set_region_rect(openDoor1Rect)
	
	#play door sound
	onPlayer = true
	if !triggered:
		sound2.play(0.5)
	main.interact = true
	main.interactWith = "door"

#when the player touches the door
func _on_door_body_entered(body):
	if body.name == "Player" or body.name == "notPlayer":
		hasBody = true
		print("tocuhing body")
		touchingBody = body
		if body.name == "notPlayer":
			return
	else:
		return
	
	openDoor()

#when the player walks away from the door
func _on_door_body_exited(body):
	
	if body.name != "Player" && body.name != "notPlayer":
		return
	
	hasBody = false
	#play sound
	if !triggered && onPlayer:
		sound.play(0.5)
	
	onPlayer = false #dissable onPlayer
	main.interact = false
	main.interactWith = "nothing"
	
	if triggered:
		return
	
	
	
	#set the reigons on the sprites to closed version
	door1.set_region_rect(closedDoor1Rect)
	
