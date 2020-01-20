extends Camera2D

func _ready():
	if get_parent().get_parent().get_parent().outside:
		if get_parent().get_parent().get_parent().position.y != 880:
			position.y = 880 - get_parent().get_parent().get_parent().position.y
	else:
		if get_parent().get_parent().get_parent().position.y != 336:
			position.y = 336 - get_parent().get_parent().get_parent().position.y