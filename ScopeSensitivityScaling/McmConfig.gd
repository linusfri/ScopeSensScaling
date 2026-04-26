extends Node

var McmHelpers = preload("res://ModConfigurationMenu/Scripts/Doink Oink/MCM_Helpers.tres")
var scopeSensitivityScalingSettings = preload("res://ScopeSensitivityScaling/ScopeSensitivityScalingSettings.tres")

const MOD_ID = "ScopeSensitivityScaling"
const DIR_PATH = "user://MCM/ScopeSensitivityScaling"
const FILE_PATH = DIR_PATH + "/config.ini"

func _ready():
	var _config = ConfigFile.new()
	
	_config.set_value("Float", "MonitorDistancePercent", {
		"name" = "Monitor distance percent",
		"tooltip" = "The monitor percentage to scale the sensitivity to. If you know what this means, then you can change it. Otherwise you can leave it as is.",
		"default" = 0.75,
		"value" = 0.75,
		"minRange" = 0.0,
		"maxRange" = 1.0,
	})

	
	if !FileAccess.file_exists(FILE_PATH):
		if !DirAccess.dir_exists_absolute(DIR_PATH):
			DirAccess.make_dir_recursive_absolute(DIR_PATH)
		_config.save(FILE_PATH)
	else:
		McmHelpers.CheckConfigurationHasUpdated(MOD_ID, _config, FILE_PATH)

	var configFile = ConfigFile.new()
	if configFile.load(FILE_PATH) == OK:
		update_config_properties(configFile)

	McmHelpers.RegisterConfiguration(
		MOD_ID,
		"Scope Sensitivity Scaling",
		DIR_PATH,
		"Settings for Scope Sensitivity Scaling mod",
		{
            "config.ini" = update_config_properties
        }
	)

func update_config_properties(configFile: ConfigFile):
	scopeSensitivityScalingSettings.monitor_distance_percent = get_mcm_float(configFile, "Float", "MonitorDistancePercent", 0.75)

func get_mcm_float(config: ConfigFile, section: String, key: String, default: float) -> float:
	var data = config.get_value(section, key, default)
	if data is Dictionary:
		return float(data.get("value", default))
	return float(data)