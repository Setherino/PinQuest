extends Control
var desc : File = File.new()
const tasks = preload("res://UI/inventoryTask.tscn")
const head = preload("res://UI/Task.tscn")
func header():
	var taskDisplay = head.instance()
	taskDisplay.advanced = true
	get_node("CanvasLayer/TabContainer/Quests & Tasks/Split/Panel/TopContainer/CurrentContainer").add_child(taskDisplay)
	
	
	
	

func addTask(location:String,place):
	
	var task : File = File.new()
	if !task.file_exists(location):
		print("ERROR! " + location + " IS NOT A VALID TASK LOCATION!")
		return
	
	task.open(location,1)
	var taskDisplay = tasks.instance()
	
	taskDisplay.get_node("Name").text = task.get_line()
	taskDisplay.get_node("Type").text = task.get_line()
	taskDisplay.get_node("Goal").text = task.get_line()
	taskDisplay.get_node("TimeLimit").text = task.get_line()
	taskDisplay.get_node("Ammount").text = task.get_line()
	taskDisplay.place = place
	get_node("CanvasLayer/TabContainer/Quests & Tasks/Split/Scroll/VContainer").add_child(taskDisplay)

var prevID = 0

func _process(delta):
	if main.taskID != prevID:
		prevID = main.taskID
		if desc.is_open():
			desc.close()
		
		desc.open(main.taskFileNames[main.taskID],1)
		
		var line = ""
		
		while line != "-DESCRIPTION:" && !desc.eof_reached():
			line = desc.get_line()
		
		if !desc.eof_reached():
			get_node("CanvasLayer/TabContainer/Quests & Tasks/Split/Panel/TopContainer/descriptionText").text = desc.get_line()
			pass
	pass

func _ready():
	var i = 0
	print (main.taskFileNames.size())
	header()
	while i < main.taskFileNames.size():
		addTask(main.taskFileNames[i],i)
		i = i + 1
		pass
	pass