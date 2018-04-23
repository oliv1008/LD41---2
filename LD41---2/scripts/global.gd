extends Node2D

var letters_of_player = " "

func _ready():
	pass

func add_letter(lettre) :
	letters_of_player = str(letters_of_player, " ", lettre)

func remove(indice, chars):
	letters_of_player.erase(indice, chars)

func check_input(s):
	var temp_buff = letters_of_player
	for i in s:
		var ind = temp_buff.find(i)
		if ind != -1 : temp_buff.erase(ind, 1)
		else : return false
	return true

func clear_singleton():
	letters_of_player = " "
	nc.clean_observer()

func reorganize_letters():
	var temp_buff = ""
	for i in letters_of_player:
		if not(i.match(' ')):
			temp_buff = str(temp_buff, i, ' ')
	print("temp_buff = ", temp_buff)
	letters_of_player = temp_buff

#SCENE MANAGEMENT

func load_menu():
	#mod_scener.fastload_with_fade(target, "res://levels/Test-Main-Menu.tscn", true)
	mod_scener.fastload("res://levels/Test-Main-Menu.tscn")
func _on_New_game_button_pressed():
	#mod_scener.fastload_with_fade(target, "res://levels/Tutorial.tscn")
	mod_scener.fastload("res://levels/Tutorial.tscn")
	
func to_next_level(path):
	#mod_scener.fastload_with_fade(target, path)
	mod_scener.fastload(path)
