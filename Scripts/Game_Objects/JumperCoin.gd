extends KinematicBody2D

var factor = 1
const UP = Vector2(0,-1)
var motion = Vector2()
var left = false
var distance = 1000
var timePassed = 0
var init = false

onready var coin = get_node("Coin")

#onready var col = get_node("CollisionShape2D")

func _ready():
	pass


func initialize():
	#col.disabled = true
	randomize()
	factor = rand_range(1.0,3.0)
	motion.y = -150 * factor
	if round(rand_range(1,2)) == 1:
		motion.x = 200 * factor
	else:
		motion.x = -200 * factor
	init = true

func _process(delta):
	timePassed += delta
	#if timePassed > .1:
		#col.disabled = false
	if timePassed > 5:
		queue_free()


func _physics_process(delta):
	if !init:
		initialize()

	motion.y += 10
	print(distance)
	if motion.x > 1:
		motion.x -= 5
	elif motion.x < -1:
		motion.x += 5
	motion = move_and_slide(motion,UP)