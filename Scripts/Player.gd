extends KinematicBody2D

#these are self explainitory
export var SPEED = 250
export var GRAVITY = 10
export var JUMP = 325


#this is the motion variables that hold the x & y speeds of the player
var motion = Vector2( )
const UP = Vector2(0,-1)

#this is so we can use the animation node below the player
onready var anim = get_node("Sprite/AnimationPlayer")

func _ready():
	anim.set_speed_scale(2)



#this makes the player jump, it's totally useless, and does not
#need to be a function.
func makeJump(height):
	motion.y = height
	

#this runs every ??frame?? and does physics and movement
func _physics_process(delta):
	motion.y += GRAVITY
	
	#moving left
	if Input.is_action_pressed("moveLeft"):
		motion.x = -SPEED #move left
		anim.play("Walking") #play walking animation
	elif Input.is_action_pressed("moveRight"):
		motion.x = SPEED #move right
		anim.play("Walking") #play walking animation
	else:
		if motion.x > 1:
			motion.x -= 20
		elif motion.x < -1:
			motion.x += 20
		else:
			motion.x = 0
		anim.stop(true) #stop the animation
	
	if is_on_floor()  or main.jumpHeight > 0:
			if Input.is_action_pressed("Jump") or main.forceJump:
				makeJump(-JUMP - GRAVITY + main.jumpHeight)
		
		
	motion = move_and_slide(motion,UP)