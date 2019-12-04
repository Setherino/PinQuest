extends Object

class_name Costume

func _init(posX:int,posY:int,size:int):
	var position = Vector2(posX,posY)
	var bigness = Vector2(size,size)
	var costume = Rect2(position,bigness)