extends ColorRect

# Path to the next scene to transition to
export(String, FILE, "*.tscn") var next_scene_path

# Reference to the _AnimationPlayer_ node
onready var _anim_player := $AnimationPlayer

func _ready():
	# Plays the animation backward to fade in
	_anim_player.play_backwards("fade")
	_anim_player.playback_speed = global.ani

func fade():
	#Fade for me 
	_anim_player.play("fade")
	yield(_anim_player, "animation_finished")
	
func transition_to(next_scene):
	# Plays the Fade animation and wait until it finishes
	_anim_player.play("fade")
	yield(_anim_player, "animation_finished")
	# Changes the scene
	get_tree().change_scene(next_scene)

