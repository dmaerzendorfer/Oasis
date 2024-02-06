extends RayCast2D

@onready var line: Line2D = %Line
signal hit_by_river(object)
const _signalName: String = "hit_by_river"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	#dont update anything if flag is set or game is not focues
	if !Global.updateRiver || !Global.focused:
		return
	#iterate over line segments
	var hitSmth:bool = false
	for startNode in range(0,line.get_point_count()-1):
		# lay raycast into them
		self.global_position = line.to_global(line.get_point_position(startNode))
		self.target_position = self.to_local(line.to_global(line.get_point_position(startNode+1)))
		force_raycast_update()

		if is_colliding():
			#signal other thing that i hit smth, this seems ugly. or at least i dont fully understand signals yet...
			emit_signal(_signalName,get_collider())
			hitSmth = true
			# if it hits something set the end node of the segment to the hit location
			line.set_point_position(startNode+1,line.to_local(get_collision_point()))
			# and delete rest of nodes 
			# line.points.resize(startNode+1)
			# somehow resize leads to unexpected behaviour, therefore loop over the to be removed points and remove them starting from the back
			# (+2 since +1 for endNode and another +1 since we are indexes are starting with 0
			var x = range(startNode+2,line.get_point_count())
			for i in x:
				line.remove_point(line.get_point_count()-1)
			break

	#if overall no hits detected: elongate the lines last segment to hit the edge of the screen
	if !hitSmth:
		#figuring out the fancy math for this takes too long, i'm just gonna use the raycast for it :shrug:
		var dir: Vector2 = (line.points[-1]-line.points[-2]).normalized()
		self.global_position = line.points[-1]
		self.target_position = dir*Global.windowHeight
		force_raycast_update()
		if is_colliding():
			line.set_point_position(line.get_point_count()-1,line.to_local(get_collision_point()))
			#signal that i hit smth
			emit_signal(_signalName,get_collider())

