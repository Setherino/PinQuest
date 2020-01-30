tool
extends KinematicBody2D
var Folder
#this is the NPC's name, obviously
var npcName = "john"
#this is the file where all the dialogue is stored
var dialogueSourceName = "Template"

var Appearance

var dialogueSource = "res://NPC Dialogue/"

var characters = ["Dog", "FemaleBaker", "FemaleElder","FemaleOfficeWorker","FemaleStudent","FemaleTrendy","FemaleYouth","MaleBusinessMan","OldBusinessMan","MaleCasual","MalePunk","MaleStudent","MaleStudent1","MaleTraditional","MaleTrafficCop","MaleYouth","Witch"]

var dialogueIcon : Texture

var changeDirection = false

var wanderArea

#This variable decides whether the NPC will load the dialogue into
#memory when the level starts, or when the player talks to the NPC
var saveRam = true

#this is a node that has all the necissary character animations in it.
var chars = preload("res://Scenes/Character factory.tscn").instance()

#represents whether the player is currently touching the NPC
var onNPC = false

var dgSource : File = File.new()

var wander

var stillness
#these are the arrays which store the NPC's dialogue, there are two, because each NPC
#has two sets of dialogue, one which plays normally, and one which plays while it's task is 
#happening
var defaultDialogue = [ ]
var taskDialogue = [ ]

var animSprite

var useTaskTitle = false
func setChar(var character):
	Appearance = character
	
	
	for i in get_node("Container").get_children():
		i.queue_free()
	
	if characters.has(character):
		animSprite = chars.getChar(characters.find(character))
	else:
		animSprite = chars.getChar(0)
	
	if character == "NONE":
		wander = false
		animSprite.set_visible(false)
	
	get_node("Container").add_child(animSprite)

#this fills the first of the two arrays described above with information from the file.
func fillDefault():
	if dgSource.is_open():
		dgSource.close()
# warning-ignore:return_value_discarded
	dgSource.open(dialogueSource,1)

	var line = dgSource.get_line() #creating a line variable to store the text
	while line != "-TASK DIALOGUE:" && !dgSource.eof_reached(): #until you get to the task header...
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

var speed

var taskName

func _ready():
	if Engine.editor_hint:
		return
	setChar(get_parent().Appearance)
	print("I EXIST!!")
	
	taskName = get_parent().taskName
	useTaskTitle = get_parent().useTaskName
	Folder = get_parent().Folder
	npcName = get_parent().npcName
	dialogueSourceName = get_parent().dialogueSourceName
	dialogueIcon = get_parent().dialogueIcon
	wander = get_parent().wander
	print(Appearance)
	stillness = get_parent().stillness
	wanderArea = get_parent().wanderArea
	speed = get_parent().speed
	
	animSprite.set_speed_scale(1.0 + (speed * 0.001))
	
	set_name(npcName) #Used by NPC wall
	
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
		if ((main.taskName == taskName && useTaskTitle) or (main.taskGoal == npcName && !useTaskTitle)) && main.taskType != 1:
			if main.taskType == 2:
				talkTo()
			elif main.taskType == 3:
				deliver()
		else:
			Hud.showDialogue(defaultDialogue,npcName,dialogueIcon)

func _on_Area2D_body_entered(body):
	if main.players.has(body):
		onNPC = true
		main.interact = true
		main.interactWith = npcName



#when you leave the npc's hitbox
func _on_Area2D_body_exited(body):
	if main.players.has(body):
		main.interact = false
		main.interactWith = "nothing"
		onNPC = false
		if saveRam:
			defaultDialogue.clear()
			taskDialogue.clear()


func _process(delta):
	if ((main.taskName == taskName && useTaskTitle) or (main.taskGoal == npcName && !useTaskTitle)):
		main.taskTargetX = get_parent().position.x + position.x

var motion = Vector2(0,0)
var goalPos = Vector2(0,0)
var animFrame = 0
var stopped = false

func go():
	stopped = false

func deleteTimer(var timer : Object):
	timer.queue_free()


func makeTimer(var instruction,var time = 2.0):
	var t = Timer.new()
	t.set_wait_time(time)
	t.set_one_shot(true)
	t.connect("timeout",self,instruction)
	var param = [t]
	t.connect("timeout",self,"deleteTimer",param)
	add_child(t)
	t.start()

func getMotion():
	if goalPos.x > position.x:
		motion.x = speed
		animSprite.play("East")
		animFrame = 2
	elif goalPos.x < position.x:
		motion.x = -speed
		animSprite.play("West")
		animFrame = 3
	elif goalPos.y > position.y:
		motion.y = speed
		animSprite.play("South")
		animFrame = 0
	elif goalPos.y < position.y:
		motion.y = -speed
		animSprite.play("North")
		animFrame = 1


func _physics_process(delta):
	if Engine.editor_hint or !wander:
		return
	
	if goalPos == Vector2(0,0) && !stopped:
		randomize()
		var direction = randi()%int(stillness+2)
		if direction == 0: #left/right
			if wanderArea.x <= 2:
				goalPos = Vector2(position.x,round(rand_range(wanderArea.y*-1,wanderArea.y)))
			goalPos = Vector2(round(rand_range(wanderArea.x*-1,wanderArea.x)),position.y)
		elif direction == 1: #up/down
			if wanderArea.y <= 2:
				goalPos = Vector2(round(rand_range(wanderArea.x*-1,wanderArea.x)),position.y)
			goalPos = Vector2(position.x,round(rand_range(wanderArea.y*-1,wanderArea.y)))
		else:
			goalPos = Vector2(0,0)
	
	
	
	if goalPos == Vector2(0,0) or onNPC:
		motion = Vector2(0,0)
		animSprite.play("Idle")
		animSprite.set_frame(animFrame)
		stopped = true
		makeTimer("go")
	else:
		getMotion()
	
	if (abs(goalPos.x - position.x) > 10):
		move_and_slide(Vector2(motion.x,0))
	elif (abs(goalPos.y - position.y) > 10):
		move_and_slide(Vector2(0,motion.y))
	else:
		goalPos = Vector2(0,0)
