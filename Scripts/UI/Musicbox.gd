extends PanelContainer

var musicPlayer

var canUse = false

onready var next = get_node("HBoxContainer/Forward")
onready var prev = get_node("HBoxContainer/Back")

onready var display = get_node("HBoxContainer/Display")

func update():
	var songName : String = musicPlayer.musicStreams[musicPlayer.currentSong]
	songName = songName.replacen(".ogg","")
	songName = songName.replacen("&","and")
	display.text = songName


func _ready():
	print("I'm ready")
	if Hud.has_node("HUDElement"):
		canUse = true
		musicPlayer = Hud.get_node("HUDElement")
	
	next.set_disabled(!canUse)
	prev.set_disabled(!canUse)
	if canUse:
		update()





func _on_Back_pressed():
	if musicPlayer.currentSong > 0:
		musicPlayer.changeSong(musicPlayer.currentSong - 1)
	else:
		musicPlayer.changeSong(musicPlayer.musicStreams.size()-1)
	update()


func _on_Forward_pressed():
	if musicPlayer.currentSong < musicPlayer.musicStreams.size()-1:
		musicPlayer.changeSong(musicPlayer.currentSong + 1)
	else:
		musicPlayer.changeSong(0)
	update()

