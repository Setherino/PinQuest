extends Spatial

var jumpHeight = 0
var forceJump = false

#for the four buttons
#and linkObjects lol
var sourceNames = [ ]
var linkCodes = [ ]

var coins = 0

var future : File = File.new()

var futureRewards = ["string, please"]

var playerHealth = 10

var toggle = false

func _process(delta):
	if toggle:
		if playerHealth > 0:
			playerHealth -= 1
		else:
			toggle = false
	else:
		if playerHealth <= 10:
			playerHealth += 1
		else:
			toggle = true

func _ready():
	futureRewards.clear()
	future.open("res://Rewards/Future.tres",1)
	while (!future.eof_reached()):
		if round(rand_range(1.0,4.0)) == 1:
			futureRewards.push_front(future.get_csv_line("."))
		else:
			futureRewards.push_back(future.get_csv_line("."))