extends Node2D
tool

export var shape : RectangleShape2D setget setShape
export var top = true


func setShape(var extents:RectangleShape2D):
	shape = extents
	get_node("Area2D/CollisionShape2D").set_shape(shape)


func _on_Area2D_body_entered(body):
	if body.name != "Player":
		return
	
	if top:
		main.atTop = true
	else:
		main.atBottom = true


func _on_Area2D_body_exited(body):
	if body.name != "Player":
		return
	
	if top:
		main.atTop = false
	else:
		main.atBottom = false