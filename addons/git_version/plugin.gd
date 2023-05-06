@tool
extends EditorPlugin

const PROJECT_SETTING_NAME: String = "application/config/git_version/version"

var _exporter: GitVersionInjector

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		_exporter = (GitVersionInjector as Variant).new()
		add_export_plugin(_exporter)

func _exit_tree() -> void:
	if _exporter:
		remove_export_plugin(_exporter)

class GitVersionInjector extends EditorExportPlugin:
	func _get_name():
		return "GitVersion"
	
	func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> void:
		var version = _git_describe()
		print("Export version: ", version)
		ProjectSettings.set_setting(PROJECT_SETTING_NAME, version)
	
	func _export_end():
		ProjectSettings.set_setting(PROJECT_SETTING_NAME, null)
	
	func _git_describe() -> String:
		var output: Array = []
		OS.execute("git", PackedStringArray(["describe", "--long", "--always"]), output)
		if output.is_empty() or output[0].is_empty():
			push_error("Failed to fetch version. Make sure you have git installed and project is inside a valid git directory.")
			return "unknown"
		return output[0].trim_suffix("\n")

