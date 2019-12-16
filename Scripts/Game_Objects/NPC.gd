tool
extends KinematicBody2D

export(String, "Debug/", "LevelOne/", "LevelTwo/","LevelThree/","LevelFour/") var Folder
#this is the NPC's name, obviously
export var npcName = "john"
#this is the file where all the dialogue is stored
export var dialogueSourceName = "Template"

var dialogueSource = "res://NPC Dialogue/"

#this is the texture of the NPC
export var npcTexture : Texture
export var dialogueIcon : Texture
#This variable decides whether the NPC will load the dialogue into
#memory when the level starts, or when the player talks to the NPC
export var saveRam = true

onready var sprite = get_node("Sprite")

#represents whether the player is currently touching the NPC
var onNPC = false

var dgSource : File = File.new()

#these are the arrays which store the NPC's dialogue, there are two, because each NPC
#has two sets of dialogue, one which plays normally, and one which plays while it's task is 
#happening
var defaultDialogue = [ ]
var taskDialogue = [ ]


#this fills the first of the two arrays described above with information from the file.
func fillDefault():
	if dgSource.is_open():
		dgSource.close()
# warning-ignore:return_value_discarded
	dgSource.open(dialogueSource,1)

	var line = dgSource.get_line() #creating a line variable to store the text
	while line != "-TASK DIALOGUE:" && !dgSource.eof_reached(): #until you get to the task header...
		line = dgSource.get_line() #get a line
		print(line)
		if line != "-TASK DIALOGUE:": #make sure it's not the task header
			defaultDialogue.push_back(line) #if it's not, then add it to the array

#this fills the second of the two arrays described above
func fillTaskDG():
	if dgSource.is_open():
		dgSource.close()
# warning-ignore:return_value_discarded
	dgSource.open(dialogueSource,1)
	
	var line = "" #creating a line variable to store the text
	while line != "-END." && !dgSource.eof_reached(): #until you get to the end header
		line = dgSource.get_line() #get the next line of text
		if line != "-END.": #make sure it's not the end header
			taskDialogue.push_back(line) #and add it to the array

func _process(delta):
	if Engine.editor_hint:
		sprite.set_texture(npcTexture)

func _ready():
	sprite.set_texture(npcTexture)
	if Engine.editor_hint:
		return
	
	dialogueSource = dialogueSource + Folder + dialogueSourceName + ".dial"
	
	if !dgSource.file_exists(dialogueSource): #if the file doesn't exist
		print("ERROR!! " + npcName + " HAS AN INVALID DIALOGUE SOURCE")
		print(dialogueSource + " SOURCE DOES NOT EXIST!")#print an error
		queue_free() #and delete yourself
	print("saveram check")
	if !saveRam:
		fillDefault()
		fillTaskDG()
	print("did nothing")
	

# warning-ignore:unused_argument
func _input(event):
	if Input.is_action_just_pressed("interact") && onNPC:
		if saveRam && defaultDialogue.size() == 0:
			fillDefault()
			fillTaskDG()
		Hud.showDialogue(defaultDialogue,npcName,dialogueIcon)

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		onNPC = true
		main.interact = true
		main.interactWith = npcName


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		main.interact = false
		main.interactWith = "nothing"
		onNPC = false
		if saveRam:
			defaultDialogue.clear()
			taskDialogue.clear()

