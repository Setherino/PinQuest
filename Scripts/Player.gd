extends KinematicBody2D

#these are self explainitory
export var SPEED = 200
export var GRAVITY = 10
export var JUMP = 350
export var FallDamageHeight = 600
export var walkRangeScale = 1
export var outside = false

#this is the motion variables that hold the x & y speeds of the player
var motion = Vector2( )
const UP = Vector2(0,-1)

#this is so we can use the animation node below the player
onready var anim = get_node("Sprite/AnimationPlayer")
onready var coin = get_node("coins")
func _ready():
	#so that the player apears outside the door they entered from
	#if main.exiting:
	#	position = main.doorLevels.back()
	#	main.doorLevels.pop_back()
	Hud.clearload()
	
	anim.set_speed_scale(2)




#this makes the player jump, it's totally useless, and does not
#need to be a function.
func makeJump(height):
	moveVert(height)

var prevMotion = Vector2()

func dropCoins(var ammount:int):
	main.slowcoin = -ammount
	coin.amount = ammount
	coin.restart()
	coin.emitting = true



func collisionDetect():
	if abs(prevMotion.y) > FallDamageHeight * 2:
		dropCoins(20)
		main.playerHealth -= 2
	elif abs(prevMotion.y) > FallDamageHeight:
		dropCoins(10)
		main.playerHealth -= 1

var sliding = Vector2(0,0)

func slide(slider:Vector2,var object = self):
	
	if object == self:
		if onGround():
			return
			position.y += get_node("shadowBody/Shadow").position.y - 45 - 450
		else:
			object.position += slider
	else:
		object.position += slider



func moveVert(var ammount):
	sliding.y += ammount

func onGround():
	if get_node("shadowBody").position.y > 0:
		return false
	else:
		return true


#this runs every ??frame?? and does physics and movement
func _physics_process(delta):
	main.playerX = position.x
	if is_on_ceiling() or is_on_floor():
		collisionDetect()
	prevMotion = motion
	
	#moving left
	if Input.is_action_pressed("moveLeft"):
		motion.x = -SPEED #move left
		get_node("Sprite").set_flip_h(true)
		anim.play("Walking") #play walking animation
	elif Input.is_action_pressed("moveRight"):
		motion.x = SPEED #move right
		anim.play("Walking") #play walking animation
		get_node("Sprite").set_flip_h(false)
	else:
		if motion.x > 1:
			motion.x -= 20
		elif motion.x < -1:
			motion.x += 20
		else:
			motion.x = 0
		anim.stop(true) #stop the animation
	if !onGround():
		motion.y += GRAVITY
	elif Input.is_action_pressed("moveDown"):
		if !main.atBottom:
			move_and_slide(Vector2(0,SPEED))
		motion.y = 0
	elif Input.is_action_pressed("moveUp"):
		if !main.atTop:
			move_and_slide(Vector2(0,-SPEED))
		motion.y = 0
	elif Input.is_action_just_pressed("Jump") or main.forceJump:
		motion.y += -JUMP - GRAVITY + main.jumpHeight
		self.name = "notPlayer"
	else:
		motion.y = 0
		self.name = "Player"
	
	
	#if onGround() or main.jumpHeight > 0:
	#		if Input.is_action_just_pressed("Jump") or main.forceJump:
	#			motion.y += -JUMP - GRAVITY + main.jumpHeight
	
	get_node("shadowBody/camera").move_and_slide(Vector2(0,motion.y*.5),UP)
	get_node("shadowBody").move_and_slide(Vector2(0,-motion.y),UP)
	move_and_slide(motion,UP)