extends Area2D
#Level door

#written by Seth Ciancio, 12/1/19
#updated by Seth Ciancio, 12/6/19
#-added linkObjects & stuff
onready var link : linkObject = linkObject.new("Door") 
onready var collect : collectable = collectable.new()
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

func changeVolume():
	sound.set_volume_db(main.SFXVolume)
	sound2.set_volume_db(main.SFXVolume)

func interacted():
	if !collect.playerBody:
		return
	if Input.is_action_just_pressed("interact_" + str(collect.playerBody.playerID)):
		return true
	return false


func _ready():
	collect.connect("entered",self,"entered")
	collect.connect("exited",self,"exited")
	
	if Engine.editor_hint:
		return
	
	changeVolume()
	main.connect("volumeChange",self,"changeVolume")
	
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
	
	if interacted() && collect.playerOn:
			#if so, change scenes
			Hud.startLoading(nextLevel,true,collect.playerBody)
			
	if hasBody:
		if touchingBody.name == "Player" && !onPlayer:
			print("opening door... " + touchingBody.name)
			touchingBody = NAN
			onPlayer = true
			openDoor()
			hasBody = false


#when any key is pressed
func _input(event):
	print("input event")
	

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
func entered():
	openDoor()

func _on_door_body_entered(body):
	collect.entered(body)


func exited():
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



func _on_door_body_exited(body):
	collect.exited(body)
