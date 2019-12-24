#written 12/18ish/19
#written by Seth Ciancio

#comments on 12/21/19 3:21AM

#Seem off? You might be looking for Task.gd
#they're similar elements. "Task" is used in the taskManager & as
# a header for the inventory. Wheras "inventoryTask" is used
#for, well the inventory. The main difference is the button.

extends Control

#the Start Task button
onready var button = get_node("Activate")

#for it's place in the list/ the taskManager array
var place = 0

#runs when the scene is created
func _ready():
	if main.taskStarted[place]: #if the tasks already been started
		queue_free() #delete yoself


#runs every frame
func _process(delta):
	if main.taskName != "none": #if there is (not) no current task
		button.disabled = true #dissable the button
	else: #if there is no current task
		button.disabled = false #enable the button
	
	if main.deleteTaskList: #if the deleteTaskList variable is true,
		queue_free() #stop existing (delete)

#when the button is pressed
func _on_Activate_pressed():
	
	#set all the current task stuff to whatever your
	#text says it should be, this includes
	main.taskName = get_node("Name").text #the task name
	main.taskType = int(get_node("Type").text) #the task type (1,2,3,4)
	main.taskGoal = get_node("Goal").text # the task goal
	main.timeLimit = int(get_node("TimeLimit").text) #the task's time limit
	main.taskAmmountNeeded = int(get_node("Ammount").text) #the ammount of stuff to collect
	main.taskID = place #the place in the array/list. Honestly, why do we need this?
	#oh, for the header, it reads the file. Wait, no. It should just read those variables.
	#hm, some inneficiency to look at there maybe.
	#it's the next day, and never mind, it's useful, I just used it in the _ready() func
	main.taskStarted[place] = true
	Hud.showTaskPannel() #shows the task pannel, obvi
	main.startTask()
	queue_free() #stop existing (delete)
