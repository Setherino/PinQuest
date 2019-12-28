extends Control
#yo this script does almost nothing lol

#when the level is loaded
func _ready():
	Hud.hideHud() #hide the HUD

#when the player clicks the "new game" button.
func _on_newGame_pressed():
	Hud.showHud() #show the hud
	#load the new level
	get_tree().change_scene("res://Scenes/Levels/MainMenu.tscn")

func _on_Exit_pressed():
	get_tree().quit()
