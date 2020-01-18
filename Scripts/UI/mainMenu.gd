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
