extends Node2D


const coins = preload("res://Scenes/Objects/Collectables/JumperCoin.tscn")


export var coinsInBox = 10
var going = false
var array = ["name","name2"]

func _process(delta):
	if coinsInBox > 0 && going:
		coinsInBox -= 1
		spawnCoin()


func spawnCoin():
	var coin = coins.instance()
	coin.position = Vector2(0,0)
	get_node("Container").add_child(coin)


func _on_top_body_entered(body):
	if body.name == "Player":
		going = true