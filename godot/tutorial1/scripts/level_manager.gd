extends Node

func get_max_level() -> int:
	var level_file = FileAccess.get_file_as_string("res://data/levels.json")
	var json_data = JSON.parse_string(level_file)
	
	if json_data is Dictionary:
		return json_data["max_level"]
	
	return 0

func unlock_level(level: int):
	var level_file = FileAccess.get_file_as_string("res://data/levels.json")
	var json_data = JSON.parse_string(level_file)
	
	if json_data is Dictionary:
		json_data["max_level"] = level
	
	var json_data_string = JSON.stringify(json_data)
	FileAccess.open("res://data/levels.json", FileAccess.WRITE).store_line(json_data_string)
