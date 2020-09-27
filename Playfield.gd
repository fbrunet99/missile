# Playfield Scene
extends Node2D

const Missile = preload("res://Missile.tscn")
const Bomber = preload("res://Bomber.tscn")
const ICBM = preload("res://ICBM.tscn")

var rng = RandomNumberGenerator.new()

var ground_left = Vector2(0, 560)
var ground_right = Vector2(1200, 560)
var ground_color = Color(150, 150, 0)
var end_loc = Vector2(500, 100)
const delta_id = 2
const alpha_id = 1
const omega_id = 3
var delta_ammo = 10
var alpha_ammo = 10
var omega_ammo = 10
var delta_loc = Vector2(500, 535)
var alpha_loc = Vector2(100, 535)
var omega_loc = Vector2(900, 535)
var defendColor = Color(100, 0, 0)

var bomber_instance = null
var bomber_loc = Vector2(0,0)
var bomber_on = false
var bomber_reserve = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	initialize_bases()
	start_wave()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_alpha"):
		launch_missile(alpha_id, alpha_loc, 10)
	if Input.is_action_just_pressed("ui_delta"):
		launch_missile(delta_id, delta_loc, 15)
	if Input.is_action_just_pressed("ui_omega"):
		launch_missile(omega_id, omega_loc, 10)
	
	update_bomber()
	update_icbms()


func _draw():
	var ground = Rect2(ground_left, ground_right)
	draw_rect(ground, ground_color)

func start_wave():
	$Delta.set_color(ground_color)
	$Alpha.set_color(ground_color)
	$Omega.set_color(ground_color)
	set_stockpiles()
	bomber_reserve = 30

func update_bomber():
	if bomber_on:
		return

	if bomber_reserve > 0:
		var chance = rng.randf_range(0, 10000)
		if chance > 9800:
			print("I'm starting a bomber, chance was ", chance)
			bomber_instance = Bomber.instance()
			var height = rng.randf_range(100,300)
			add_child(bomber_instance)
			bomber_reserve -= 1
			bomber_on = true


func set_bomber_hit(object):
	print("playfield: I see that the bomber was hit")
	bomber_on = false
	
func set_bomber_over(object):
	print("playfield: I see the bomber got away")
	bomber_on = false

func update_icbms():
	var chance = rng.randf_range(0, 9000)
	if chance > 8900:
		var new_icbm = ICBM.instance()
		add_child(new_icbm)

func launch_missile(id, location, speed):
	if id == alpha_id:
		$Alpha.fire($Cursor.position, speed)
	elif id == delta_id:
		$Delta.fire($Cursor.position, speed)
	elif id == omega_id:
		$Omega.fire($Cursor.position, speed)


func initialize_bases():
	$Alpha.init(alpha_id, alpha_loc)
	$Delta.init(delta_id, delta_loc)
	$Omega.init(omega_id, omega_loc)

	$Delta.position = delta_loc + Vector2(0, 1)
	$Alpha.position = alpha_loc + Vector2(-10, 1)
	$Omega.position = omega_loc + Vector2(0, 1)
	
	set_stockpiles()
	
func set_stockpiles():
	$Alpha.set_ammo(alpha_ammo)
	$Delta.set_ammo(delta_ammo)
	$Omega.set_ammo(omega_ammo)

	
func _input(event):
	if event is InputEventMouseMotion:
		$Cursor.position = event.position


