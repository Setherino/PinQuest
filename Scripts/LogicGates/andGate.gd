extends Node2D

onready var sprite = get_node("Sprite")



export var inSource1 = "in1"
export var inSource2 = "in2"
export var outSource = "out"

var link1 : linkObject = linkObject.new("andGate1")
var link2 : linkObject = linkObject.new("andGate2")
var link3 : linkObject = linkObject.new("andGate3")

export var Xor = false
export var alwaysTriggered = false
var checked = false

func _ready():
	link1.initialize(inSource1,false)
	link2.initialize(inSource2,false)
	link3.initialize(outSource,true)
	sprite.hide()

func alwaysTriggered():
	if link1.enabled && link2.enabled:
		if Xor:
			link3.off()
		else:
			link3.on()
	else:
		if Xor:
			link3.on()
		else:
			link3.off()


func notAlwaysTriggered():
	#if it's been changed vv
	if link2.hasChanged() || link1.hasChanged():
		if link1.enabled && link2.enabled:
			if Xor:
				link3.off()
			else:
				link3.on()
		else:
			if Xor:
				link3.on()
			else:
				link3.off()


func _process(delta):
	link1.update()
	link2.update()
	link3.update()
	if alwaysTriggered:
		alwaysTriggered()
	else:
		notAlwaysTriggered()