extends Control

const INACTIVE_IDX = -1;
export var AnalogTapToShow = false setget set_tap_to_show
export var AnalogTapToShowContainer = ""
export var mapAnalogToDpad = true

onready var ball = $ball
onready var animation_player = $AnimationPlayer
onready var halfSize = $bg.texture.get_size()/2

var active = false

var centerPoint = Vector2(0,0)
var currentForce = Vector2(0,0)
var ballPos = Vector2()
var squaredHalfSizeLength = 0
var currentPointerIDX = INACTIVE_IDX;


func _ready():
	if AnalogTapToShowContainer == "":
		AnalogTapToShowContainer = get_parent()
	
	map_analog_dpad()
	set_process_input(true)
	squaredHalfSizeLength = halfSize.x * halfSize.y

func get_force():
	return currentForce
	
func _input(event):
	var incomingPointer = extractPointerIdx(event)
	if incomingPointer == INACTIVE_IDX:
		return
	
	if need2ChangeActivePointer(event):
		if (currentPointerIDX != incomingPointer) and event.is_pressed():
			currentPointerIDX = incomingPointer;
			showAtPos(Vector2(event.position.x, event.position.y));

	if not Input.is_action_pressed("left_click"):
		active = false

	if event.is_action_pressed("left_click"):
		if event.is_pressed():
			active = true

	if isActive():
		process_input(event)

func need2ChangeActivePointer(event): #touch down inside analog	
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if AnalogTapToShow:
			return AnalogTapToShowContainer.get_global_rect().has_point(Vector2(event.position.x, event.position.y))
		else:
			var length = (rect_position - Vector2(event.position.x, event.position.y)).length_squared();
			return length < squaredHalfSizeLength
	else:
		return false

func isActive():
	return active

func extractPointerIdx(event):
	var touch = event is InputEventScreenTouch
	var drag = event is InputEventScreenDrag
	var mouseButton = event is InputEventMouseButton
	var mouseMove = event is InputEventMouseMotion
	
	if touch or drag:
		return 1
	elif mouseButton or mouseMove:
		return 0
	else:
		return INACTIVE_IDX

func process_input(event):
	calculateForce(event.position.x - rect_position.x, event.position.y - rect_position.y)
	updateBallPos()
	
	var isReleased = isReleased(event)
	if isReleased:
		reset()

func reset():
	currentPointerIDX = INACTIVE_IDX
	calculateForce(0, 0)

	if AnalogTapToShow:
		hide()
	else:
		updateBallPos()

func showAtPos(pos):
	rect_position = pos
	
func hide():
	pass

func updateBallPos():
	ballPos.x = halfSize.x * currentForce.x #+ halfSize.x
	ballPos.y = halfSize.y * -currentForce.y #+ halfSize.y
	ball.position = Vector2(ballPos.x, ballPos.y)

func isPressed(event):
	if event is InputEventMouseMotion:
		return (InputEventMouse.button_mask == 1)
	elif event is InputEventScreenTouch:
		return event.is_pressed()

func isReleased(event):
	if event is InputEventScreenTouch:
		return !event.is_pressed()
	elif event is InputEventMouseButton:
		return !event.is_pressed()

func calculateForce(var x, var y):
	#get direction
	currentForce.x = (x - centerPoint.x)/halfSize.x
	currentForce.y = -(y - centerPoint.y)/halfSize.y
	if currentForce.length_squared()>1:
		currentForce=currentForce/currentForce.length()
	
	sendSignal2Listener()

func set_tap_to_show(value):
	if value:
		modulate.a = 0
	
	AnalogTapToShow = value
		
func sendSignal2Listener():
	get_tree().call_group("JoyStick", "analog_signal_change", currentForce, self.get_name())
	if mapAnalogToDpad:
		map_analog_dpad()

func map_analog_dpad():
	simulate_input("ui_left") if currentForce.x < -0.2 else Input.action_release("ui_left")
	simulate_input("ui_right") if currentForce.x > 0.2 else Input.action_release("ui_right")
	simulate_input("ui_down") if currentForce.y < -0.2 else Input.action_release("ui_down")
	simulate_input("ui_up") if currentForce.y > 0.2 else Input.action_release("ui_up")
	if (abs(currentForce.x) < 0.2 and abs(currentForce.y) < 0.2):
		simulate_input("ui_stop")
	else:
		Input.action_release("ui_stop")

func simulate_input(value):
	var input = InputEventAction.new()
	input.action = value
	input.pressed = true
	Input.parse_input_event(input)
