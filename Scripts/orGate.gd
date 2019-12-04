extends Node2D

export var in_linkCode1 = 1
export var in_linkCode2 = 2

export var out_linkCode = 3

onready var sprite = get_node("Sprite")

func _ready():
	sprite.hide( )

func _process(delta):
	if main.linkCodes[in_linkCode1] || main.linkCodes[in_linkCode2]:
		main.linkCodes[out_linkCode]
	else:
		main.linkCodes[out_linkCode]