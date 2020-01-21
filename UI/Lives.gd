extends CanvasLayer

func update():
	get_node("Label").text = "Lives left: " + str(main.livesLeft)
	
	pass

func _ready():
	get_node("Label").text = "Lives left: " + str(main.livesLeft)
	main.connect("playerDead",self,"update")