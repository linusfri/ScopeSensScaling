extends Node

var gameData = preload("res://Resources/GameData.tres")

var preferences: Preferences

func _ready() -> void:
	await get_tree().process_frame
	_load_preferences()

func _load_preferences():
	if ResourceLoader.exists("user://Preferences.tres"):
		preferences = ResourceLoader.load("user://Preferences.tres", "", ResourceLoader.CACHE_MODE_REUSE) as Preferences

func _process(_delta):
	# Setup
	if not preferences:
		_load_preferences()
		return

	var camera_node = get_viewport().get_camera_3d()
	if not camera_node:
		return

	# Scaling logic
	scale_scope_sensitivity(camera_node)

func scale_scope_sensitivity(camera_node: Camera3D):
	# Don't scale if we have PIP scopes enabled
	if gameData.PIP: return

	if not gameData.isScoped:
		gameData.scopeSensitivity = preferences.scopeSensitivity
		return

	var scope_fov_half_rad = deg_to_rad(camera_node.fov / 2.0)
	var base_fov_half_rad = deg_to_rad(preferences.baseFOV / 2.0)

	if base_fov_half_rad <= 0.0 || scope_fov_half_rad <= 0:
		return

	# This is using focal length scaling to try to preserve
	# percieved mouse sensitivity regardless of zoom level
	# Source:  https://www.kovaak.com/sens-scaling
	var monitor_distance_percent = 0.75 # Percentage as decimal value
	var sensitivity_scaling_factor = atan(monitor_distance_percent * tan(scope_fov_half_rad)) / atan(monitor_distance_percent * tan(base_fov_half_rad))
	gameData.scopeSensitivity = preferences.scopeSensitivity * sensitivity_scaling_factor