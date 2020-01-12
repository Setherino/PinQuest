extends KinematicBody2D

#these are self explainitory
export var SPEED = 200
export var GRAVITY = 10
export var JUMP = 350
export var FallDamageHeight = 600
export var walkRangeScale = 1
export var outside = false
export var tutorial = false

onready var sound = get_node("sfx")

#this is the motion variables that hold the x & y speeds of the player
var motion = Vector2( )
const UP = Vector2(0,-1)

#this is a node that has all the necissary character animations in it.
var chars = preload("res://Scenes/Character factory.tscn").instance()

#this is so we can use the animation node below the player
onready var vhsEffect = get_node("VHS effect/ColorRect")
onready var coin = get_node("coins")
var sprite
var anim
var dying = false

var animSprite


export(String, "Dog", "FemaleBaker", "FemaleElder","FemaleOfficeWorker","FemaleStudent","FemaleTrendy","FemaleYouth","MaleBusinessMan","OldBusinessMan","MaleCasual","MalePunk","MaleStudent","MaleStudent1","MaleTraditional","MaleTrafficCop","MaleYouth","Witch") var Appearance setget setChar

var characters = ["Dog", "FemaleBaker", "FemaleElder","FemaleOfficeWorker","FemaleStudent","FemaleTrendy","FemaleYouth","MaleBusinessMan","OldBusinessMan","MaleCasual","MalePunk","MaleStudent","MaleStudent1","MaleTraditional","MaleTrafficCop","MaleYouth","Witch"]

func setChar(character : int):
	
	animSprite = chars.getChar(character)
	
	animSprite.position.y = 13
	sprite = animSprite
	anim = animSprite
	add_child(animSprite)




func _ready():
	setChar(main.playerCharacter)
	Hud.tutorial = tutorial
	get_node("Sprite").queue_free()
	
	#if the player isn't outside, get rid of the paralax garbabe
	if !outside:
		get_node("ParallaxLayers").queue_free()
	else:
		get_node("ParallaxLayers/ParallaxBackground/background").set_visible(true)
		get_node("ParallaxLayers/ParallaxBackground2/foreground").set_visible(true)
	#connect the forcejump signal
	main.connect("forceJump",self,"makeJump")
	
	#set the animation scale
	anim.set_speed_scale(1.2)



#this makes the player jump, obviously.
func makeJump(height,force = false):
	if !force: #if it's not a forcejump...
		motion.y += height #add the height to the player velocity
	else: #if it is
		motion.y = height  #set the velocity to the height
	self.name = "notPlayer"

var prevMotion = Vector2()

#drops coins, playing the animation
func dropCoins(var ammount:int):
	main.slowcoin = -ammount
	coin.amount = ammount
	coin.restart()
	coin.emitting = true

#called when the player dies
func playerDie():
	main.movementEnabled = false
	if main.coins > 0:
		dropCoins(20)
	
	var t = Timer.new()
	t.set_wait_time(2)
	add_child(t)
	t.set_one_shot(true)
	t.connect("timeout",main,"playerDead")
	t.start()

var prevHelth = 10

#resets the VHS effect
func resetVHS(timerClear:Timer):
	sound.stop()
	timerClear.queue_free()
	if main.playerHealth >= 8:
		vhsEffect.material.set_shader_param("redX", 0)
		vhsEffect.material.set_shader_param("blueX", 0)
	elif main.playerHealth < 8 && main.playerHealth >= 2:
		vhsEffect.material.set_shader_param("redX", main.vhsEffect * 0.5)
		vhsEffect.material.set_shader_param("blueX", main.vhsEffect * 0.5)
	elif main.playerHealth < 2:
		vhsEffect.material.set_shader_param("redX", main.vhsEffect)
		vhsEffect.material.set_shader_param("blueX", main.vhsEffect)

#the positions in the sound file that it will play.
var soundStart = [0.00,2.17,4.48,6.83,8.40,10.29,12.18,13.93,15.83,17.28]

func glitchFX():
	randomize()
	var item = randi()%soundStart.size()
	sound.play(soundStart[item])



func _process(delta):
	if dying:
		randomize()
		#sprite.material.set_shader_param("multiply",rand_range(1.0,3.0))
		if !sound.is_playing():
			glitchFX()
	else:
		pass
		#sprite.material.set_shader_param("multiply",0)
	
	
	if prevHelth != main.playerHealth:
		randomize()
		prevHelth = main.playerHealth
		vhsEffect.material.set_shader_param("redX", rand_range(-2.0,2.0) * main.vhsEffect)
		vhsEffect.material.set_shader_param("blueX", rand_range(-2.0,2.0) * main.vhsEffect)
		glitchFX()
		var t = Timer.new()
		t.set_wait_time(.2)
		add_child(t)
		t.set_one_shot(true)
		#we wait for .1 seconds, and then load the next scene.
		#this gives the engine time to actually render the loading screen.
		
		var temp = Array()
		temp.append(t)
		t.connect("timeout",self,"resetVHS",temp)
		t.start()
	
	if main.playerHealth < 1 && !dying:
		dying = true
		playerDie()

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

var motionY = 0
var idleFrame = 0
func animation():
	if motion.x > 1:
		idleFrame = 2
		anim.play("East")
	elif motion.x < -1:
		idleFrame = 3
		anim.play("West")
	elif motionY > 1:
		idleFrame = 0
		anim.play("South")
	elif motionY < -1:
		idleFrame = 1
		anim.play("North")
	else:
		anim.play("Idle")
		anim.set_frame(idleFrame)
	pass


#this runs every ??frame?? and does physics and movement
#it's kinda complex because of the isometric movement.
func _physics_process(delta):
	if !main.movementEnabled:
		return
	
	main.playerX = position.x
	if is_on_ceiling() or is_on_floor():
		collisionDetect()
	prevMotion = motion
	
	#moving left
	if Input.is_action_pressed("moveLeft"):
		motion.x = -SPEED #move left
	elif Input.is_action_pressed("moveRight"):
		motion.x = SPEED #move right
	else:
		if motion.x > 1:
			motion.x -= 20
		elif motion.x < -1:
			motion.x += 20
		else:
			motion.x = 0
	if !onGround():
		motion.y += GRAVITY
	elif Input.is_action_pressed("moveDown"):
		if !main.atBottom:
			move_and_slide(Vector2(0,SPEED))
			motionY = SPEED
		motion.y = 0
	elif Input.is_action_pressed("moveUp"):
		if !main.atTop:
			move_and_slide(Vector2(0,-SPEED))
			motionY = -SPEED
		motion.y = 0
	elif Input.is_action_just_pressed("Jump") or main.forceJump:
		makeJump(-JUMP - GRAVITY + main.jumpHeight)
	else:
		motionY = 0
		motion.y = 0
		self.name = "Player"
	
	animation()
	get_node("shadowBody/camera").move_and_slide(Vector2(0,motion.y*.5),UP)
	get_node("shadowBody").move_and_slide(Vector2(0,-motion.y),UP)
	move_and_slide(motion,UP)