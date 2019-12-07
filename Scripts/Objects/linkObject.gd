extends Object


#written by Seth Ciancio 12/6/19

class_name linkObject

#this is the link code, the item in the list represented
var linkCode = 0
#this is whether or not it's found it's link code yet
var initialized = false
#this is whether it's sending or recieving
var sending = false
#this the name of the source, I.E., john, carry, claire, max... max is a sexy name lol
var sourceName = " "
#whether this link code is enabled
var enabled = false
#it's type, IE, button, door, indicator,ect.
var type = "Unknown"

#constructor function does almost nothing
func _init(Type:String):
	type = Type

#it's all done in this function, becuase it has to be done in runtime because
#of the way eported variables work, whoops.
func initialize(sName:String,Send:bool):
	print(type + " " + sName + " beginning initialization")
	sourceName = sName #setting sourceName
	if Send: #if you're sending data
		sending = true #set sending to true
		#if the list contains your name already, like 
		if (main.sourceNames.has(sName)): #if you're opening a previously loaded level for example
			linkCode = main.sourceNames.find(sName) #find your name in the list & set your linkCode
			print(type + " " + sourceName + "- found link code: " + str(linkCode))
			initialized = true #set initialized to true (because we're done!)
		else: #if the list doesn't conatin your name
			main.sourceNames.push_back(sName) #create it
			main.linkCodes.push_back(false) #create the linkCode too
			linkCode = main.sourceNames.find(sName) #and make sure to remember where it is
			initialized = true #now we're initialized!
			print(type + " " + sourceName + "- created link code: " + str(linkCode))

#this should be called with the _process function
func update():
	#the receivers have to wait for the senders to create the places in
	#the arrays, so their initialization goes on here
	if (main.sourceNames.has(sourceName) && !initialized && !sending):
		linkCode = main.sourceNames.find(sourceName) #find & set linkCode
		print(type + " " + sourceName + "- found link code: " + str(linkCode))
		initialized = true #we're initialized
	
	if initialized: #if you're initialized
		enabled = main.linkCodes[linkCode] #set enabled to the right thing
		

#these are all pretty simple, so.. yk just figure it out
func setto(to:bool): 
	main.linkCodes[linkCode] = to

func on( ):
	main.linkCodes[linkCode] = true

func off( ):
	main.linkCodes[linkCode] = false