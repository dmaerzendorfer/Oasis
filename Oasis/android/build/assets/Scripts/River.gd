extends Node2D

@export var minAccX: float = 0.03 
@export var tiltSpeed: float = 250

@onready var line: Line2D = %Line


var controlLine: bool = false
var addedPointIndex: int = -1

var pressStartPos: Vector2

func _ready():
	Global.updateRiver = true

func _input(event):
	if !Global.updateRiver:
		return
	if(event is InputEventScreenTouch):
		if event.pressed:
			#pressed first time, add point to line
			addPointToLine(event.position)
			controlLine = true
		elif !event.pressed:
			#press was released
			#play sound
			$"/root/SfxPlayer".playReleaseSound()
			controlLine = false
			addedPointIndex = -1
	if(event is InputEventScreenDrag && controlLine):
		#add relative drag to all the subsequent points of the line
		var deltaX = event.relative.x
		xShiftSubsequentNodes(addedPointIndex+2, deltaX)
			
			
func _process(delta):
	# dont read accel if flag is not set or if game is not focues
	if !Global.updateRiver || !Global.focused:
		return
	if controlLine && Settings.get_setting("gameplay","useGyro"):
		var acc = Input.get_accelerometer().normalized()
		if(abs(acc.x) > minAccX):
			if(acc.x < 0):
				xShiftSubsequentNodes(addedPointIndex+2,-tiltSpeed*delta)
			else:
				xShiftSubsequentNodes(addedPointIndex+2,tiltSpeed*delta)
				

func xShiftSubsequentNodes(startIndex:int, xAddition: float):
	for pointIndex in range(startIndex, %Line.get_point_count()):
			var point = %Line.get_point_position(pointIndex)
			point.x += xAddition
			%Line.set_point_position(pointIndex,point)

func addPointToLine(pressPosition: Vector2):
	#iterate segments of line
	var closestPoint:Vector2 = %Line.to_global(%Line.get_point_position(0)) 
	var closestPrefPointIndex = 0
	var closestDistance = 1.79769e308
	
	for startIndex in range(0,%Line.get_point_count()-1):
		var endIndex = startIndex+1
		var endPoint = %Line.to_global(%Line.get_point_position(endIndex))
		var startPoint = %Line.to_global(%Line.get_point_position(startIndex))
		
		#get closest point to segment
		var point = Geometry2D.get_closest_point_to_segment(pressPosition,startPoint,endPoint)
		var dist = point.distance_to(pressPosition)
		#update closest point if so
		if dist < closestDistance:
			closestPoint = point
			closestDistance = dist
			closestPrefPointIndex = startIndex
	
	closestPoint = %Line.to_local(closestPoint)
	#add point to line, inserts before the closesPrefPoint...
	%Line.add_point(closestPoint, closestPrefPointIndex+1)
	addedPointIndex = closestPrefPointIndex
	
	
	
