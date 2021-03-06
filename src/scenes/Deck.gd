extends Node2D
class_name Deck

var cards = []
var inPlay = [] # Cards user is currently learning (what will be saved when save is called)
var step = 0
var complete = false

# Different groups of cards for the various sets the card will be in for spaced repititon and the algorithm

func _init(name_in): # Called from .new(name)
	self.name = name_in
	var save_game = File.new() # Check if file exsists
	if not save_game.file_exists("user://saves/" + self.name + ".txt"): # If it doesn't exsist make it
		# TODO Prompt its missing, ask to import
		save()
	else:
		#OS.alert('Init deck file error (18 of deck.gd)', 'Error')
		pass
		print("idk, its saved already, good ig")
	# Start practice? make that func i think

func loadIn():
	"File exsists already, read into inPlay"
	var save_game = File.new() # Check if file exsists
	var path = "user://saves/" + self.name + ".txt" # TODO FIX FILE EXTENSION
	if not save_game.file_exists(path):
		# TODO Restore from a backup?
		OS.alert('File is empty without any data. (27 of deck.gd)', 'Error')
	else:
		save_game.open(path, File.READ) # Open user inputted file
		var lines = save_game.get_as_text().split("\n") # Read file in & Split by default delim
		for l in lines: # For each line
			var arr = l.split(";*;")
			if len(arr) > 1:
				inPlay.push_front([arr[0],arr[1],arr[2]])

func import(path,delim,count=2): #todo add count here?
	"Import file into save data format"
	var file = File.new()
	file.open(path, File.READ) # Open user inputted file
	var lines = file.get_as_text().split("\n") # Split text by line
	file.close()
	print("Reading file into array.")
	for l in lines:
		var arr = l.split(delim) # Use inputted delimiter
		if len(arr) == count:
			cards.push_front([arr[0],arr[1]])
	# SAVE GAME FOR THE FIRST TIME
	var save_game = File.new() # Attempt to make a save file
	save_game.open("user://saves/" + self.name + ".txt", File.WRITE) 
	# For every card
	var time = [OS.get_date().get('year'),OS.get_date().get('month'),OS.get_date().get('day'),OS.get_time().hour,OS.get_time().minute,OS.get_time().second] # basically need to review card right away
	print("Converting array into save format.")
	for card in cards:
		# Example: [2022, 4, 3];*;?????????;*;golf
		# TODO depending on how many values the user is inputting we can add them at the end here:
		# TODO USE DATA TYPE IN PLACE OF TIME MAYBE? 
		var card_data = str(time) + ";*;" + card[0] + ";*;" + card[1] 
		save_game.store_line(card_data) # Write the line to the file
	save_game.close()

func save():
	"Save game data into save format"
	"Uses current inPlay array to save"
	print("SAVE SAVE SAVE SAVE SAVE SAVE SAVE SAVE SAVE SAVE SAVE SAVE SAVE SAVE SAVE SAVE SAVE ")
	var save_game = File.new() # Attempt to make a save file if it doesn't exsist
	# Update dates based off of inPlay
	save_game.open("user://saves/" + self.name + ".txt", File.WRITE)
	for card in inPlay: # overwrite the file
		save_game.store_line(card) # Write the line to the file	
	save_game.close() # Close save file

func backup():
	# TODO
	pass

func mod(card):
	"Modify the VISUALS of the card at hand for practicing" 
	# I hate how this was written. I'm sorry
	if len(inPlay) != 0:
		match step:
			0:
				# SHOW top card only
				#card.get_node("Bot1").get_node("fade_out").play("fade")
				#card.get_node("Bot").get_node("fade_out").play("fade")
				card.get_node("Top").text = inPlay[0][1] # first card
				card.get_node("Bot").text = "" # second card
				card.get_node("Bot1").text = ""
				card.get_node("Top").get_node("fade_in").play("fade")
			1:
				# TODO CLEAN THIS UP! DAMN! LOOKS LIKE ASS
				var line = inPlay[0][2]
				# If 2nd line has <BR> split that here!!!
				if len(line.split("<br />")) == 2:
					print(len(line.split("<br />")))
					line = line.split("<br />")
					print(line)
					card.get_node("Bot").text = line[0]
					card.get_node("Bot1").text = line[1]
					card.get_node("Bot").get_node("fade_in").play("fade")
					card.get_node("Bot1").get_node("fade_in").play("fade")
				else:
					card.get_node("Bot").text = inPlay[0][2]  # second card
					var ani = card.get_node("Bot").get_node("fade_in")
					ani.play("fade")
					yield(ani,"animation_finished")
			2:
				# Fade out cards, remove from array (TODO algorthim based off of time and button pressed)
				inPlay.pop_front()
				if len(inPlay) != 0: # If its not the last card!
					# SHOW top card only
					card.get_node("Bot1").get_node("fade_out").play("fade")
					var ani = card.get_node("Top").get_node("fade_out")
					var aani = card.get_node("Bot").get_node("fade_out")
					ani.playback_speed = global.ani
					aani.playback_speed = global.ani
					ani.play("fade")
					aani.play("fade")
					yield(ani, "animation_finished")
					yield(aani, "animation_finished")
					card.get_node("Top").text = inPlay[0][1] # first card
					card.get_node("Bot").text = "" # second card
					card.get_node("Bot1").text = ""
					card.get_node("Top").get_node("fade_in").play("fade")
					step=0
				else: # If its the last card!
					card.get_node("Top").text = "Session Complete" # first card
					card.get_node("Bot").text = "(insert stats here)"
					var ani = card.get_node("Bot").get_node("fade_in")
					ani.playback_speed = global.ani
					ani.play("fade")
					yield(ani, "animation_finished")
					# End game practice loop here! i hate how unorganized this is :P
					# Here I would show the end screen and stuff then 
					# Go back to deck listing
					self.complete = true
		step+=1 # Iterator basically; this lets us do everything in a set order continuously
	else:
		# IF save file is empty
		# TODO SOMETHING SCREAM OR SOMETHING
		print("Save file empty randomly...")

func start():
	"Loop over deck until all cards are marked for a further date...?"
	"Iterate over cards and ask user if they're right or not"
	# TODO algorthim logic ...
	randomize()
	inPlay.shuffle() # shuffle deck
	# Add in the card object we'll be modifying:
	var card = load("res://scenes/Card.tscn").instance()
	#card.hide()
	return card


