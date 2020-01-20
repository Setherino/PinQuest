extends Control

#the text that the NPC is speaking
onready var speakText = get_node("Canvas/Control/SpeakingText")

#the text that displays the NPC's name
onready var nameText = get_node("Canvas/Control/NameText")

#the Icon
onready var dgIcon = get_node("Canvas/Control/TextureRect")
var dgItem = 0

#triggered by HUD script by the same name
func dialogue(dgSource:Array,NPCname:String,icon:Texture):
	while dgSource.back() == "":
		dgSource.pop_back()
	
	dgIcon.set_texture(icon) #set the icon texture
	dgItem = 0 #start at the 0th dialogue
	nameText.text = NPCname #set the name text
	while dgItem < dgSource.size(): #loop through all the dialouges
		speakText.text = dgSource[dgItem] #display the propper text
		yield(get_tree(),"idle_frame") #yield so the game doesn't freeze
	
	#once we're done going through all the dialogue,
	#if the NPC has an active task
	if main.taskGoal == NPCname:
			showDial() #trigger the ending event for
			main.resetTasks(true,false) #that task
	Hud.hideDialogue() #when you're done, hide yourself


func showDial():
	if main.taskType == 2:
		Hud.showMessage("Task Complete!","You successfully spoke with " +
		 nameText.text + ". \nTo start a new task, open your task menu, and start one!")
	elif main.taskType == 3:
		Hud.showMessage("Task Complete!","You successfully delivered the item to " 
		+ main.taskGoal + ".\nOpen your task menu to start a new task!")

#when the push the next button
func _on_Button_pressed():
	dgItem += 1 #itterate dgItem by one
	
	


