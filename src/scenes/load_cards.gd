extends CanvasLayer
# Planned workflow:
### Options: import, load, delete, edit, export?
### import reads in a csv with inputted delimiter 
### then it saves it into a new csv-like format for saving the dates

var deck
var card
var started = false
var toggle = 0

onready var _transition_rect := $transition

func _add_dir_contents(dir: Directory, files: Array, directories: Array):
	var file_name = dir.get_next()
	while (file_name != ""):
		var path = dir.get_current_dir() + "/" + file_name
		if dir.current_is_dir():
			print("Found directory: %s" % path)
			var subDir = Directory.new()
			subDir.open(path)
			subDir.list_dir_begin(true, false)
			directories.append(path)
			_add_dir_contents(subDir, files, directories)
		else:
			print("Found file: %s" % path)
			files.append(path)
			file_name = dir.get_next()
	dir.list_dir_end()

func get_dir_contents(rootPath: String) -> Array:
	var files = []
	var directories = []
	var dir = Directory.new()
	if dir.open(rootPath) == OK:
		dir.list_dir_begin(true, false)
		_add_dir_contents(dir, files, directories)
	else:
		push_error("An error occurred when trying to access the path.")

	return files

# CALLED FROM A SAVE FILE LOADING IN
func _save_open(save_name: String):
	"Open test file we imported and made initially"
	print("Opening : " + save_name)
	# CHANGE THIS STUFF INTO LIKE A MODE OR SOMETHING
	$Buttons/saves.hide()
	$Buttons/oo.hide()
	
	# DECK INITIATING
	deck = Deck.new(save_name) # Take in string from button
	deck.loadIn()
	card = deck.start() # Start test mode
	add_child(card)
	started = true
	deck.mod(card)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Make button for each save file
	var saves = get_dir_contents("user://saves")
	for file in saves:
		var butt =  Button.new()
		butt.text = String(file).replace("user://saves/","").split(".")[0] # user://saves/test.txt -> test
		butt.connect("pressed", self, "_save_open", [butt.text]) # send the legit file name to the function
		get_node("Buttons/saves").add_child(butt)
	# Read in current save files and make buttons for each:
	# Buttons/Options/VBoxContainer add buttons to this container
	
	
func load_in(files_dropped : PoolStringArray, screen : int):
	"On file drop, do this"
	pass
	# TODO
	# VERIFY the file is a CSV/TXT/SOMITHNG in the future
	#if files_dropped[0]
	# GET USER file input
	#deck = Deck.new() # handle if file exsists with popup
	# Deck.import(files_dropped[0])
	# prompt for delimiter
	# run function on it to format it correctly (below)
	

func _input(event):
	# Mouse in viewport coordinates.
	# PRINT FPS
	#print(String(Engine.get_frames_per_second()))
	if event.is_action_pressed("quit"):
		 get_tree().quit()
	if event.is_action_pressed("ui_accept") && started:
		if not deck.complete:
			deck.mod(card)
			if toggle == 0:
				$Buttons/SRS/fade_in.play("fade")
				$Buttons/SRS/HBoxContainer.show()
				toggle+=1
			else:
				var ani = $Buttons/SRS/fade_out
				ani.play("fade")
				yield(ani, "animation_finished")
				$Buttons/SRS/HBoxContainer.hide()
				toggle=0
		else:
			get_tree().change_scene("res://scenes/load_cards.tscn")

func _on_Import_pressed():
	"Switch scenes to file drag and drop window!"
	# TODO Maybe add an actually file tree thing in the future
	get_tree().change_scene("res://scenes/import_decks.tscn")


func _on_back_pressed():
	"Switch back to main menu"
	get_tree().change_scene("res://scenes/main.tscn")
