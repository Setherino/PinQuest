extends Control

#the text that the NPC is speaking
onready var speakText = get_node("Canvas/PanelContainer/HBoxContainer/VBoxContainer2/SpeakingText")

#the text that displays the NPC's name
onready var nameText = get_node("Canvas/PanelContainer/HBoxContainer/VBoxContainer2/NameText")

#the Icon
onready var dgIcon = get_node("Canvas/PanelContainer/HBoxContainer/TextureRect")
var dgItem = 0

#triggered by HUD script by the same name
func dialogue(dgSource:Array,NPCname:String,icon:Texture):
	dgIcon.set_texture(icon) #set the icon texture
	dgItem = 0 #start at the 0th dialogue
	nameText.text = NPCname #set the name text
	while dgItem < dgSource.size(): #loop through all the dialouges
		speakText.text = dgSource[dgItem] #display the propper text
		yield(get_tree(),"idle_frame") #yield so the game doesn't freeze
	print("HIDING DIALOGUE")
	Hud.hideDialogue() #when you're done, hide yourself

#when the push the next button
func _on_Button_pressed():
	dgItem += 1 #itterate dgItem by one

func _ready():
	pass