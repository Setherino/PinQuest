extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#this is a node that has all the necissary character animations in it.
var chars = preload("res://Scenes/Character factory.tscn").instance()

export(String, "Dog", "FemaleBaker", "FemaleElder","FemaleOfficeWorker","FemaleStudent","FemaleTrendy","FemaleYouth","MaleBusinessMan","OldBusinessMan","MaleCasual","MalePunk","MaleStudent","MaleStudent1","MaleTraditional","MaleTrafficCop","MaleYouth","Witch") var Appearance setget setChar

var characters = ["Dog", "FemaleBaker", "FemaleElder","FemaleOfficeWorker","FemaleStudent","FemaleTrendy","FemaleYouth","MaleBusinessMan","OldBusinessMan","MaleCasual","MalePunk","MaleStudent","MaleStudent1","MaleTraditional","MaleTrafficCop","MaleYouth","Witch"]

var animSprite

func setChar(var character):
	Appearance = character
	
	for i in characters:
		if has_node(i):
			get_node(i).queue_free()
	
	print("getting node" + str(characters.find(character)))
	if characters.has(character):
		animSprite = chars.getChar(characters.find(character))
	else:
		animSprite = chars.getChar(0)
	animSprite.position.y = 13
	add_child(animSprite)