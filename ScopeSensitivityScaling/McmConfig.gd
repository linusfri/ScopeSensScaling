extends Node

var McmHelpers = preload("res://ModConfigurationMenu/Scripts/Doink Oink/MCM_Helpers.tres")
const MOD_ID = "ScopeSensitivityScaling"
const FILE_PATH = "user://MCM/ScopeSensitivityScaling"

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

	
	if !FileAccess.file_exists(FILE_PATH + "/config.ini"):
		if !DirAccess.dir_exists_absolute(FILE_PATH):
			DirAccess.make_dir_recursive_absolute(FILE_PATH)
		_config.save(FILE_PATH + "/config.ini")
	else:
		McmHelpers.CheckConfigurationHasUpdated(MOD_ID, _config, FILE_PATH + "/config.ini")
	
	McmHelpers.RegisterConfiguration(
		MOD_ID,
		"Scope Sensitivity Scaling",
		FILE_PATH,
		"Settings for Scope Sensitivity Scaling mod",
		{
            "config.ini" = UpdateConfigProperties
        }
	)

# Taken from https://modworkshop.net/mod/55962
func get_mcm_float(config: ConfigFile, section: String, key: String, default: float) -> float:
	var data = config.get_value(section, key, default)
	if data is Dictionary:
		return float(data.get("value", default))
	return float(data)

func UpdateConfigProperties(config: ConfigFile):
	return get_mcm_float(config, "Float", "MonitorDistancePercent", 0.75)

func get_monitor_distance_percent() -> float:
	var config = ConfigFile.new()
	config.load(FILE_PATH + "/config.ini")
	return get_mcm_float(config, "Float", "MonitorDistancePercent", 0.75)