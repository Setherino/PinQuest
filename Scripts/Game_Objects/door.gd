extends Area2D

#Level door

#written by Seth Ciancio, 12/1/19
#updated by Seth Ciancio, 12/6/19
#-added linkObjects & stuff
var link : linkObject = linkObject.new("Door") 
#This is what allows us to interact with other linkObjects

#this is the level we go to
export var nextLevel = "start"
export var triggered = false
export var sourceName = "N/A"

var doorSize = Vector2(70,70)

var onPlayer = false


var names = ["yellow","green","red","blue"]
#creating vector 2's representing the open and closed states of door one.
var closedDoor1 = Vector2(1280,506)
var openDoor1 = Vector2(1280,426)
#for the other half of the door- lol, why did I do it like this?
var closedDoor2 = Vector2(1200,506)
var openDoor2 = Vector2(1200,426)
#create rect to open/close door
var openDoor1Rect = Rect2(openDoor1,doorSize)
var closedDoor1Rect = Rect2(closedDoor1,doorSize)
#for the other half of the door
var openDoor2Rect = Rect2(openDoor2,doorSize)
var closedDoor2Rect = Rect2(closedDoor2,doorSize)

#this allows us to access the two sound nodes, and the
#two sprite nodes. There's two sprites because -I̶ ̶h̶a̶t̶e̶ ̶m̶y̶s̶e̶l̶f̶- I looOOveee sprite sheets
onready var door1 = get_node("lowerDoor")
onready var door2 = get_node("upperDoor")
onready var sound2 = get_node("doorClose")
onready var sound = get_node("doorOpen")


func _ready():
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
			door2.set_region_rect(openDoor2Rect)
		else:
			sound.play(0.5)
			door1.set_region_rect(closedDoor1Rect)
			door2.set_region_rect(closedDoor2Rect)


func _process(delta):
	link.update()


#when any key is pressed
func _input(event):
	#check if it was the one we care about, and if
	#we're touching the player
	if Input.is_action_pressed("interact") and onPlayer:
			#if so, change scenes
			Hud.startLoading(nextLevel)


#when the player touches the door
func _on_door_body_entered(body):
	if body.name != "Player":
		return
	
	
	#set onPlayer to true
	if triggered:
		if !link.enabled:
			return
	
	
	#open the door (switch door sprites to open version
	door1.set_region_rect(openDoor1Rect)
	door2.set_region_rect(openDoor2Rect)
	
	#play door sound
	onPlayer = true
	if !triggered:
		sound2.play(0.5)
	main.interact = true
	main.interactWith = "door"

#when the player walks away from the door
func _on_door_body_exited(body):
	if body.name != "Player":
		return
	
	onPlayer = false #dissable onPlayer
	main.interact = false
	main.interactWith = "nothing"
	
	if triggered:
		return
	
	
	
	#set the reigons on the sprites to closed version
	door1.set_region_rect(closedDoor1Rect)
	door2.set_region_rect(closedDoor2Rect)
	
	#play sound
	if !triggered:
		sound.play(0.5)
	
