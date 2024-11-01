class_name GlobalDayNightCycle
extends Node

# Time variables
var hours: int = 6
var minutes: int = 0
var seconds: int = 0

# Time settings
var min_in_real_time = 1
var day_length: float = min_in_real_time * 60.0  # Total length of a day in seconds (5 minutes for a full day)
var time_speed: float = 1.0  # How fast time progresses (1.0 means real-time speed)
var total_time: float = 0.0  # Total elapsed time
enum cycleType {DAY, NIGHT}

# Directional Light (sun)
@export var sun: DirectionalLight3D
@export var sun_rotation_range: Vector2 = Vector2(-45, 45)  # Rotation range for the sun
@export var second_timer: Timer 


func _ready() -> void:
	if not second_timer:
		second_timer = Timer.new()
		second_timer.wait_time = 1.0  # 1 real-time second
		second_timer.autostart = true
		second_timer.one_shot = false  # Keep repeating
		add_child(second_timer)

# Called every frame
func _process(delta: float) -> void:
	# Update the in-game time
	update_time(delta)
	
	# Update sun rotation based on the time of day
	update_sun_rotation()
	print_day_or_night()

# Function to update the in-game time
func update_time(delta: float) -> void:
	var day_seconds = day_length * time_speed
	
	# Increase total time by delta (scaled by time_speed)
	total_time += delta * time_speed
	
	# Calculate in-game seconds from total_time using fposmod to handle float modulo
	var total_in_game_seconds = (fposmod(total_time, day_seconds) / day_seconds) * 86400  # A full day has 86400 seconds

	# Convert the total seconds into hours, minutes, and seconds
	hours = int(total_in_game_seconds / 3600) % 24
	minutes = int(total_in_game_seconds / 60) % 60
	seconds = int(total_in_game_seconds) % 60
	
	# Print or display the time (optional)
	#print("Time: %02d:%02d:%02d" % [hours, minutes, seconds])
	
# Function to print whether it is day or night
func print_day_or_night() -> void:
	if hours >= 6 and hours < 18:
		#print("It is day.")
		pass
	else:
		#print("It is night.")
		pass

# Function to update the sun's rotation based on time of day
func update_sun_rotation() -> void:
	# Calculate the percentage of the day that has passed (from 0 to 1)
	var day_progress = (hours * 3600 + minutes * 60 + seconds) / 86400.0
	
	# Map this percentage to the sun's rotation (from sunrise to sunset)
	var sun_angle = lerp(sun_rotation_range.x, sun_rotation_range.y, day_progress)
	
	# Set the sun's rotation in degrees (Y axis rotation remains the same)
	#sun.rotation_degrees.x = sun_angle


func get_current_date_time() -> String:
	var am_pm = "AM"
	var display_hour = hours
	if hours >= 12:
		am_pm = "PM"
		if hours > 12:
			display_hour = hours - 12  # Convert to 12-hour format
	elif hours == 0:
		display_hour = 12  # Midnight is 12 AM

	return "%02d:%02d:%02d %s" % [display_hour, minutes, seconds, am_pm]


func get_day_or_night() -> cycleType:
	var day_or_night: cycleType = cycleType.DAY
	if hours >= 12:
		day_or_night = cycleType.NIGHT
	return day_or_night
	
	
