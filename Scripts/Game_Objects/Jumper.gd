extends Area2D

#Written by Seth Ciancio

#Written on: 12/1/19

#This program is super great, it's the script for the jumper
#It works in conjunction with the Player script, communicating with variables
#it uses the main.gd script to send variables to the player.gd script
#it's probably the longest and most complex script as of 11:43 PM december first.
#The door script is pretty crazy too, though.

#so we can play sound effects
onready var sound = get_node("sfx")

#so we can edit the sprite (change from out-springed to in-springed)
onready var sprite = get_node("Sprite")


#has the player stepped on the pad?
var isEntered = false
#have they jumped yet?
var didJump = false
#has the player stepped off without jumping?
var primed = false
#size of sprite
var size = Vector2(70,70)

#positions of sprites in spritesheet

#in-sprung
var pos1 = Vector2(960,820)
#out-sprung
var pos2 = Vector2(1040,820)



#represents the location & position of the in-sprung pad in the spritesheet
var unBounce = Rect2(pos1,size)
#represents the location & position of the out-sprung pad in the spritesheet
var Bounce = Rect2(pos2,size)

#does it jump for the player?
export var forceJump = false
#do things other than the player trigger the bouncing.
#honestly never set this to false, it doesn't work like you think it would.
export var onlyBouncePlayer = true
#will it automatically spring up after the player walks off of it (without jumping)
#or will it stay in-sprung, going off when they next step on the pad
export var isPrimable = false
#self explainatory
export var JumpHeight = 300

#when the level begins
func _ready():
	#don't make it less than zero, dummy
	assert(JumpHeight > 0)
	
	#force jump bypasses the checks for player jumps
	main.forceJump = false
	
	#so players can tell which pads are force-jump pads
	if forceJump:
		#set sprite to in-sprung version
		sprite.set_region_rect(unBounce)
	else:
		#set sprite to out-sprung version
		sprite.set_region_rect(Bounce)

#if a key is pressed
func _input(event):
	#if they're on the pad, pressing space, and forceJump is disabled
	if Input.is_action_pressed("Jump") and isEntered and !forceJump:
		#they jumped
		didJump = true
		#they also left the pad
		isEntered = false
		#play sound
		sound.play(0.0)
		#switch sprite to out-sprung
		sprite.set_region_rect(Bounce)
		#jumpHeight modifier in the main script
		main.jumpHeight = -JumpHeight

var timer = Timer.new()
#when something enters the pad
func _on_Jumper_body_entered(body):
	#they've entered the pad, but have yet to jump
	didJump = false
	#if it's the player, or if you set it to bounce without players. Also, never
	#get triggered by "jumperStatic" (the jump pad's own colision box.
	if body.name == "Player" or !onlyBouncePlayer and body.name != "jumperStatic":
		#change sprite
		sprite.set_region_rect(unBounce)
		#if we want to force the player to jump
		if forceJump or primed:
			sprite.set_region_rect(Bounce)
			#unprime (because it just fired)
			primed = false
			#play sound and do the jump stuff
			sound.play(0.0)
			main.forceJump = true
			main.jumpHeight = -JumpHeight
			#it has been entered
			
			#this is all just to wait for .1 seconds.
			var t = Timer.new()
			t.set_wait_time(.1)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			
			
			sprite.set_region_rect(unBounce)
		else:
			#it has been entered
			isEntered = true


#when the player leaves
func _on_Jumper_body_exited(body):
	#dissable the global force jump variable
	main.forceJump = false
	#they left
	isEntered = false
	#reset jumpHieght modifier to zero (so they jump normal now)
	main.jumpHeight = 0
	
	#if they leave without jumping
	if !didJump:
		#and you set it to be primable
		if isPrimable:
			#then prime it!
			primed = true
		else:
			sprite.set_region_rect(Bounce)
			
			
			sound.play(0.0)
	