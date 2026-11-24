extends Node3D

const TOGGLE_ACTION := "Toggle"

@onready var top_view_camera: Camera3D = $TopViewCamera
@onready var player: CharacterBody3D = get_node("../Factory/ProtoController")
@onready var player_camera: Camera3D = get_node("../Factory/ProtoController/Head/Camera3D")

var showing_top_view := true


func _ready() -> void:
	if not InputMap.has_action(TOGGLE_ACTION):
		push_error("ViewCoordinator: Input action '%s' is missing from Project Settings > Input Map." % TOGGLE_ACTION)
		return
	_set_view(true)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(TOGGLE_ACTION) and not event.is_echo():
		_set_view(not showing_top_view)
		get_viewport().set_input_as_handled()


func _set_view(use_top_view: bool) -> void:
	showing_top_view = use_top_view
	top_view_camera.current = showing_top_view
	player_camera.current = not showing_top_view
	player.set_physics_process(not showing_top_view)
	player.set_process_unhandled_input(true)

	if showing_top_view:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if player.has_method("release_mouse"):
			player.release_mouse()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if player.has_method("capture_mouse"):
			player.capture_mouse()
