extends CanvasLayer

func _process(delta):
	# Take slider value and apply to global animation speeds!!!
	pass


func _animation_slider_top(value):
	# TODO SET to global var
	print(value) 


func _on_back_pressed():
	get_tree().change_scene("res://scenes/main.tscn")
