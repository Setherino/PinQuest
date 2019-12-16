extends AudioStreamPlayer

export var fadeTime = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	volume_db = -40

func _process(delta):
	if volume_db < 1:
		print("inc")
		volume_db += 1 * fadeTime
	else:
		print("done")
