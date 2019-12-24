extends Control

var type

func _on_Button_pressed():
	if type:
		Hud.afterMessageTaskPannel()
	queue_free()