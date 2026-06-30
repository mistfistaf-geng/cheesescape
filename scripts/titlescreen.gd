extends Control

const MAIN_SCENE = preload("res://main.tscn")

func _on_new_game_button_pressed() -> void:
	$NewGameTab.visible = true
	$MainMenuTab/NewGameButton.disabled = true
	$MainMenuTab/ExtraButton.disabled = true
	$MainMenuTab/ExitButton.disabled = true
	$NewGameTab/DifficultyBox/MedButton.disabled = true
	$NewGameTab/DifficultyBox/HardButton.disabled = true
	$NewGameTab/DifficultyBox/CustomButton.disabled = true
	$NewGameTab/DifficultyBox/EasyButton.disabled = false
	var texture = load("res://assets/unlock.png")
	if Global.num_wins == 1:
		$NewGameTab/DifficultyBox/MedButton.disabled = false
		$NewGameTab/DifficultyBox/MedLock.texture = texture
	elif Global.num_wins == 2:
		$NewGameTab/DifficultyBox/MedButton.disabled = false
		$NewGameTab/DifficultyBox/MedLock.texture = texture
		$NewGameTab/DifficultyBox/HardButton.disabled = false
		$NewGameTab/DifficultyBox/HardLock.texture = texture
	elif Global.num_wins == 3:
		$NewGameTab/DifficultyBox/MedButton.disabled = false
		$NewGameTab/DifficultyBox/MedLock.texture = texture
		$NewGameTab/DifficultyBox/HardButton.disabled = false
		$NewGameTab/DifficultyBox/HardLock.texture = texture
		$NewGameTab/DifficultyBox/CustomButton.disabled = false
		$NewGameTab/DifficultyBox/CustomLock.texture = texture
	pass


func _on_extra_button_pressed() -> void:
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_easy_button_pressed() -> void:
	Global.num_mines = 40
	get_tree().change_scene_to_file("res://main.tscn")


func _on_med_button_pressed() -> void:
	Global.num_mines = 60
	get_tree().change_scene_to_file("res://main.tscn")


func _on_hard_button_pressed() -> void:
	Global.num_mines = 80
	get_tree().change_scene_to_file("res://main.tscn")


func _on_custom_button_pressed() -> void:
	if $NewGameTab/DifficultyBox/VSlider.visible:
		Global.num_mines = int($NewGameTab/DifficultyBox/VSlider/NumMinesLabel.text)
		get_tree().change_scene_to_file("res://main.tscn")
	else:
		$NewGameTab/DifficultyBox/VSlider.visible = true


func _on_v_slider_value_changed(value: float) -> void:
	$NewGameTab/DifficultyBox/VSlider/NumMinesLabel.text = str(int(value))
