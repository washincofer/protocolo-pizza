class_name WalkableCatalog
extends RefCounted
const FLOORS: Dictionary = {
	"reception":Rect2(30,570,1610,335),"reception_waiting_room":Rect2(80,575,1500,330),"reception_auditorium":Rect2(60,550,1550,350),
	"innovation":Rect2(45,575,1590,330),"innovation_meeting_room":Rect2(40,610,1580,295),
	"ti":Rect2(30,570,1610,335),"ti_server_room":Rect2(40,630,1580,275),"ti_service_desk":Rect2(40,680,1580,225),"ti_systems_room":Rect2(40,630,1580,275),
	"communication":Rect2(30,560,1610,355),"supplies":Rect2(40,610,1580,305),"hall":Rect2(40,620,1580,295),
	"finance":Rect2(40,570,1580,345),"engineering":Rect2(40,620,1580,295),"security":Rect2(40,610,1580,305),
	"rh":Rect2(40,610,1580,305),"rh_time_control":Rect2(40,650,1580,265),"rh_third_party_registration":Rect2(40,670,1580,245),
	"documentation":Rect2(40,610,1580,305),"documentation_archive_reprography":Rect2(40,680,1580,235),"legal":Rect2(40,640,1580,275),"directorate":Rect2(40,620,1580,295)
}
const OBSTACLES: Dictionary = {
	"reception":[Rect2(500,570,270,105)],"innovation":[Rect2(670,575,300,100)],"communication":[Rect2(420,600,240,245)],
	"supplies":[Rect2(395,610,425,125)],"hall":[Rect2(329,620,290,35)],"finance":[Rect2(850,570,380,120)],
	"engineering":[Rect2(540,620,300,85)],"security":[Rect2(747,610,311,55)],"rh":[Rect2(640,610,330,85)],
	"documentation":[Rect2(620,610,350,80)],"legal":[Rect2(1030,640,340,65)],"directorate":[Rect2(700,620,310,100)]
}
static func bounds(area: String) -> Rect2:
	return FLOORS.get(area,Rect2(40,620,1580,295))
static func safe_point(area: String,point: Vector2) -> Vector2:
	var floor_rect: Rect2 = bounds(area)
	point = point.clamp(floor_rect.position+Vector2.ONE*2,floor_rect.end-Vector2.ONE*2)
	for obstacle: Rect2 in OBSTACLES.get(area,[]):
		if obstacle.has_point(point):
			var options: Array[Vector2] = [Vector2(obstacle.position.x-3,point.y),Vector2(obstacle.end.x+3,point.y),Vector2(point.x,obstacle.position.y-3),Vector2(point.x,obstacle.end.y+3)]
			var best: Vector2 = point
			var distance: float = INF
			for candidate: Vector2 in options:
				if floor_rect.has_point(candidate) and candidate.distance_to(point) < distance:
					best = candidate
					distance = candidate.distance_to(point)
			point = best
	return point
static func clear_segment(area: String,a: Vector2,b: Vector2) -> bool:
	for rect: Rect2 in OBSTACLES.get(area,[]):
		if rect.has_point(a) or rect.has_point(b): return false
		var corners: Array[Vector2] = [rect.position,Vector2(rect.end.x,rect.position.y),rect.end,Vector2(rect.position.x,rect.end.y)]
		for i: int in range(4):
			if Geometry2D.segment_intersects_segment(a,b,corners[i],corners[(i+1)%4]) != null: return false
	return true
static func path(area: String,start: Vector2,target: Vector2) -> PackedVector2Array:
	start = safe_point(area,start)
	target = safe_point(area,target)
	var points: Array[Vector2] = [start,target]
	var floor_rect: Rect2 = bounds(area)
	for obstacle: Rect2 in OBSTACLES.get(area,[]):
		var rect: Rect2 = obstacle.grow(4)
		for p: Vector2 in [rect.position,Vector2(rect.end.x,rect.position.y),rect.end,Vector2(rect.position.x,rect.end.y)]:
			if floor_rect.has_point(p): points.append(p)
	var graph: AStar2D = AStar2D.new()
	for i: int in range(points.size()): graph.add_point(i,points[i])
	for i: int in range(points.size()):
		for j: int in range(i+1,points.size()):
			if clear_segment(area,points[i],points[j]): graph.connect_points(i,j)
	return graph.get_point_path(0,1)
