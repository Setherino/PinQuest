extends Node2D

export var startWith = false
export var deleteAfter = true
export var sourceName = "n/a"
var link : linkObject = linkObject.new("Startwith") 

onready var sprite = get_node("Sprite")

func _ready():
	link.initialize(sourceName,false)
	sprite.hide()

func _process(delta):
	link.update()
	
	if link.initialized:
		link.setto(startWith)
		if deleteAfter:
			queue_free()