extends Node

var num_wins = 0
var num_mines: int = 0
var dormies = [["KBarn", false], ["Lam", false], ["mistfist", false], 
["plarty", false], ["PrivateShorty", false], ["Samby", false], 
["MegaDeuceX", false]]
var mute_bgm = false
var mute_sound = false

func save():
	var save_file = {
		"num_wins" : num_wins,
		"dormies" : dormies,
		"mute_bgm" : mute_bgm,
		"mute_sound" : mute_sound
	}
	return save_file
	
func save_game():
	var save_game = FileAccess.open("user://savegame.dat", FileAccess.WRITE)
	save_game.store_var(save())
	save_game.close()
	
func load_game():
	if not FileAccess.file_exists("user://savegame.dat"):
		print("No Save Yet")
		return
	var save_game = FileAccess.open("user://savegame.dat", FileAccess.READ)
	var content = save_game.get_var()
	print(content.get("dormies"))
	num_wins = content.get("num_wins")
	dormies = content.get("dormies")
	mute_bgm = content.get("mute_bgm")
	mute_sound = content.get("mute_sound")
