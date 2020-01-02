extends Control

var type

var placement = Rect2(229,140,564,251)

func _ready():
	get_node("Canvas/Pannel").set_position(placement.position)
	get_node("Canvas/Pannel").set_size(placement.size)


func _on_Button_pressed():
	if type: #if we need to make the task pannel (see: UI/HudController.gd)
		Hud.afterMessageTaskPannel() #make it
	queue_free()