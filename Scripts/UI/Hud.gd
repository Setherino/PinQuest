#Definitely not written by Seth Ciancio, oh my god, yikes.
#actually as of 12/21/19 it's not really that bad anymore, so.

extends Control

onready var zer = get_node("CanvasLayer/0")
onready var two = get_node("CanvasLayer/20")
onready var four = get_node("CanvasLayer/40")
onready var six = get_node("CanvasLayer/60")
onready var eight = get_node("CanvasLayer/80")
#onready var ten = get_node("CanvasLayer/100")
onready var health = get_node("CanvasLayer/Health")
onready var coins = get_node("CanvasLayer/coinLabel")
#onready var display = get_node("CanvasLayer/ActivityDisplay")

onready var sfx = get_node("CanvasLayer/coinLabel/sfx")

onready var music = get_node("music")

#Health stuff...

var full = Rect2(Vector2(388,45),Vector2(53,46))#area in sprite-sheet for full heart
var half = Rect2(Vector2(448,45),Vector2(53,46))#for half heart
var empty = Rect2(Vector2(508,45),Vector2(53,46)) #and for empty heart (like mine :( lol jk i love myself :)
var prevCoins = 0
var prevHealth = 0
var fading = false
var coinFading = false

var musicStreams : Array

var musicStream

func changeVolume():
	sfx.set_volume_db(main.SFXVolume - 10)


func _ready():
	main.connect("volumeChange",self,"changeVolume")
	if musicStreams.size() > 1:
		randomize()
		musicStreams.shuffle()
		print(musicStreams[0])
		get_tree().get_root().get_node("Hud/HUDElement/music").stream = load("res://Music/" + musicStreams[0])
		music.play()
		return
	
	var musicFolder = Directory.new()
	musicFolder.open("res://Music/")
	musicFolder.list_dir_begin(true,false)
	var fileName = musicFolder.get_next()
	while fileName != "":
		if fileName.ends_with("ogg"):
			print("yeet " + str(musicStreams.size()))
			musicStreams.append(fileName)
		fileName = musicFolder.get_next()
	randomize()
	musicStreams.shuffle()
	print(musicStreams[0])
	get_tree().get_root().get_node("Hud/HUDElement/music").stream = load("res://Music/" + musicStreams[0])
	music.play()

#update one of the heath sprites
func updateHealth(var node,var ammount):
	#node = refreence to health sprite to update
	#ammount, multiple of 2 that it represents (2,4,6,8,10)
	if main.playerHealth < ammount: #if the player health is less than ammount
		if main.playerHealth == ammount-1: #if it's one less than ammount then
			node.set_region_rect(half) #you're half full 
		elif main.playerHealth <= ammount-2: #if it's more than 2 less than ammount 
			node.set_region_rect(empty) #then you're empty! Inside. Like me. Again just kidding, I'm OK, just kinda tired, it's late right now. You know what, I'm going to bed.
	else: #if it's more than the ammount
		node.set_region_rect(full) #then you're a full heart


#this function checks & updates the coins on the hud
func checkCoins(): 
	if main.coins != prevCoins: #if the number of coins have changed
		sfx.set_pitch_scale(rand_range(.95,1.05))
		sfx.play(0) #play a sound with a ^^^ randomized pitch
		var t = Timer.new() #this creates a timer that we'll use later
		if !coinFading: #is the coin (not) fading?
			prevCoins = main.coins
			coinFading = true #well now it is!!
			coins.get_node("fadeAnim").playback_speed = 1000
			coins.get_node("fadeAnim").play_backwards("fade")
			#use timer to wait for 3 seconds
			t.set_wait_time(3) 
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			#all that stuff up there is just to wait for 3 seconds
			t.queue_free()
			coins.get_node("fadeAnim").playback_speed = 1
			coins.get_node("fadeAnim").play("fade")
			coinFading = false #we're no longer fading
		else: #if we are aleady fading
			prevCoins = main.coins
			t.set_wait_time(3)
			

#adjusts speed of all the different health nodes
func playbackSpeed(var speed):
	health.get_node("fadeAnim").playback_speed = speed
	zer.get_node("fadeAnim").playback_speed = speed
	two.get_node("fadeAnim").playback_speed = speed
	four.get_node("fadeAnim").playback_speed = speed
	six.get_node("fadeAnim").playback_speed = speed
	eight.get_node("fadeAnim").playback_speed = speed

#stops playback of all health nodes
func stopPlayback(var toThis):
	health.get_node("fadeAnim").stop(toThis)
	zer.get_node("fadeAnim").stop(toThis)
	two.get_node("fadeAnim").stop(toThis)
	four.get_node("fadeAnim").stop(toThis)
	six.get_node("fadeAnim").stop(toThis)
	eight.get_node("fadeAnim").stop(toThis)

#fades all health nodes, in/out based on true/false
func fade(var inout):
	stopPlayback(true)
	if inout:
		playbackSpeed(1) #fadeout is slow
		health.get_node("fadeAnim").play("fade")
		zer.get_node("fadeAnim").play("fade")
		two.get_node("fadeAnim").play("fade")
		four.get_node("fadeAnim").play("fade")
		six.get_node("fadeAnim").play("fade")
		eight.get_node("fadeAnim").play("fade")
	else:
		playbackSpeed(1000) #fade in is fast
		health.get_node("fadeAnim").play_backwards("fade")
		zer.get_node("fadeAnim").play_backwards("fade")
		two.get_node("fadeAnim").play_backwards("fade")
		four.get_node("fadeAnim").play_backwards("fade")
		six.get_node("fadeAnim").play_backwards("fade")
		eight.get_node("fadeAnim").play_backwards("fade")

#checks whether it needs to display the health to the user
func checkHealthFade():
	if main.playerHealth != prevHealth: #if the health changes
		var t = Timer.new() #this creates a timer that we'll use later
		if !fading: #if we're not already fading out/displaying the health
			prevHealth = main.playerHealth #update prevHealth
			fading = true #well now we are
			fade(false) #fade in
			#use timer to wait for 3 seconds
			t.set_wait_time(3) 
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			#all that stuff up there is just to wait for 3 seconds
			fade(true) #fade out
			fading = false #we're no longer fading
		else: #if we are aleady fading
			prevHealth = main.playerHealth #
			t.set_wait_time(3)

var prevInteract = true

func interactWith(): 
	if main.interact == prevInteract:
		return
	else:
		prevInteract = main.interact
	if main.interact:
		get_node("CanvasLayer/Interact/fadeAnim").playback_speed = 1000
		get_node("CanvasLayer/Interact/fadeAnim").play_backwards("fade")
		get_node("CanvasLayer/Interact").text = "Press 'E' to interact with " + main.interactWith
	else:
		get_node("CanvasLayer/Interact/fadeAnim").playback_speed = 2
		get_node("CanvasLayer/Interact/fadeAnim").play("fade")


# warning-ignore:unused_argument
func _process(delta):
	coins.set_text(str(main.coins))
	checkCoins()
	
	#all of these functions of the same name update the various
	#different health sprites, there are five
	updateHealth(zer,2)
	updateHealth(two,4)
	updateHealth(four,6)
	updateHealth(six,8)
	updateHealth(eight,10)
	
	#this will fade out the health, or bring it in
	#based on whether or not it's changed recently
	checkHealthFade()
	
	#this updates the "press 'E' to interact with ...." at the top of the screen
	interactWith()
var currentSong = 0



#changes the current song
func changeSong(var nextSong):
	if music.is_playing():
		music.stop() #stop the song, if it's playing
		
		if nextSong == -1:
			if currentSong < musicStreams.size()-1:
				nextSong = currentSong + 1
			else:
				nextSong = 0
		
		
	#load the new song, I don't know why we have to do it like this, but we do.
	get_tree().get_root().get_node("Hud/HUDElement/music").stream = load("res://Music/" + musicStreams[nextSong])
	currentSong = nextSong #update the current song variable
	music.play() #play the song



func _on_music_finished():
	print("nextSong")
	changeSong(-1)
	#somebody once told me the world was gonna roll me, I ain't the sharpest tool in the sheeeeddddddd

func get_mute():
	
	if music.get_volume_db() < -79:
		print("true")
		return true
	else:
		print("false")
		return false
func getMusicVolume():
	return music.get_volume_db()
func setMusicVolume(var volume):
	music.set_volume_db(volume)

func set_mute(yesNo : bool):
	if yesNo:
		music.set_volume_db(-80)
	else:
		music.set_volume_db(0)