extends Node2D

export var inSource1 = "in1"
export var inSource2 = "in2"
export var outSource = "out"

onready var sprite = get_node("Sprite")

var link1 : linkObject = linkObject.new("orGate1")
var link2 : linkObject = linkObject.new("orGate2")
var link3 : linkObject = linkObject.new("orGate3")


func _ready():
	link1.initialize(inSource1,false)
	link2.initialize(inSource2,false)
	link3.initialize(outSource,true)
	sprite.hide()

func _process(delta):
	link1.update()
	link2.update()
	link3.update()
	if link1.enabled || link2.enabled:
		link3.on()
	else:
		link3.off()