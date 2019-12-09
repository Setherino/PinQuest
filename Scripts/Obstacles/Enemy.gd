extends KinematicBody2D

export(String,"Goomba") var AIBehaviour


#these are self explainitory
export var SPEED = 250
export var GRAVITY = 10
export var JUMP = 325
export var goingLeft = false

#this is the motion variables that hold the x & y speeds of the player
var motion = Vector2( )
const UP = Vector2(0,-1)

func switchDirection():
	if goingLeft:
		goingLeft = false
	else:
		goingLeft = true


#this runs every ??frame?? and does physics and movement
func _physics_process(delta):
	motion.y += GRAVITY

	if goingLeft:
		motion.x = -SPEED
	else:
		motion.x = SPEED
	
	motion = move_and_slide(motion,UP)


func _on_Aup_body_entered(body):
	pass # Replace with function body.


func _on_Aright_body_entered(body):
	goingLeft = true


func _on_Aleft_body_entered(body):
	goingLeft = false
