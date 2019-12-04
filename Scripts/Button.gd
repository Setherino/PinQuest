extends Area2D

export var momentary = false
export var type = "yellow"
export var linkCode = 0
var myNumber = 1
var onButton = false
var outfit

#these are the X & Y positions of the buttons in the spritesheet
#it goes, y-g-r-b, then their respective active versions

var posArrayX = [1040,1120,1040,1120,1040,1120,1040,1120] 
var posArrayY = [266,266,346,346,426,426,506,506]
var names = ["yellow","green","red","blue"]

onready var sprite = get_node("Sprite")
onready var sfx = get_node("sound")

var size = Vector2(70,70)
var onRectangle = Rect2( )
var offRectangle = Rect2( )

func _ready():
	assert(linkCode < main.maxLinks)
	#does the given name make sense?
	assert(names.has(type))
	#if so, find that names "code" so to speak
	outfit = names.find(type)
	
	myNumber = linkCode
	
	#add four, because that's how many variants there are, so it goes to the off ones
	var posOff = Vector2(posArrayX[outfit+4],posArrayY[outfit+4])
	var pos = Vector2(posArrayX[outfit],posArrayY[outfit])
	
	onRectangle = Rect2(pos,size)
	offRectangle = Rect2(posOff,size)


func _process(delta):
	if !main.linkCodes[myNumber]:
		sprite.set_region_rect(onRectangle)
	else:
		sprite.set_region_rect(offRectangle)



func _input(event):
	if Input.is_action_pressed("interact") && onButton:
		if !momentary:
			if main.linkCodes[myNumber]:
				main.linkCodes[myNumber] = false
				sfx.play(0)
				
			else:
				main.linkCodes[myNumber] = true
				sfx.play(0)
		else:
			main.linkCodes[myNumber] = true
			sfx.play(0)


func _on_Button_body_entered(body):
	if momentary:
		main.linkCodes[myNumber] = true
		sfx.play(0)
	else:
		onButton = true


func _on_Button_body_exited(body):
	if momentary:
		main.linkCodes[myNumber] = false
		sfx.play(0)
	else:
		onButton = false
	
