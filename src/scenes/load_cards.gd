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
	pass
	# This path for importing will come with drag onto window 
	#deck.import("/home/koe/CSdev/Game Development Stuff/Godot Repository/study/test.txt",";*;",2)
	#$FileDialog.popup() # Popup file dialog

func _input(event):
# Mouse in viewport coordinates.
	if event.is_action_pressed("ui_accept") && started:
		deck.mod(card)
		if toggle == 0:
			get_node("Buttons/SRS").show()
			toggle+=1
		else:
			get_node("Buttons/SRS").hide()
			toggle=0
		


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

