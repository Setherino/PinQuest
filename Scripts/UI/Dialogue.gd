extends Control

onready var speakText = get_node("PanelContainer/HBoxContainer/VBoxContainer2/SpeakingText")

onready var nameText = get_node("PanelContainer/HBoxContainer/VBoxContainer2/NameText")

onready var dgIcon = get_node("PanelContainer/HBoxContainer/TextureRect")
var dgItem = 0

func dialogue(dgSource:Array,NPCname:String,icon:Texture):
	dgIcon.set_texture(icon)
	dgItem = 0
	nameText.text = NPCname 
	while dgItem < dgSource.size():
		speakText.text = dgSource[dgItem]
		yield(get_tree(),"idle_frame")
	Hud.hideDialogue()

func _on_Button_pressed():
	dgItem += 1