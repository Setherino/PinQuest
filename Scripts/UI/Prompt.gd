extends Control

var type

var tutorial = false

var placement = Rect2(229,140,564,251)

onready var parentTab = get_parent().get_node("Inventory/CanvasLayer/TabContainer")

onready var textBody = get_node("Canvas/Pannel/VBox/Body")

func _ready():
	get_node("Canvas/Pannel").set_position(placement.position)
	get_node("Canvas/Pannel").set_size(placement.size)

func _process(delta):
	var currentTab
	
	if get_parent().has_node("Inventory"):
		currentTab = parentTab.get_current_tab()
	else:
		currentTab = 3
	
	if tutorial:
		match currentTab:
			0:
				textBody.text = "Welcome to the quest menu.\nHere you can view your\n progress on your currnet quest.\nFor this quest, you need\nTo get " + str(main.questCoins) + " coins, and you need\nTo complete " + str(main.questTasks) + " tasks.\nOnce you've completed them, click 'Complete Quest'\nFor now, click on one of the other \ntabs at the top of the screen." 
			1:
				textBody.text = "Welcome to the task menu.\nHere you can see your current\nTask, as well as all the tasks you've\nYet to complete"
			2:
				textBody.text = "three"
			3:
				textBody.text = "uh oh... somethings wrong with the inventory... 0 . 0"

func _on_Button_pressed():
	if type: #if we need to make the task pannel (see: UI/HudController.gd)
		Hud.afterMessageTaskPannel() #make it
	queue_free()