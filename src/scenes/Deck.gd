extends Node2D
class_name Deck

var cards = []
var inPlay = [] # Cards user is currently learning (what will be saved when save is called)
var step = 0
var complete = false

func _init(name_in):
	self.name = name_in
	var save_game = File.new() # Check if file exsists
	if not save_game.file_exists("user://" + self.name + ".txt"): # If it doesn't exsist make it
		# TODO Prompt its missing, ask to import
		save()
	# Start practice? make that func i think

func backup():
	# TODO
	pass

func loadIn():
	"File exsists already, read into inPlay"
	var save_game = File.new() # Check if file exsists
	var path = "user://" + self.name + ".txt"
	if not save_game.file_exists(path):
		# TODO Throw error missing file 
		# TODO Restore from a backup?
		pass
	else:
		save_game.open(path, File.READ) # Open user inputted file
		var lines = save_game.get_as_text().split("\n") # Read file in & Split by default delim
		for l in lines: # For each line
			var arr = l.split(";*;")
			if len(arr) > 1:
				inPlay.push_front([arr[0],arr[1],arr[2]])

func import(path,delim,count=2):
	"Import file into save data format"
	var file = File.new()
	file.open(path, File.READ) # Open user inputted file
	var lines = file.get_as_text().split("\n") # Split text by line
	file.close()
	for l in lines:
		var arr = l.split(delim) # Use inputted delimiter
		if len(arr) == count:
			cards.push_front([arr[0],arr[1]])
	
	# SAVE GAME FOR THE FIRST TIME
	var save_game = File.new() # Attempt to make a save file
	save_game.open("user://" + self.name + ".txt", File.WRITE)
	# For every card
	var time = [OS.get_date().get('year'),OS.get_date().get('month'),OS.get_date().get('day')]
	for card in cards:
		# Example: [2022, 4, 3];*;ゴルフ;*;golf
		# TODO depending on how many values the user is inputting we can add them at the end here:
		var card_data = str(time) + ";*;" + card[0] + ";*;" + card[1] 
		save_game.store_line(card_data) # Write the line to the file

func save():
	"Save game data into save format"
	"Uses current inPlay array to save"
	var save_game = File.new() # Attempt to make a save file
	# Update dates based off of inPlay
	save_game.open("user://" + self.name + ".txt", File.WRITE)
	for card in inPlay:
		save_game.store_line(card) # Write the line to the file	
	save_game.close() # Close save file

func mod(card):
	"Modify the card at hand for practicing"
	if len(inPlay) != 0:
		match step:
			0:
				card.get_node("Top").text = inPlay[0][1] # first card
				card.get_node("Bot").text = "" # second card
				card.get_node("Top").get_node("ani").play("fade_in")
			1:
				card.get_node("Bot").text = inPlay[0][2] # second card
				card.get_node("Bot").get_node("ani").play("fade_in")
				# TODO SHOW 4 options to implement SRS
			2:
				inPlay.pop_front()
				if len(inPlay) != 0:
					card.get_node("Top").text = inPlay[0][1] # first card
					card.get_node("Bot").text = "" # second card
					card.get_node("Top").get_node("ani").play("fade_in")
					step=0
				else:
					card.get_node("Top").text = "Session Complete" # first card
					card.get_node("Bot").text = "(insert stats here)"
					card.get_node("Bot").get_node("ani").play("fade_in")
					# End game practice loop here! i hate how unorganized this is :P
					# Here I would show the end screen and stuff then 
					# Go back to deck listing
					self.complete = true
		card.show()
		step+=1
	else:
		# IF save file is empty
		# TODO SOMETHING
		pass

func start():
	"Loop over deck until all cards are marked for a further date...?"
	"Iterate over cards and ask user if they're right or not"
	randomize()
	inPlay.shuffle() # shuffle deck
	# Add in the card object we'll be modifying:
	var card = load("res://scenes/Card.tscn").instance()
	#card.hide()
	return card
