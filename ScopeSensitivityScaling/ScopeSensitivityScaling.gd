extends Node

const PREFERENCES_PATH = "user://Preferences.tres"

var gameData = preload("res://Resources/GameData.tres")
var scopeSensitivityScalingSettings = preload("res://ScopeSensitivityScaling/ScopeSensitivityScalingSettings.tres")

var preferences: Preferences

func _ready() -> void:
	await get_tree().process_frame
	_load_preferences()

func _load_preferences():
	if ResourceLoader.exists("user://Preferences.tres"):
		preferences = ResourceLoader.load(PREFERENCES_PATH, "", ResourceLoader.CACHE_MODE_REUSE) as Preferences

func _process(_delta):
	# Setup
	if not preferences:
		_load_preferences()
		return

	var camera_node = get_viewport().get_camera_3d()
	if not camera_node:
		return

	# Mod logic
	scale_scope_sensitivity(camera_node)

func scale_scope_sensitivity(camera_node: Camera3D):
	if gameData.PIP: return

	if not gameData.isScoped:
		gameData.scopeSensitivity = preferences.scopeSensitivity
		return

	var scope_fov = camera_node.fov
	var base_fov = preferences.baseFOV

	if base_fov <= 0.0 || scope_fov <= 0.0:
		return

	# Source: https://www.kovaak.com/sens-scaling
	var monitor_distance_percent = scopeSensitivityScalingSettings.monitor_distance_percent
	var sensitivity_scaling_factor = calculate_scaling_factor(scope_fov, base_fov, monitor_distance_percent)

	gameData.scopeSensitivity = preferences.scopeSensitivity * sensitivity_scaling_factor

func calculate_scaling_factor(scope_fov: float, base_fov: float, monitor_distance_percent: float):
	var scope_fov_as_half_radians = deg_to_rad(scope_fov / 2)
	var base_fov_as_half_radians = deg_to_rad(base_fov / 2)

	# As monitor_distance_percent approaches 0, there is no need to calculate the arctangent
	# See the readme for a link to an example calculation.
	if monitor_distance_percent <= 0:
		return tan(scope_fov_as_half_radians) / tan(base_fov_as_half_radians)
	else:
		return atan(monitor_distance_percent * tan(scope_fov_as_half_radians)) / atan(monitor_distance_percent * tan(base_fov_as_half_radians))