tool
extends KinematicBody2D

export(String, "Debug/", "LevelOne/", "LevelTwo/","LevelThree/","LevelFour/") var Folder
#this is the NPC's name, obviously
export var npcName = "john"
#this is the file where all the dialogue is stored
export var dialogueSourceName = "Template"


export(String, "Dog", "FemaleBaker", "FemaleElder","FemaleOfficeWorker","FemaleStudent","FemaleTrendy","FemaleYouth","MaleBusinessMan","OldBusinessMan","MaleCasual","MalePunk","MaleStudent","MaleStudent1","MaleTraditional","MaleTrafficCop","MaleYouth","Witch") var Appearance setget setChar

var dialogueSource = "res://NPC Dialogue/"

var characters = ["Dog", "FemaleBaker", "FemaleElder","FemaleOfficeWorker","FemaleStudent","FemaleTrendy","FemaleYouth","MaleBusinessMan","OldBusinessMan","MaleCasual","MalePunk","MaleStudent","MaleStudent1","MaleTraditional","MaleTrafficCop","MaleYouth","Witch"]

export var dialogueIcon : Texture


#This variable decides whether the NPC will load the dialogue into
#memory when the level starts, or when the player talks to the NPC
var saveRam = true

#this is a node that has all the necissary character animations in it.
var chars = preload("res://Scenes/Character factory.tscn").instance()

#represents whether the player is currently touching the NPC
var onNPC = false

var dgSource : File = File.new()

#whether or not the NPC will walk around randomly
export var wander = false

#these are the arrays which store the NPC's dialogue, there are two, because each NPC
#has two sets of dialogue, one which plays normally, and one which plays while it's task is 
#happening
var defaultDialogue = [ ]
var taskDialogue = [ ]

var animSprite

func setChar(var character):
	Appearance = character
	
	for i in characters:
		if has_node(i):
			get_node(i).queue_free()
	
	print("getting node" + str(characters.find(character)))
	if characters.has(character):
		animSprite = chars.getChar(characters.find(character))
	else:
		animSprite = chars.getChar(0)
	
	add_child(animSprite)

#this fills the first of the two arrays described above with information from the file.
func fillDefault():
	if dgSource.is_open():
		dgSource.close()
# warning-ignore:return_value_discarded
	dgSource.open(dialogueSource,1)

	var line = dgSource.get_line() #creating a line variable to store the text
	while line != "-TASK DIALOGUE:" && !dgSource.eof_reached(): #until you get to the task header...
		print("line " + line)
		line = dgSource.get_line() #get a line
		if line != "-TASK DIALOGUE:": #make sure it's not the task header
			defaultDialogue.push_back(line) #if it's not, then add it to the array

#this fills the second of the two arrays described above
func fillTaskDG():
	if dgSource.is_open():
		dgSource.close()
# warning-ignore:return_value_discarded
	dgSource.open(dialogueSource,1)
	
	var line = "" #creating a line variable to store the text
	
	while line != "-TASK DIALOGUE:":
		line = dgSource.get_line()
	
	while line != "-END." && !dgSource.eof_reached(): #until you get to the end header
		line = dgSource.get_line() #get the next line of text
		if line != "-END.": #make sure it's not the end header
			taskDialogue.push_back(line) #and add it to the array




func _ready():
	if Engine.editor_hint:
		return
	
	main.connect("taskStarted",self,"_taskStart")
	dialogueSource = dialogueSource + Folder + dialogueSourceName + ".dial"
	
	if !dgSource.file_exists(dialogueSource): #if the file doesn't exist
		print("ERROR!! " + npcName + " HAS AN INVALID DIALOGUE SOURCE")
		print(dialogueSource + " SOURCE DOES NOT EXIST!")#print an error
		queue_free() #and delete yourself
	if !saveRam:
		fillDefault()
		fillTaskDG()


func talkTo():
	main.taskAmmountCollected = 1
	Hud.hideTaskPannel()
	Hud.showDialogue(taskDialogue,npcName,dialogueIcon)

func deliver():
	Hud.hideTaskPannel()
	main.taskAmmountCollected = 2
	Hud.showDialogue(taskDialogue,npcName,dialogueIcon)

# warning-ignore:unused_argument
func _input(event):
	if Input.is_action_just_pressed("interact") && onNPC:
		if saveRam && defaultDialogue.size() == 0:
			fillDefault()
			fillTaskDG()
		if main.taskGoal == npcName && main.taskType != 1:
			if main.taskType == 2:
				talkTo()
			elif main.taskType == 3:
				deliver()
		else:
			print("showig")
			Hud.showDialogue(defaultDialogue,npcName,dialogueIcon)

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		onNPC = true
		main.interact = true
		main.interactWith = npcName



#when you leave the npc's hitbox
func _on_Area2D_body_exited(body):
	if body.name == "Player":
		main.interact = false
		main.interactWith = "nothing"
		onNPC = false
		if saveRam:
			defaultDialogue.clear()
			taskDialogue.clear()


func _process(delta):
	if main.taskGoal == npcName:
		main.taskTargetX = position.x


func makeTimer(trigger : String):
	var t = Timer.new()
	t.set_wait_time(rand_range(0.0,3.0))
	t.set_one_shot(true)
	t.connect("timeout",self,trigger)
	add_child(t)
	t.start()

var motion = Vector2()

func stop():
	animSprite.play("Idle")
	motion = Vector2(0,0)

func go():
	stopped = false
var stopped = false
var idleFrame = 0
func _physics_process(delta):
	if Engine.editor_hint:
		return
	
	if wander && motion == Vector2(0,0) && !onNPC && !stopped:
		randomize()
		var direction = round(rand_range(1.0,5.0))
		if direction == 2:
			idleFrame = 2
			animSprite.play("East")
			motion = Vector2(100,0)
			makeTimer("stop")
		elif direction == 3:
			idleFrame = 3
			animSprite.play("West")
			motion = Vector2(-100,0)
			makeTimer("stop")
		else:
			stopped = true
			makeTimer("go")
			animSprite.play("Idle")
			animSprite.set_frame(idleFrame)
			idleFrame = 0
	elif onNPC:
		stop()
	move_and_slide(motion)