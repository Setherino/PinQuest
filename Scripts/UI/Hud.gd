extends Control

onready var zer = get_node("CanvasLayer/0")
onready var two = get_node("CanvasLayer/20")
onready var four = get_node("CanvasLayer/40")
onready var six = get_node("CanvasLayer/60")
onready var eight = get_node("CanvasLayer/80")
onready var ten = get_node("CanvasLayer/100")
onready var display = get_node("CanvasLayer/ActivityDisplay")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var full = Rect2(Vector2(388,45),Vector2(53,46))
var half = Rect2(Vector2(448,45),Vector2(53,46))
var empty = Rect2(Vector2(508,45),Vector2(53,46))
var prevCoins = 0
var disp = "test"

func checkZero():
	if main.playerHealth < 2:
		if main.playerHealth == 1:
			zer.set_region_rect(half)
		elif main.playerHealth == 0:
			zer.set_region_rect(empty)
	else:
		zer.set_region_rect(full)

func checkTwo():
	if main.playerHealth < 4:
		if main.playerHealth == 3:
			two.set_region_rect(half)
		elif main.playerHealth == 2:
			two.set_region_rect(empty)
	else:
		two.set_region_rect(full)

func checkFour():
	if main.playerHealth < 6:
		if main.playerHealth == 5:
			four.set_region_rect(half)
		elif main.playerHealth == 4:
			four.set_region_rect(empty)
	else:
		four.set_region_rect(full)

func checkSix():
	if main.playerHealth < 8:
		if main.playerHealth == 7:
			six.set_region_rect(half)
		elif main.playerHealth == 6:
			six.set_region_rect(empty)
	else:
		six.set_region_rect(full)

func checkEight():
	if main.playerHealth < 10:
		if main.playerHealth == 9:
			eight.set_region_rect(half)
		elif main.playerHealth == 8:
			eight.set_region_rect(empty)
	else:
		eight.set_region_rect(full)

func checkCoins():
	if main.coins != prevCoins:
		disp = str(main.futureRewards[prevCoins])
		disp.erase(0,1)
		disp.erase(disp.length()-3,3)
		display.set_text(disp)
		prevCoins = main.coins


func _process(delta):
	checkCoins()
	checkZero()
	checkTwo()
	checkFour()
	checkSix()
	checkEight()