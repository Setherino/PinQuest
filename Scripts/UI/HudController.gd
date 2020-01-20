extends Control

#these are all the various UI elements loaded by the hud...
#inventory
const inventoryUI = preload("res://UI/Inventory.tscn")
#coins and health
const HUDelement = preload("res://UI/Hud.tscn")
#dialogue
const DialogueUI = preload("res://UI/Dialogue.tscn")
#task pannel 
const taskPannel = preload("res://UI/Taskpannel.tscn")
#the pop-up message that appears sometimes
const message = preload("res://UI/Prompt.tscn")
#the loading screen
const loading = preload("res://UI/Loading.tscn")

const vhsEffect = preload("res://Misc/VHS.tscn")

const nxtLevelScreen = preload("res://UI/LevelComplete.tscn")

const timer = preload("res://UI/Timer.tscn")

#is the inventory open?
var inventoryOpen = false

func clearSaves():
	var dir = Directory.new()
	main.recursiveDelete("user://temp")


func makeTimer(var timeMins:int):
	var timeInstance = timer.instance()
	timeInstance.timeLimit = timeMins
	if has_node("Timer"):
		get_node("Timer").queue_free()
	
	add_child(timeInstance)
var  nextLevelMessage
var nextLevelLevel 

func levelDone(var message,var nextLevel):
	nextLevelLevel = nextLevel
	nextLevelMessage = message
	get_tree().change_scene("res://UI/LevelComplete.tscn")
	Hud.clearSaves()
	Hud.hideInventory()
	

#allows loading levels with loading screen
func startLoading(var nextLevel,save = true):
	var loadUI = loading.instance() #create instance of loading screen
	loadUI.level = nextLevel #set it's level variable
	loadUI.save = save
	add_child(loadUI) #add it to the screen

#remove the loading screen
func clearload():
	if has_node("Loading"): #if the loading screen exists
		get_node("Loading").queue_free() #remove it from queue (delete it)

#-------------------
#task stuff...
#-------------------

#returns the title of the task message.
func getTaskTitle():
	return "Task started: " + main.taskName

#returns the desired task message body, based on the current task
func getTaskMessage():
	var output = "To complete this task you must " #this is the same for all tasks
	
	if main.taskType == 1: #collection
		output += "collect " + str(main.taskAmmountNeeded) + " " + main.taskGoal
	if main.taskType == 2: #talk to an NPC
		output += "Talk to " + main.taskGoal
	if main.taskType == 3: #deliver
		output += "Deliver " + main.taskGoal + " to whoever needs it."
	output += ". \nFollow the arrow at the bottom of the screen to see where you need to go."
	
	return output

#displays a message
func showMessage(var title,var msgBody,var type = false,var placement = Rect2(229,140,564,251),var tutorial = false):
	var prompt = message.instance() #create an instance of the message
	prompt.get_node("Canvas/Pannel/VBox/Title").text =  title #set the correct text
	prompt.get_node("Canvas/Pannel/VBox/Body").text =  msgBody #for the body too
	prompt.type = type #set the type (usually false, true when starting a task)
	prompt.placement = placement
	prompt.tutorial = tutorial
	if tutorial:
		prompt.set_name("TutorialMessage")
	add_child(prompt) #add the mesage instance to the queue (create it)

#shows the task pannel (thing at the bottom of the screen during a task
func showTaskPannel():
	hideInventory() #hide the inventory
	#display a message.
	print(main.taskDescription)
	print(getTaskMessage())
	
	showMessage(getTaskTitle(),main.taskDescription + getTaskMessage(),true)

#this is triggered by the message node when that ^^^ is set to true
func afterMessageTaskPannel():
	#add the task pannel to the scren
	add_child(taskPannel.instance())

#hiding task pannel
func hideTaskPannel():
	if has_node("Taskpannel"):
		get_node("Taskpannel").queue_free() #delete it.

#-------------------
#inventory stuff...
#-------------------

var tutorial = false

#show the inventory
func showInventory(var size = Rect2(100,35,847,504)):
	if main.jumping:
		return
	
	hideDialogue()
	if has_node("Message"):
		get_node("Message").queue_free()
	inventoryOpen = true #the inventory is now opepn
	get_tree().paused = true #pause the game
	var Inventory = inventoryUI.instance() #create an inventory instance
	
	Inventory.inventoryPlacement = size
	add_child(Inventory) #add it to the scene
	
	if tutorial:
		showMessage("Welcome to the menu!",
		"Here you can view the progress on your quest. \n on the top of the inventory are tabs,\n why don't you click on one?",
		false,Rect2(704,65,300,476),tutorial)

func hideInventory(): #hide inventory
	
	if has_node("TutorialMessage"):
		get_node("TutorialMessage").queue_free()
	get_tree().paused = false #unpause the game
	inventoryOpen = false #inventory is no longer open
	if has_node("Inventory"):
		get_node("Inventory").queue_free() #delete it

#when any key is pressed
func _input(event):
	if Input.is_action_just_pressed("inventory"): #if it was one of the inventory buttons
		if has_node("Message"):
			return
		
		if inventoryOpen: #if the inventory is already open
			hideInventory()
		else:
			if tutorial:
				showInventory(Rect2(28,35,673,504))
			else:
				showInventory()

#-------------------
#dialogue stuff...
#-------------------

#for showing the dialouge
func showDialogue(dgSource:Array,NPCname:String,icon:Texture):
	if has_node("Dialogue"):
		return
	var Dialogue = DialogueUI.instance() #create dialogue instance
	add_child(Dialogue) #add it to the scene
	get_node("Dialogue").dialogue(dgSource,NPCname,icon) #trigger the dialogue function

#for hiding dialogue
func hideDialogue():
	if has_node("Dialogue"):
		get_node("Dialogue").queue_free()

#-------------------
#Character selection screen
#-------------------

onready var characterSelect = preload("res://UI/CharacterSelect.tscn")

func characterSelect(var nextLevel):
	if has_node("CharacterSelect"):
		return
	
	var charSel = characterSelect.instance()
	charSel.nextLevelLoad = nextLevel
	add_child(charSel)


#-------------------
#HUD stuff...
#-------------------

func hideHud():
	if has_node("HUDElement"):
		get_node("HUDElement").queue_free()

func showHud():
	if has_node("HUDElement"):
		return
	
	var HUD = HUDelement.instance()
	HUD.set_name("HUDElement")
	add_child(HUD)

func _ready():
	showHud()
	clearSaves()

#--------------
#saving stuff
#--------------


#takes a file name and returns the file's directory
func getDir(var fileName):
	var lastSlash = fileName.find_last("/")
	
	fileName.erase(lastSlash,fileName.length()-lastSlash)
	
	return fileName

func saveToTemp():
	var packedScene = PackedScene.new() #create a new packed scene resource
	packedScene.pack(get_tree().get_current_scene()) #fill it with the current scene
	
	#get it's (the current scene's) location.
	var saveLocation = str(get_tree().get_current_scene().filename)
	
	#modify it's location to inculde a "temp/" in front...
	
	
	
	if saveLocation.find("user://temp/",0) == -1: #if it doesn't have temp/
		saveLocation = saveLocation.replace("res://","user://temp/") #add it.
		#we insert it in place 6 so it looks like: "res://temp/level..."
		#                                      so,  123456temp/...
	
	#print newly modified saveLocation
	print("attempting to save in... " + saveLocation)
	
	var directory = Directory.new() #making a new directory object
	var file = File.new() #create a new file object
	
	print("looking for directory " + getDir(saveLocation))
	if directory.dir_exists(getDir(saveLocation)):
		print("Directory exists! Moving on.")
	else:
		print("Directory doesn't exist! Making directory.")
		directory.make_dir_recursive(getDir(saveLocation))
	
	
	if file.file_exists(saveLocation): #if the file already exists
		print("save file exists already, deleting...")
		
		directory.remove(saveLocation) #delete
	
	ResourceSaver.save(saveLocation,packedScene)
	
	return saveLocation