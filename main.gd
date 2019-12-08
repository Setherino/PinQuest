extends Spatial

var jumpHeight = 0
var forceJump = false

#for the four buttons
#and linkObjects lol
var sourceNames = [ ]
var linkCodes = [ ]

var coins = 0

var future : File = File.new()

var futureRewards = [ ]



func _ready():
	futureRewards.clear()
	future.open("res://Rewards/Future.tres",1)
	while (!future.eof_reached()):
		if round(rand_range(1.0,4.0)) == 1:
			futureRewards.push_front(future.get_csv_line("."))
		else:
			futureRewards.push_back(future.get_csv_line("."))