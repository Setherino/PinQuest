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

onready var dialogue = get_node("CanvasLayer/Dialogue")

onready var sfx = get_node("CanvasLayer/coinLabel/sfx")

# Called when the node enters the scene tree for the first time.
func _ready():
	dialogue.get_node("fadeAnim").playback_speed = 1000
	dialogue.get_node("fadeAnim").play("fade")
	dialogue.get_node("fadeAnim").playback_speed = 1

func showDialogue(dgSource:Array,NPCname:String,icon:Texture):
	dialogue.dialogue(dgSource,NPCname,icon)
	dialogue.get_node("fadeAnim").play_backwards("fade")

func hideDialogue():
	dialogue.get_node("fadeAnim").play("fade")

var full = Rect2(Vector2(388,45),Vector2(53,46))
var half = Rect2(Vector2(448,45),Vector2(53,46))
var empty = Rect2(Vector2(508,45),Vector2(53,46))
var prevCoins = 0
var prevHealth = 0
var fading = false
var coinFading = false

func checkZero():
	if main.playerHealth < 2:
		if main.playerHealth == 1:
			zer.set_region_rect(half)
		elif main.playerHealth == 0:
			zer.set_region_rect(empty)
	else:
		zer.set_region_rect(full)

func checkTwo():
	if main.playerHealth < 4:
		if main.playerHealth == 3:
			two.set_region_rect(half)
		elif main.playerHealth == 2:
			two.set_region_rect(empty)
	else:
		two.set_region_rect(full)

func checkFour():
	if main.playerHealth < 6:
		if main.playerHealth == 5:
			four.set_region_rect(half)
		elif main.playerHealth == 4:
			four.set_region_rect(empty)
	else:
		four.set_region_rect(full)

func checkSix():
	if main.playerHealth < 8:
		if main.playerHealth == 7:
			six.set_region_rect(half)
		elif main.playerHealth == 6:
			six.set_region_rect(empty)
	else:
		six.set_region_rect(full)

func checkEight():
	if main.playerHealth < 10:
		if main.playerHealth == 9:
			eight.set_region_rect(half)
		elif main.playerHealth == 8:
			eight.set_region_rect(empty)
	else:
		eight.set_region_rect(full)


func checkCoins():
	if main.coins != prevCoins:
		sfx.set_pitch_scale(rand_range(.95,1.05))
		sfx.play(0)
		var t = Timer.new() #this creates a timer that we'll use later
		if !coinFading:
			prevCoins = main.coins
			coinFading = true #well now we are
			coins.get_node("fadeAnim").playback_speed = 1000
			coins.get_node("fadeAnim").play_backwards("fade")
			#use timer to wait for 3 seconds
			t.set_wait_time(3) 
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			#all that stuff up there is just to wait for 3 seconds
			coins.get_node("fadeAnim").playback_speed = 1
			coins.get_node("fadeAnim").play("fade")
			coinFading = false #we're no longer fading
		else: #if we are aleady fading
			prevCoins = main.coins
			t.set_wait_time(3)
			

func playbackSpeed(var speed):
	health.get_node("fadeAnim").playback_speed = speed
	zer.get_node("fadeAnim").playback_speed = speed
	two.get_node("fadeAnim").playback_speed = speed
	four.get_node("fadeAnim").playback_speed = speed
	six.get_node("fadeAnim").playback_speed = speed
	eight.get_node("fadeAnim").playback_speed = speed

func stopPlayback(var toThis):
	health.get_node("fadeAnim").stop(toThis)
	zer.get_node("fadeAnim").stop(toThis)
	two.get_node("fadeAnim").stop(toThis)
	four.get_node("fadeAnim").stop(toThis)
	six.get_node("fadeAnim").stop(toThis)
	eight.get_node("fadeAnim").stop(toThis)


func fade(var inout):
	stopPlayback(true)
	if inout:
		playbackSpeed(1)
		health.get_node("fadeAnim").play("fade")
		zer.get_node("fadeAnim").play("fade")
		two.get_node("fadeAnim").play("fade")
		four.get_node("fadeAnim").play("fade")
		six.get_node("fadeAnim").play("fade")
		eight.get_node("fadeAnim").play("fade")
	else:
		playbackSpeed(1000)
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
	checkZero()
	checkTwo()
	checkFour()
	checkSix()
	checkEight()
	checkHealthFade()
	interactWith()