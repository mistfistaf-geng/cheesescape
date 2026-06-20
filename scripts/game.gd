# cheesescape.gd
extends Node2D

const RUNE_SCENE = preload("res://rune.tscn")
@export var rows: int = 18 # Number of rows
@export var cols: int = 18 # Number of columns
@export var num_mines: int = 40
@export var num_flags: int = 0
@export var current_score: int = 0
var runes = [] #2D array to store rune instances
var first_click_complete = false
var clock
var mines
var score

func _ready():
	create_grid()
	clock = get_node("ColorRect/Clock")
	mines = get_node("ColorRect/Mines/CurrentMines")
	score = get_node("ColorRect/Score/CurrentScore")
	mines.text = str(num_mines)
	score.text = str(current_score)
	
func create_grid():
	# Create runes and place them in 2D array
	for y in range(rows):
		runes.append([])
		for x in range(cols):
			var rune = RUNE_SCENE.instantiate()
			rune.position = Vector2(x, y) * rune.rune_size
			rune.rune_pressed.connect(_on_rune_pressed.bind(x,y))
			rune.middle_press.connect(_on_middle_press.bind(x,y))
			rune.flag_place.connect(_on_flag_place.bind(x,y))
			runes[y].append(rune)
			$Grid.add_child(rune)
	calculate_adjacent_mines()

func generate_mine_positions(first_click_position:Vector2i) -> Array:
	var first_click_positions = []
	for dy in range(-1,2):
		for dx in range(-1,2):
			first_click_positions.append(first_click_position + Vector2i(dx, dy))
			
	randomize()
	var mine_positions = []
	while mine_positions.size() < num_mines:
		var pos = Vector2i(randi() % cols, randi() % rows)
		if pos not in mine_positions and pos not in first_click_positions:
			mine_positions.append(pos)
	return mine_positions;
	
func count_adjacent_mines(x: int, y: int) -> int:
	var count = 0
	for dy in range(-1, 2): # Iterate over vertical neighbors (-1 to 1)
		for dx in range(-1, 2): #Iterate over horizontal neighbors (-1 to 1)
			if dx == 0 and dy == 0:
				continue #skip self
			var nx = x + dx
			var ny = y + dy
			#Check if neighbor is within bounds
			if nx >= 0 and ny >= 0 and nx < cols and ny < rows:
				if runes[ny][nx].is_mine:
					count+= 1
	return count
	
func calculate_adjacent_mines():
	for y in range(rows):
		for x in range(cols):
			var rune = runes[y][x]
			if not rune.is_mine:
				rune.adjacent_mines = count_adjacent_mines(x, y)
				
func _on_rune_pressed(x: int, y: int):
	var rune = runes[y][x]
	if not first_click_complete:
		first_click_complete = true
		var mine_positions = generate_mine_positions(Vector2i(x,y))
		for pos in mine_positions:
			runes[pos.y][pos.x].is_mine = true
		calculate_adjacent_mines()
		start_timer()
		
	if rune.is_mine:
		rune.fail()
		game_over()
	else:
		reveal_rune_and_neighbors(x,y)
		if check_win_condition():
			game_won()

func reveal_rune_and_neighbors(x: int, y: int):
	if x < 0 or y < 0 or x >= cols or y >= rows:
		return
	var rune = runes[y][x]
	if rune.is_revealed or rune.is_mine:
		return	
	rune.reveal_rune()
	current_score += rune.adjacent_mines
	score.text = str(current_score)
	
	# If no adjacent mines, reveal neighbors
	if rune.adjacent_mines == 0:
		for dy in range(-1, 2):
			for dx in range(-1, 2):
				if dx != 0 or dy != 0:
					reveal_rune_and_neighbors(x + dx, y + dy)

func _on_middle_press(x: int, y: int):
	var rune = runes[y][x]
	if not rune.is_revealed:
		return	
	var mine_count: int = rune.adjacent_mines;
	var correct_count: int = 0;
	
	for dy in range(-1, 2):
		for dx in range(-1, 2):
			if dx != 0 or dy != 0:
				if (x + dx) >= 0 and (y + dy) >= 0 and (x + dx) < cols and (y + dy) < rows:
					var neighbor = runes[y + dy][x + dx]
					if neighbor.is_flagged and neighbor.is_mine:
						correct_count += 1
					if not neighbor.is_flagged and neighbor.is_mine:
						game_over()
	if mine_count == correct_count:
		reveal_neighbors_middle_press(x,y)
		if check_win_condition():
			game_won()
			
func reveal_neighbors_middle_press(x: int, y: int):
	if x < 0 or y < 0 or x >= cols or y >= rows:
		return
	var rune = runes[y][x]
	if rune.is_flagged:
		return	
	rune.reveal_rune()
	
	
	for dy in range(-1, 2):
		for dx in range(-1, 2):
			if dx != 0 or dy != 0:
				reveal_rune_and_neighbors(x + dx, y + dy)
				
func _on_flag_place(x: int, y: int):
	var rune = runes[y][x]
	if rune.is_flagged:
		num_flags += 1
	else:
		num_flags -= 1
	mines.text = str(num_mines - num_flags)

# Reveal all mines and end game
func game_over():
	for row in runes:
		for rune in row:
			rune.disabled = true;
			if rune.is_mine and not rune.is_revealed:
				rune.reveal_rune()
	$ColorRect/Title.text = "Game Over!"
	$ColorRect/Title.visible = true;
	stop_timer()

func check_win_condition():
	for row in runes:
		for rune in row:
			if not rune.is_revealed and not rune.is_mine:
				# If any non-mine is not revealed, player hasn't won
				return false
	return true # All non-mine runes are revealed

func game_won():
	for row in runes:
		for rune in row:
			rune.disabled = true
	$ColorRect/Title.text = "You Won!"
	$ColorRect/Title.visible = true;
	stop_timer()
	
func restart():
	first_click_complete = false
	for child in $Grid.get_children():
		child.queue_free()
	runes.clear()
	current_score = 0
	score.text = str(current_score)
	restart_timer()
	$ColorRect/Title.text = "Trap all the Dormies!"
	$ColorRect/Title.visible = true
	
	create_grid()
	
func _on_restart_button_pressed() -> void:
	restart()

var timer_running: bool = false
var current_time: float = 0.0

func start_timer() -> void:
	current_time = 0.0
	timer_running = true

func stop_timer() -> void:
	timer_running = false

func restart_timer() -> void:
	current_time = 0.0
	timer_running = false

func _process(delta: float) -> void:
	if timer_running:
		current_time += delta
	clock.text = convert_time_to_string(current_time)
	
func convert_time_to_string(time: float) -> String:
	var hours: int = int(time / (60.0 * 60.0))
	var minutes: int = int(time /60.0) % 60
	var seconds: int = int(time) % 60
	var miliseconds: int = int(time * 1000.0) % 1000
	var string: String = "%02d.%03d" % [seconds, miliseconds]
	if minutes > 0 or hours > 0:
		string = string.insert(0, ("02d:" if hours > 0 else "%d:") % minutes)
	if hours > 0:
		string = string.insert(0, "%d:" % hours)
	return string
