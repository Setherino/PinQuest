extends Control

#these are all the varios UI elements loaded by the hud...
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

#is the inventory open?
var inventoryOpen = false

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
		if inventoryOpen: #if the inventory is already open
			hideInventory()
		else:
			if tutorial:
				showInventory(Rect2(28,35,673,504))
			else:
				showInventory()

#28,35 - 673,500
#-------------------
#dialogue stuff...
#-------------------

#for showing the dialouge
func showDialogue(dgSource:Array,NPCname:String,icon:Texture):
	var Dialogue = DialogueUI.instance() #create dialogue instance
	add_child(Dialogue) #add it to the scene
	get_node("Dialogue").dialogue(dgSource,NPCname,icon) #trigger the dialogue function

#for hiding dialogue
func hideDialogue():
	get_node("Dialogue").queue_free()

#-------------------
#HUD stuff...
#-------------------

func hideHud():
	if has_node("Control"):
		get_node("Control").queue_free()

func showHud():
	var HUD = HUDelement.instance()
	add_child(HUD)

func _ready():
	showHud()