extends Node

var num_wins = 0
var num_mines: int = 0
var dormies = [["KBarn", false], ["Lam", false], ["mistfist", false], 
["plarty", false], ["PrivateShorty", false], ["Samby", false], 
["MegaDeuceX", false], ["Tuna", false], ["Bloon", false],
["Crayo", false], ["Scar", false], ["Minty", false], ["MintysWife", false],
["abbit", false], ["Drei", false], ["dede", false], ["TKBean", false],
["Tobehz", false], ["Kingjah", false], ["Chiaki", false],
["Naka", false], ["weaboodanger", false], ["JBHUTT", false],["Boba", false]]
var mute_bgm = false
var mute_sound = false
var mimi_love = false
var quiz = ["temp", 0, 0, 0, 0, 0, 0, 0, 0, 0, "0", "0", 0]

func save():
	var save_file = {
		"num_wins" : num_wins,
		"dormies" : dormies,
		"mute_bgm" : mute_bgm,
		"mute_sound" : mute_sound,
		"mimi_love" : mimi_love,
		"quiz" : quiz
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
	print(content)
	num_wins = content.get("num_wins")
	var tempDorm = content.get("dormies")
	if tempDorm.size() == dormies.size():
		dormies = tempDorm
	else:
		var size = dormies.size()
		while(tempDorm.size() < size):
			var pop = dormies.pop_back()
			tempDorm.append(pop)
		dormies = tempDorm
		save_game()
		
	mute_bgm = content.get("mute_bgm")
	mute_sound = content.get("mute_sound")
	mimi_love = content.get("mimi_love")
	quiz = content.get("quiz")
