extends PanelContainer

var message = "Good job! You've completed the level!\nPress the button bellow to continue."

var nextLevel = "res://UI/mainMenu.tscn"

onready var messageLabel = get_node("CanvasLayer/VBox/Message")

func _ready():
	messageLabel.text = Hud.nextLevelMessage
	
	pass

func _on_nextLVLbutton_pressed():
	main.levelFolder = "na"
	Hud.startLoading(Hud.nextLevelLevel)
	queue_free()
