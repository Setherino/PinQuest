extends Node2D

#linked indicator

#Written by Seth Ciancio 12/6/19

var linkCode = -1;
export var sourceName = "N/A"
var codeFound = false
var prevName = "N/A"

onready var sprite = get_node("Sprite")

var link : linkObject = linkObject.new("Indicator")

var onRect = Rect2(0,0,291,291)
var offRect = Rect2(291,0,291,291)

func _ready( ):
	link.initialize(sourceName,false)



func setColor():
	if link.enabled:
		sprite.set_region_rect(onRect)
	else:
		sprite.set_region_rect(offRect)


func _process(delta):
	link.update()
	if (link.initialized):
		setColor()


