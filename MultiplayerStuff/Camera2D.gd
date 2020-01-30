extends Camera2D

var target = null
var outside = true

func _physics_process(delta):
	if target:
		position.x = (target.position.x + main.getPlayerSpawn(get_parent().world_2d).position.x) - (get_parent().size.x/2)
		if outside:
			position.y = 944 - (get_parent().size.y/2)
		else:
			position.y = 330 - (get_parent().size.y/2)
