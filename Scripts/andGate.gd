extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var sprite = get_node("Sprite")

export var in_linkCode1 = 1
export var in_linkCode2 = 2

export var Xor = false

export var out_linkCode = 3

func _ready():
	#so the player can't see it
	sprite.hide()

func _process(delta):
	if main.linkCodes[in_linkCode1] && main.linkCodes[in_linkCode2]:
		if Xor:
			main.linkCodes[out_linkCode] = false
		else:
			main.linkCodes[out_linkCode] = true
	else:
		if Xor:
			main.linkCodes[out_linkCode] = true
		else:
			main.linkCodes[out_linkCode] = false