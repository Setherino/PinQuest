extends Control
#yo this script does almost nothing lol

func _ready():
	print("hiding hud")
	Hud.hideHud()

func _on_newGame_pressed():
	Hud.showHud()
	get_tree().change_scene("res://Scenes/Levels/MainMenu.tscn")
