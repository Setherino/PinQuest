extends Control
#yo this script does almost nothing lol

#when the level is loaded
func _ready():
	Hud.hideHud() #hide the HUD

#when the player clicks the "new game" button.
func _on_newGame_pressed():
	Hud.showHud() #show the hud
	#load the new level & select a character
	Hud.characterSelect("res://Scenes/Levels/Level1/Level1Outdoor.tscn")

func _on_Exit_pressed():
	get_tree().quit()


func _on_tutorial_pressed():
	Hud.showHud() #show the hud
	#load the new level & select a character
	Hud.characterSelect("res://Scenes/Levels/Debug/TestLevel.tscn")


func _on_Controls_pressed():
	Hud.showHud()
	Hud.showMessage("Controls","Use WASD or the Arrow Keys to move around\nUse [ENTER] or [Q] to open your menu once the game starts\nUse [SPACE] to jump.\nUse [E] to interact.\nUse [ESCAPE] to quit the game at any time.")


func _on_tutorial2_pressed():
		Hud.showHud() #show the hud
		#load the new level & select a character
		Hud.characterSelect("res://Scenes/Levels/Debug/TestLevel.tscn")
