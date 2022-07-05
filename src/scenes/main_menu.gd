extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#onready var _transition_rect := $transistion

func _start_pressed():	
	get_tree().change_scene("res://scenes/load_cards.tscn")
	#_transition_rect.transition_to("res://scenes/load_cards.tscn")
