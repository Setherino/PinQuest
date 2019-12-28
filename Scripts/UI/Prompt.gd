extends Control

var type

func _on_Button_pressed():
	if type: #if we need to make the task pannel (see: UI/HudController.gd)
		Hud.afterMessageTaskPannel() #make it
	queue_free()