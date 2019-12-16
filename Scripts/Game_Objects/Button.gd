extends Area2D

#Toggleable/momentary buttons


#written by Seth Ciancio, 12/1/19
#updated by Seth Ciancio, 12/6/19
#-added linkObjects & stuff

#I guess I should explain linkObjects, huh? Ok, well when you want the player to trigger
#something, with say, a button, the game needs to know what you want to be triggered, so
#how does it do that? linkObjects of course! Basically, if you want a button to control a
#door, you set the button's sourceName to "john" and the doors sourceName to, well, "john",
#and the button now unlocks the door.


export var momentary = false #if this is true the button won't toggle, but will be momentary
export var color = "yellow" #defines the color of the button (y,g,r,b)
export var sourceName = "button1" #the sourceName

var onButton = false #is the player on the button?
var outfit #where in the spritesheet should the sprite's reigon be set?

#this is so we can use the linkObject class, which is a custom class that I made.
var link : linkObject = linkObject.new("Button") 

#these are the X & Y positions of the buttons in the spritesheet
#it goes, y-g-r-b, then their respective active versions
var posArrayX = [1040,1120,1040,1120,1040,1120,1040,1120] 
var posArrayY = [266,266,346,346,426,426,506,506]

#these are just the names, in the previously mentioned order (y-g-r-b)
var names = ["yellow","green","red","blue"]

#these are so we can edit the sprite and play sounds
onready var sprite = get_node("Sprite")
onready var sfx = get_node("sound")

#these are also for the sprite
var size = Vector2(70,70) #this is the size, it's always 70x70 
var onRectangle = Rect2( ) #this is for when it's on
var offRectangle = Rect2( ) #and this is for when it's off
#they're empty because I define the size later in the program based on
#what you enter as the color

func _ready():
	link.initialize(sourceName,true)
	outfit = names.find(color) #here we find your outfit (0 = y, 1 = g, ect.)
	

	#add four, because that's how many variants there are, so it goes to the off ones
	var posOff = Vector2(posArrayX[outfit+4],posArrayY[outfit+4])
	var pos = Vector2(posArrayX[outfit],posArrayY[outfit])
	
	onRectangle = Rect2(pos,size)
	offRectangle = Rect2(posOff,size)


func setOutfit( ): 
	if !link.enabled: #if we're off
		sprite.set_region_rect(onRectangle) #set it to on
	else: #if we're on
		sprite.set_region_rect(offRectangle) #set if to off
#^^ it's weird becasue late in development I decided on/off should be switched.

# warning-ignore:unused_argument
func _process(delta):
	link.update()
	if link.initialized: #if we have our linkCode
		setOutfit() #set the outfit



# warning-ignore:unused_argument
func _input(event): #when any key is pressed
	#see if it's the right key, and they'tre touching the right button
	if Input.is_action_just_pressed("interact") && onButton: 
		if !momentary: #if you didn't select momentary,
			if link.enabled: #and it's on
				link.setto(false) #turn off (toggle off)
				sfx.play(0)
			else: #and it's off,
				link.setto(true) #turn on (toggle on
				sfx.play(0)


# warning-ignore:unused_argument
func _on_Button_body_entered(body): #if something's touching the button
	if momentary: #and you selected momentary
		link.setto(true) #turn on (turning off is handled elsewhere)
		sfx.play(0)
	else: #if you didn't select momentary,
		onButton = true #just set onButton (used earlier) to true 
		main.interact = true
		main.interactWith = "button"


# warning-ignore:unused_argument
func _on_Button_body_exited(body): #when someone stops touching the button
	if momentary: #if you selected momentary
		link.setto(false) #turn off (this is the elsewhere I mentioned earlier lol)
		sfx.play(0)
	else: #if you didn't slect momentary 
		onButton = false #just set onButton (used earlier) to false 
		main.interact = false
		main.interactWith = "nothing"
	