class_name Card
extends Reference

var initiative: int

var data
var effect


func get_data_id():
	var split_path = data.resource_path.split(".tres")[0].split("/")
	return split_path[split_path.size() - 1]
