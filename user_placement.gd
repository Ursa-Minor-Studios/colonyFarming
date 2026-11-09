extends Node2D
###########################################################
###  SCRIPT SECTION #1: USER PLACEMENT
###  DESCRIPTION: Contains the user placement system
###########################################################

# List of preloaded assets for user placement
var potato = preload("res://Assets/Crops/Potato.tscn")
var carrot = preload("res://Assets/Crops/Carrot.tscn")

var buildingModes = ["SingleBuild", "Multi-Build", "Delete", "View"] # Array contining different building modes

# Declared Variables
var selectedCrop
var cropInstance
var currentBuildMode
var isActivelyBuilding: bool
var buildingPlaced: bool = true
var tileSize = Vector2(128, 128)
var crop = get_tree().get_nodes_in_group("Crops")
var mousePositon = get_global_mouse_position()
var targetNode
var can_place


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	can_place = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(buildingPlaced == false && isActivelyBuilding == true):
		cropInstance.position = get_global_mouse_position().snapped(tileSize)


func placementSystem():
	isActivelyBuilding = true
	if (isActivelyBuilding == true):
		if currentBuildMode != buildingModes[2] && currentBuildMode != buildingModes[3]:
			cropInstance = selectedCrop.instantiate()
			cropInstance.input_event.connect(_on_crop_clicked.bind(cropInstance))
			cropInstance.area_entered.connect(_on_area_entered.bind(cropInstance))
			$Game.add_child(cropInstance)

func _input(event):
	if event is InputEventMouseButton:
		if can_place == true:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				buildingPlaced = true
				if(currentBuildMode == buildingModes[0]):
					if(isActivelyBuilding == true):
						cropInstance.position = get_global_mouse_position().snapped(tileSize)
						isActivelyBuilding = false
					elif(currentBuildMode == buildingModes[1]):
						if(isActivelyBuilding == true):
							placementSystem()
						isActivelyBuilding = false
						cropInstance.position = get_global_mouse_position().snapped(tileSize)
						isActivelyBuilding = true

func _on_area_entered(viewport, event, shape_idx):
	queue_free()

# Runs when someone presses the delete button. Deletes the crop once someone clicks on it.
func _on_crop_clicked(viewport, event, shape_idx, unwanted_crop):
	if event is InputEventMouseButton and event.is_pressed() and currentBuildMode == buildingModes[2]:
		unwanted_crop.queue_free()

func _on_build_button_pressed() -> void:
	currentBuildMode = buildingModes[0]

func _on_multi_build_button_pressed() -> void:
	currentBuildMode = buildingModes[1]

func _on_delete_button_pressed() -> void:
	currentBuildMode = buildingModes[2]

func _on_view_button_pressed() -> void:
	currentBuildMode = buildingModes[3]

func _on_potato_button_pressed() -> void:
	selectedCrop = potato
	buildingPlaced = false
	placementSystem()

func _on_carrot_button_pressed() -> void:
	selectedCrop = carrot
	buildingPlaced = false
	placementSystem()
