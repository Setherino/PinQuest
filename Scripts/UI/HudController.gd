extends Control


const inventoryUI = preload("res://UI/Inventory.tscn")
const HUDelement = preload("res://UI/Hud.tscn")
const DialogueUI = preload("res://UI/Dialogue.tscn")
const taskPannel = preload("res://UI/Taskpannel.tscn")
const message = preload("res://UI/Prompt.tscn")
var inventoryOpen = false

func getTaskTitle():
	return "Task started: " + main.taskName

func getTaskMessage():
	var output = "To complete this task you must "
	
	if main.taskType == 1: #collection
		output += "collect " + str(main.taskAmmountNeeded) + " " + main.taskGoal
	if main.taskType == 2: #talk to an NPC
		output += "Talk to " + main.taskGoal
	if main.taskType == 3: #deliver
		pass
	output += ". \nFollow the arrow at the top of the screen to see where you need to go."
	
	return output


func showMessage(var title,var msgBody,var type = false):
	var prompt = message.instance()
	prompt.get_node("Canvas/Pannel/VBox/Title").text =  title
	prompt.get_node("Canvas/Pannel/VBox/Body").text =  msgBody
	prompt.type = type
	add_child(prompt)


func showTaskPannel():
	hideInventory()
	showMessage(getTaskTitle(),getTaskMessage(),true)

func afterMessageTaskPannel():
	add_child(taskPannel.instance())

func hideTaskPannel():
	get_node("Taskpannel").queue_free()


func showInventory():
	inventoryOpen = true
	var Inventory = inventoryUI.instance() #create an inventory instance
	add_child(Inventory) #add it to the scene

func hideInventory():
	inventoryOpen = false
	get_node("Inventory").queue_free() #delete it

#inventory stuff...
#when any key is pressed
func _input(event):
	if Input.is_action_just_pressed("inventory"): #if it was one of the inventory buttons
		if inventoryOpen: #if the inventory is already open
			hideInventory()
		else:
			showInventory()

#for showing the dialouge
func showDialogue(dgSource:Array,NPCname:String,icon:Texture):
	var Dialogue = DialogueUI.instance()
	add_child(Dialogue)
	get_node("Dialogue").dialogue(dgSource,NPCname,icon)

#for hiding dialogue
func hideDialogue():
	get_node("Dialogue").queue_free()

func hideHud():
	get_node("Control").queue_free()

func showHud():
	var HUD = HUDelement.instance()
	add_child(HUD)

func _ready():
	showHud()
	pass