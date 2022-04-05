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

func test_butt_pressed():
	"Open test file we imported and made initially"
	$Control/Center.hide()
	$Control/SRS.hide()
	deck = Deck.new("test")
	deck.loadIn()
	card = deck.start() # Start test mode
	add_child(card)
	started = true
	deck.mod(card)

func _input(event):
# Mouse in viewport coordinates.
	if event.is_action_pressed("ui_accept") && started:
		deck.mod(card)
		if toggle == 0:
			$Control/SRS.show()
			toggle+=1
		else:
			$Control/SRS.hide()
			toggle=0
		
