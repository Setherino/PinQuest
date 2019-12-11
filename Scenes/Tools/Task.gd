tool
extends Node2D


export var taskName = "name"
export(String,"Collection","SpeakTo","Delivery") var type
export var timeLimit = 60
export var speak_give_To = "nobody"
export var collectNumber = 0

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
