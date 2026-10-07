extends RefCounted

const Walkable = preload("res://scripts/walkable_catalog.gd")
const Geometry = preload("res://scripts/walkable_geometry.gd")
const Hotspots = preload("res://scripts/hotspot_catalog.gd")
# Independent visual probes: walls, fronts of furniture, and foreground props.
const BLOCKED: Dictionary = {
	"reception":[[650,500],[1200,550],[180,820],[830,200]],
	"innovation":[[690,600],[890,680],[1490,715],[500,300]],
	"ti":[[500,525],[1070,530],[310,780],[1520,850],[1250,500]],
	"communication":[[730,620],[510,810],[1100,810],[1510,840],[770,300]],
	"supplies":[[610,715],[1020,750],[1600,720],[1290,910],[850,300]],
	"hall":[[840,640],[445,585],[1220,610],[840,300]],
	"finance":[[520,615],[430,730],[1060,820],[630,850],[600,400]],
	"engineering":[[745,700],[1050,750],[1550,695],[50,900],[680,300]],
	"security":[[910,700],[359,711],[540,765],[1330,845],[810,300],[290,680],[460,690]],
	"rh":[[780,650],[445,665],[450,875],[1550,795],[800,300]],
	"documentation":[[810,540],[1250,550],[1300,840],[350,825],[845,300]],
	"legal":[[600,670],[1110,760],[1300,875],[90,865],[920,300]],
	"directorate":[[880,620],[425,610],[1150,620],[320,900],[1540,775]],
	"reception_waiting_room":[[600,630],[480,680],[1270,590],[130,680],[1580,850]],
	"reception_auditorium":[[720,550],[1290,720],[1580,830],[200,850],[710,300]],
	"innovation_meeting_room":[[1050,625],[930,850],[637,765],[1580,600],[300,885]],
	"ti_server_room":[[750,635],[1150,746],[1450,859],[230,900],[620,300]],
	"ti_service_desk":[[750,610],[1360,741],[325,850],[1560,820],[760,300]],
	"rh_time_control":[[960,650],[486,540],[300,560],[1610,680],[820,300]],
	"rh_third_party_registration":[[560,590],[1230,620],[240,840],[1460,721],[900,300]],
	"documentation_archive_reprography":[[200,600],[550,660],[1120,630],[1560,820],[500,900]]
}

static func _points(polygon: PackedVector2Array) -> Array:
	var result: Array = []
	for point: Vector2 in polygon: result.append([point.x, point.y])
	return result

static func _sampled_safe(area: String, route: PackedVector2Array) -> bool:
	if route.is_empty(): return false
	for i: int in range(route.size() - 1):
		var steps: int = maxi(1, int(ceil(route[i].distance_to(route[i + 1]) / 4.0)))
		for sample: int in range(steps + 1):
			if not Walkable.is_walkable(area, route[i].lerp(route[i + 1], float(sample) / float(steps))): return false
	return true

static func run(qa: Node) -> void:
	var report: Dictionary = {}
	for area: String in Hotspots.BACKGROUNDS:
		if area == "menu": continue
		await qa.fresh(area)
		var key: String = "ti_server_room" if area == "ti_systems_room" else area
		qa.check("collision_catalog_" + area, Geometry.AREAS.has(key))
		var start: Vector2 = PlayerController._image_position
		qa.check("collision_spawn_" + area, Walkable.is_walkable(area, start))
		var row: Dictionary = {"background":Hotspots.BACKGROUNDS[area], "floor":[], "obstacles":[], "spawn":[start.x,start.y], "routes":[], "unreachable":[]}
		for polygon: PackedVector2Array in Walkable.floor_polygons(area): row["floor"].append(_points(polygon))
		for polygon: PackedVector2Array in Walkable.obstacle_polygons(area): row["obstacles"].append(_points(polygon))
		var valid: bool = true
		for point: Array in BLOCKED[key]:
			valid = valid and not Walkable.is_walkable(area, Vector2(point[0], point[1]))
		qa.check("collision_visual_probes_" + area, valid)
		valid = true
		var free_count: int = 0
		for y: int in range(570, 924, 44):
			for x: int in range(42, 1640, 64):
				var target: Vector2 = Vector2(x,y)
				if not Walkable.is_walkable(area, target): continue
				free_count += 1
				var route: PackedVector2Array = Walkable.path(area, start, target)
				if not _sampled_safe(area, route):
					valid = false
					row["unreachable"].append([x,y])
		qa.check("collision_connected_floor_" + area, valid and free_count > 0)
		if not valid: print("UNREACHABLE ", area, " ", JSON.stringify(row["unreachable"]))
		var bg: TextureRect = PlayerController._find_background(qa)
		for node: Node in qa.get_children():
			if not node is Button or not bool(node.get_meta("world_hotspot",false)): continue
			var button: Button = node as Button
			if not button.is_visible_in_tree(): continue
			var fallback: Vector2 = PlayerController._screen_to_image(bg, button.position + Vector2(button.size.x * 0.5, button.size.y * 0.92))
			var target: Vector2 = Walkable.approach(area, button.tooltip_text, fallback)
			var route: PackedVector2Array = Walkable.path(area,start,target)
			qa.check("collision_interaction_" + area + "_" + button.tooltip_text, _sampled_safe(area,route))
			row["routes"].append({"label":button.tooltip_text, "target":[target.x,target.y], "points":_points(route)})
		# Old saves inside a newly blocked counter must resolve onto free floor.
		var probe: Array = BLOCKED[key][0]
		PlayerController.restore_snapshot({"area":area,"position":probe,"direction":"up"})
		await qa.frames()
		qa.check("collision_old_save_" + area, Walkable.is_walkable(area, PlayerController._image_position))
		# Fast traversal still uses the path's corrected endpoint.
		SettingsManager.set_value("reduced_motion",true)
		PlayerController._move_to(Vector2(probe[0], probe[1]))
		qa.check("collision_reduced_motion_" + area, Walkable.is_walkable(area, PlayerController._image_position))
		SettingsManager.set_value("reduced_motion",false)
		report[area] = row
	var file: FileAccess = FileAccess.open("res://qa/collision_maps.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(report,"\t"))
	file.close()
	await movement_checks(qa)
	await entry_checks(qa)
	await overlay_checks(qa)

static func overlay_checks(qa: Node) -> void:
	await qa.fresh()
	var key: InputEventKey = InputEventKey.new()
	key.keycode = KEY_F4
	key.pressed = true
	Input.parse_input_event(key)
	await qa.frames(2)
	key.pressed = false
	Input.parse_input_event(key)
	var overlay: Node2D = DebugTools.navigation_overlay
	qa.check("collision_debug_keyboard", DebugTools.navigation_visible and is_instance_valid(overlay) and overlay.visible and overlay.get("area") == "reception")
	SceneRouter.route_to("innovation_meeting_room")
	await qa.frames()
	var bg: TextureRect = PlayerController._find_background(qa)
	overlay = DebugTools.navigation_overlay
	qa.check("collision_debug_scene_fit", is_instance_valid(overlay) and overlay.get("area") == GameState.current_area and overlay.position.is_equal_approx(bg.position) and overlay.scale.is_equal_approx(bg.size / Vector2(bg.texture.get_size())))
	key.pressed = true
	Input.parse_input_event(key)
	await qa.frames(2)
	key.pressed = false
	Input.parse_input_event(key)
	qa.check("collision_debug_disabled", not DebugTools.navigation_visible and not overlay.visible)

static func movement_checks(qa: Node) -> void:
	for area: String in ["reception","communication","finance","innovation_meeting_room","documentation","security"]:
		await qa.fresh(area)
		var row: Dictionary = Geometry.AREAS[area]
		var destinations: Array = row["approaches"].values()
		var bg: TextureRect = PlayerController._find_background(qa)
		var valid: bool = true
		var arrivals: int = 0
		for values: Array in destinations:
			var called: Array[bool] = [false]
			PlayerController._pending_callback = func(): called[0] = true
			PlayerController._move_to(Vector2(values[0], values[1]))
			for step: int in range(360):
				var previous: Vector2 = PlayerController._image_position
				PlayerController._update_movement(0.025, bg)
				valid = valid and Walkable.clear_segment(area, previous, PlayerController._image_position)
				if not PlayerController._moving: break
			await qa.frames(1)
			if called[0]: arrivals += 1
		qa.check("collision_animated_movement_" + area, valid and arrivals == destinations.size())
	await qa.fresh()
	SettingsManager.set_value("reduced_motion",true)
	var bg: TextureRect = PlayerController._find_background(qa)
	var source: Vector2 = Vector2(390,200)
	var screen: Vector2 = bg.position + source * (bg.size / Vector2(bg.texture.get_size()))
	var click: InputEventMouseButton = InputEventMouseButton.new()
	click.position = screen
	click.global_position = screen
	click.button_index = MOUSE_BUTTON_LEFT
	click.pressed = true
	qa.get_viewport().push_input(click,true)
	await qa.frames(2)
	click.pressed = false
	qa.get_viewport().push_input(click,true)
	await qa.frames()
	qa.check("collision_wall_mouse_click",Walkable.is_walkable("reception",PlayerController._image_position) and PlayerController._image_position.distance_to(Walkable.safe_point("reception",source)) < 1.0)
	SettingsManager.set_value("reduced_motion",false)

static func entry_checks(qa: Node) -> void:
	SettingsManager.set_value("reduced_motion",true)
	for area: String in SubareaManager.SUBAREAS:
		await qa.fresh(area)
		var button: Button = null
		for child: Node in qa.get_children():
			if child is Button and child.get_meta("world_hotspot",false) and child.tooltip_text.begins_with("Voltar"): button = child
		if button != null: button.pressed.emit()
		await qa.frames(8)
		var parent: String = SubareaManager.SUBAREAS[area]["parent"]
		qa.check("collision_return_" + area, GameState.current_area == parent and Walkable.is_walkable(parent, PlayerController._image_position))
	for entry: Array in [["reception","Sala de Espera","reception_waiting_room"],["reception","Auditório","reception_auditorium"],["innovation","Sala de Reunião","innovation_meeting_room"],["ti","Sala de Servidores","ti_server_room"],["ti","Sala de Sistemas","ti_systems_room"],["ti","Service Desk","ti_service_desk"],["rh","Controle de Ponto","rh_time_control"],["rh","Cadastro de Terceiros","rh_third_party_registration"],["documentation","Impressora / Cópias","documentation_archive_reprography"]]:
		await qa.fresh(entry[0])
		var button: Button = null
		for child: Node in qa.get_children():
			if child is Button and child.get_meta("world_hotspot",false) and child.tooltip_text == entry[1]: button = child
		if button != null: button.pressed.emit()
		await qa.frames(8)
		qa.check("collision_enter_" + entry[2],GameState.current_area == entry[2] and Walkable.is_walkable(entry[2], PlayerController._image_position))
	SettingsManager.set_value("reduced_motion",false)
