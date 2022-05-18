extends CanvasLayer

# Planned workflow:
### 2 Options: import, load
### import reads in a csv with inputted delimiter 
### then it saves it into a new csv-like format for saving the dates

var deck
var card
var started = false
var toggle = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Enable files dropped onto window functionality
	get_tree().connect("files_dropped", self, "load_in")
	
func load_in(files_dropped : PoolStringArray, screen : int):
	"On file drop, do this"
	pass
	# VERIFY the file is a CSV/TXT/SOMITHNG in the future
	#if files_dropped[0]
	# GET USER file input
	#deck = Deck.new() # handle if file exsists with popup
	# Deck.import(files_dropped[0])
	
	# prompt for delimiter
	# run function on it to format it correctly (below)
	

func _input(event):
# Mouse in viewport coordinates.
	if event.is_action_pressed("ui_accept") && started:
		if not deck.complete:
			deck.mod(card)
			if toggle == 0:
				get_node("Buttons/SRS").show()
				toggle+=1
			else:
				get_node("Buttons/SRS").hide()
				toggle=0
		else:
			get_tree().change_scene("res://scenes/load_cards.tscn")
		


func _on_Test_pressed():
	"Open test file we imported and made initially"
	get_node("Buttons/Options").hide()
	get_node("Buttons/SRS").hide()
	deck = Deck.new("test")
	deck.loadIn()
	card = deck.start() # Start test mode
	add_child(card)
	started = true
	deck.mod(card)

func _on_Import_pressed():
	"Switch scenes to file drag and drop window!"
	# TODO Maybe add an actually file tree thing in the future
	get_tree().change_scene("res://scenes/import_decks.tscn")

