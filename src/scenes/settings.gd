extends CanvasLayer

func _process(delta):
	# Take slider value and apply to global animation speeds!!!
	pass


func _animation_slider_top(value):
	# Set global animation speed variable!
	var scale = value*2/100
	global.ani = scale


func _on_back_pressed():
	get_tree().change_scene("res://scenes/main.tscn")
