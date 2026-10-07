extends Node2D

const Walkable = preload("res://scripts/walkable_catalog.gd")
var area: String = ""

func _draw() -> void:
	if area.is_empty(): return
	draw_rect(Rect2(0,0,1672,941), Color(0.9,0.12,0.12,0.12))
	for polygon: PackedVector2Array in Walkable.floor_polygons(area):
		draw_colored_polygon(polygon, Color(0.1,0.95,0.35,0.26))
		var outline: PackedVector2Array = polygon.duplicate()
		outline.append(polygon[0])
		draw_polyline(outline, Color(0.2,1.0,0.4,0.9), 2.0)
	for polygon: PackedVector2Array in Walkable.obstacle_polygons(area):
		draw_colored_polygon(polygon, Color(1.0,0.15,0.15,0.28))
		var outline: PackedVector2Array = polygon.duplicate()
		outline.append(polygon[0])
		draw_polyline(outline, Color(1.0,0.3,0.2,0.9), 2.0)
	var position: Vector2 = PlayerController._image_position
	draw_circle(position, Walkable.FOOT_CLEARANCE, Color(1.0,0.9,0.1,0.7))
	if PlayerController._moving:
		var route: PackedVector2Array = [position,PlayerController._target_image_position]
		route.append_array(PlayerController._path)
		draw_polyline(route, Color(0.8,0.9,1.0,1.0), 3.0)
