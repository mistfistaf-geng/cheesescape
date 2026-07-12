extends Control

@onready var req := $HTTPRequest
@onready var click = get_node("Click")

func _on_new_game_button_pressed() -> void:
	if not Global.mute_sound:
		click.play()
	Global.load_game()
	$NewGameTab.visible = true
	$MainMenuTab/NewGameButton.disabled = true
	$MainMenuTab/HowToPlayButton.disabled = true
	$MainMenuTab/ExtraButton.disabled = true
	
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


func _on_easy_button_pressed() -> void:
	if not Global.mute_sound:
		click.play()
	Global.num_mines = 40
	get_tree().change_scene_to_file("res://main.tscn")


func _on_med_button_pressed() -> void:
	if not Global.mute_sound:
		click.play()
	Global.num_mines = 60
	get_tree().change_scene_to_file("res://main.tscn")


func _on_hard_button_pressed() -> void:
	if not Global.mute_sound:
		click.play()
	Global.num_mines = 80
	get_tree().change_scene_to_file("res://main.tscn")


func _on_custom_button_pressed() -> void:
	if not Global.mute_sound:
		click.play()
	if $NewGameTab/DifficultyBox/VSlider.visible:
		Global.num_mines = int($NewGameTab/DifficultyBox/VSlider/NumMinesLabel.text)
		get_tree().change_scene_to_file("res://main.tscn")
	else:
		$NewGameTab/DifficultyBox/VSlider.visible = true


func _on_v_slider_value_changed(value: float) -> void:
	$NewGameTab/DifficultyBox/VSlider/NumMinesLabel.text = str(int(value))


func _on_close_button_pressed() -> void:
	$NewGameTab.visible = false
	$HowToPlayTab.visible = false
	$HowToPlayTab2.visible = false
	$HowToPlayTab3.visible = false
	$ExtrasTab.visible = false
	$ExtrasTab2.visible = false
	$MainMenuTab/NewGameButton.disabled = false
	$MainMenuTab/HowToPlayButton.disabled = false
	$MainMenuTab/ExtraButton.disabled = false
	$SettingsTab.visible = false
	if not Global.mute_sound:
		click.play()


func _on_how_to_play_button_pressed() -> void:
	if not Global.mute_sound:
		click.play()
	$HowToPlayTab.visible = true
	$MainMenuTab/NewGameButton.disabled = true
	$MainMenuTab/HowToPlayButton.disabled = true
	$MainMenuTab/ExtraButton.disabled = true
	


func _on_next_page_button_pressed() -> void:
	if not Global.mute_sound:
		click.play()
	$HowToPlayTab.visible = false
	$HowToPlayTab2.visible = true


func _on_next_page_button_2_pressed() -> void:
	if not Global.mute_sound:
		click.play()
	$HowToPlayTab2.visible = false
	$HowToPlayTab3.visible = true


func _on_prev_page_button_pressed() -> void:
	if not Global.mute_sound:
		click.play()
	$HowToPlayTab2.visible = false
	$HowToPlayTab.visible = true


func _on_prev_page_button_2_pressed() -> void:
	if not Global.mute_sound:
		click.play()
	$HowToPlayTab3.visible = false
	$HowToPlayTab2.visible = true

func _on_extra_button_pressed() -> void:
	if not Global.mute_sound:
		click.play()
	Global.load_game()
	$ExtrasTab.visible = true
	$MainMenuTab/NewGameButton.disabled = true
	$MainMenuTab/HowToPlayButton.disabled = true
	$MainMenuTab/ExtraButton.disabled = true


func _on_next_extra_button_pressed() -> void:
	if not Global.mute_sound:
		click.play()
	$ExtrasTab.visible = false
	$ExtrasTab2.visible = true
	if Global.num_wins >= 3:
		$ExtrasTab2/InnerColor/HardMode.button_pressed = true
	var numFound = 0
	for dormie in Global.dormies:
		if dormie[1] == true:
			var button = get_node("ExtrasTab2/InnerColor/"+dormie[0])
			button.button_pressed = true
			button.disabled = false
			numFound += 1
	if numFound == 7 and $ExtrasTab2/InnerColor/HardMode.button_pressed:
		$ExtrasTab2/InnerColor/WinButton.visible = true

func _on_back_extra_button_pressed() -> void:
	if not Global.mute_sound:
		click.play()
	$ExtrasTab.visible = true
	$ExtrasTab2.visible = false


func _on_check_pressed(check: String) -> void:
	var button = get_node("ExtrasTab2/InnerColor/"+check)
	button.button_pressed = true
	var explosion = get_node("ExtrasTab2/InnerColor/"+check+"/"+check)
	if not Global.mute_sound:
		explosion.play()


func _on_win_button_pressed() -> void:
	if not Global.mute_sound:
		click.play()
	$ExtrasTab2/InnerColor/MimiButton.visible = true
	$ExtrasTab2/DownloadLabel2.visible = true


func _on_mimi_art_pressed() -> void:
	if not Global.mute_sound:
		click.play()
	var export_image := OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS) +"/InkBirthdayArt.png"
	var img: Image = load("res://assets/inkartwip.png").get_image()
	var os = OS.get_name()
	if os == "Windows":
		print(img.save_png(export_image))
	elif os == "Web":
		JavaScriptBridge.download_buffer(img.save_png_to_buffer(), "InkBirthdayArt.png", "image/png")
	$ExtrasTab2/DownloadLabel.visible = true


func _on_mute_bgm_pressed() -> void:
	if $SettingsTab/DifficultyBox/MuteBgm.button_pressed == true:
		Global.mute_bgm = true
	else:
		Global.mute_bgm = false
	Global.save_game()


func _on_mute_sound_pressed() -> void:
	if $SettingsTab/DifficultyBox/MuteSound.button_pressed == true:
		Global.mute_sound = true
	else:
		Global.mute_sound = false
	Global.save_game()


func _on_settings_pressed() -> void:
	if not Global.mute_sound:
		click.play()
	$NewGameTab.visible = false
	$HowToPlayTab.visible = false
	$HowToPlayTab2.visible = false
	$HowToPlayTab3.visible = false
	$ExtrasTab.visible = false
	$ExtrasTab2.visible = false
	$MainMenuTab/NewGameButton.disabled = false
	$MainMenuTab/HowToPlayButton.disabled = false
	$MainMenuTab/ExtraButton.disabled = false
	$SettingsTab.visible = true
	$SettingsTab/DifficultyBox/MuteBgm.button_pressed = Global.mute_bgm
	$SettingsTab/DifficultyBox/MuteSound.button_pressed = Global.mute_sound
