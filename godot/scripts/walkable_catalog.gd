class_name WalkableCatalog
extends RefCounted

const Geometry = preload("res://scripts/walkable_geometry.gd")
const FOOT_CLEARANCE: float = 12.0
const CORNER_MARGIN: float = 3.0
static var _cache: Dictionary = {}

static func _polygon(values: Array) -> PackedVector2Array:
	var result: PackedVector2Array = []
	for value: Array in values:
		result.append(Vector2(value[0], value[1]))
	return result

static func _geometry(area: String) -> Dictionary:
	if area == "ti_systems_room": area = "ti_server_room"
	if _cache.has(area): return _cache[area]
	if not Geometry.AREAS.has(area): return {}
	var data: Dictionary = Geometry.AREAS[area]
	var raw_floor: PackedVector2Array = _polygon(data["floor"])
	var floors: Array[PackedVector2Array] = Geometry2D.offset_polygon(raw_floor, -FOOT_CLEARANCE, Geometry2D.JOIN_MITER)
	var obstacles: Array[PackedVector2Array] = []
	for object: Dictionary in data["obstacles"]:
		obstacles.append_array(Geometry2D.offset_polygon(_polygon(object["polygon"]), FOOT_CLEARANCE, Geometry2D.JOIN_MITER))
	var box: Rect2 = Rect2(raw_floor[0], Vector2.ZERO)
	for point: Vector2 in raw_floor: box = box.expand(point)
	var result: Dictionary = {"floors":floors, "obstacles":obstacles, "bounds":box, "graph":null}
	_cache[area] = result
	return result

static func bounds(area: String) -> Rect2:
	return _geometry(area).get("bounds", Rect2())

static func floor_polygons(area: String) -> Array:
	return _geometry(area).get("floors", [])

static func obstacle_polygons(area: String) -> Array:
	return _geometry(area).get("obstacles", [])

static func is_walkable(area: String, point: Vector2) -> bool:
	var data: Dictionary = _geometry(area)
	var inside: bool = false
	for floor_polygon: PackedVector2Array in data.get("floors", []):
		if Geometry2D.is_point_in_polygon(point, floor_polygon):
			inside = true
			break
	if not inside: return false
	for obstacle: PackedVector2Array in data.get("obstacles", []):
		if Geometry2D.is_point_in_polygon(point, obstacle): return false
	return true

static func _boundaries(area: String) -> Array:
	var result: Array = floor_polygons(area).duplicate()
	result.append_array(obstacle_polygons(area))
	return result

static func clear_segment(area: String, a: Vector2, b: Vector2) -> bool:
	if not is_walkable(area, a) or not is_walkable(area, b): return false
	if a.distance_squared_to(b) < 0.0001: return true
	for polygon: PackedVector2Array in _boundaries(area):
		for i: int in range(polygon.size()):
			var crossing: Variant = Geometry2D.segment_intersects_segment(a, b, polygon[i], polygon[(i + 1) % polygon.size()])
			if crossing != null and a.distance_squared_to(crossing) > 0.0001 and b.distance_squared_to(crossing) > 0.0001:
				return false
	return is_walkable(area, (a + b) * 0.5)

static func _corner_points(area: String, vertex: Vector2) -> Array[Vector2]:
	var valid: Array[bool] = []
	for i: int in range(16):
		valid.append(is_walkable(area, vertex + Vector2.from_angle(TAU * float(i) / 16.0) * CORNER_MARGIN))
	var result: Array[Vector2] = []
	for i: int in range(16):
		if not valid[i] or valid[(i + 15) % 16]: continue
		var length: int = 1
		while length < 16 and valid[(i + length) % 16]: length += 1
		var index: int = (i + int((length - 1) / 2.0)) % 16
		result.append(vertex + Vector2.from_angle(TAU * float(index) / 16.0) * CORNER_MARGIN)
	return result

static func _graph(area: String) -> AStar2D:
	var data: Dictionary = _geometry(area)
	if data.is_empty(): return AStar2D.new()
	if data["graph"] != null: return data["graph"]
	var polygons: Array = _boundaries(area)
	var vertices: PackedVector2Array = []
	for polygon: PackedVector2Array in polygons: vertices.append_array(polygon)
	# Furniture can meet a wall or another object; include those union corners.
	for p: int in range(polygons.size()):
		var first: PackedVector2Array = polygons[p]
		for q: int in range(p + 1, polygons.size()):
			var second: PackedVector2Array = polygons[q]
			for i: int in range(first.size()):
				for j: int in range(second.size()):
					var crossing: Variant = Geometry2D.segment_intersects_segment(first[i], first[(i + 1) % first.size()], second[j], second[(j + 1) % second.size()])
					if crossing != null: vertices.append(crossing)
	var points: PackedVector2Array = []
	for vertex: Vector2 in vertices:
		for candidate: Vector2 in _corner_points(area, vertex):
			var duplicate: bool = false
			for existing: Vector2 in points:
				if existing.distance_squared_to(candidate) < 1.0:
					duplicate = true
					break
			if not duplicate: points.append(candidate)
	var graph: AStar2D = AStar2D.new()
	for i: int in range(points.size()): graph.add_point(i + 2, points[i])
	for i: int in range(points.size()):
		for j: int in range(i + 1, points.size()):
			if clear_segment(area, points[i], points[j]): graph.connect_points(i + 2, j + 2)
	data["graph"] = graph
	return graph

static func safe_point(area: String, point: Vector2) -> Vector2:
	if is_walkable(area, point): return point
	var best: Vector2 = Vector2.INF
	var distance: float = INF
	for polygon: PackedVector2Array in _boundaries(area):
		for i: int in range(polygon.size()):
			var closest: Vector2 = Geometry2D.get_closest_point_to_segment(point, polygon[i], polygon[(i + 1) % polygon.size()])
			for direction: int in range(8):
				var candidate: Vector2 = closest + Vector2.from_angle(TAU * float(direction) / 8.0) * CORNER_MARGIN
				var cost: float = candidate.distance_squared_to(point)
				if cost < distance and is_walkable(area, candidate):
					best = candidate
					distance = cost
	if best.is_finite(): return best
	# Overlapping furniture may bury the nearest edge. Never return a wall.
	var graph: AStar2D = _graph(area)
	for id: int in graph.get_point_ids():
		var candidate: Vector2 = graph.get_point_position(id)
		var cost: float = candidate.distance_squared_to(point)
		if cost < distance:
			best = candidate
			distance = cost
	return best

static func spawn(area: String) -> Vector2:
	var key: String = "ti_server_room" if area == "ti_systems_room" else area
	var values: Array = Geometry.AREAS.get(key, {}).get("spawn", [836, 820])
	return safe_point(area, Vector2(values[0], values[1]))

static func approach(area: String, label: String, fallback: Vector2) -> Vector2:
	var key: String = "ti_server_room" if area == "ti_systems_room" else area
	var values: Array = Geometry.AREAS.get(key, {}).get("approaches", {}).get(label, [])
	return safe_point(area, Vector2(values[0], values[1]) if values.size() == 2 else fallback)

static func path(area: String, start: Vector2, target: Vector2) -> PackedVector2Array:
	start = safe_point(area, start)
	target = safe_point(area, target)
	if not start.is_finite() or not target.is_finite(): return PackedVector2Array()
	if clear_segment(area, start, target): return PackedVector2Array([start, target])
	var graph: AStar2D = _graph(area)
	var ids: PackedInt64Array = graph.get_point_ids()
	graph.add_point(0, start)
	graph.add_point(1, target)
	for id: int in ids:
		var vertex: Vector2 = graph.get_point_position(id)
		if clear_segment(area, start, vertex): graph.connect_points(0, id)
		if clear_segment(area, target, vertex): graph.connect_points(1, id)
	var result: PackedVector2Array = graph.get_point_path(0, 1)
	graph.remove_point(0)
	graph.remove_point(1)
	return result
