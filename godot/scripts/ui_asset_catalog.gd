class_name UIAssetCatalog
extends RefCounted

const TROPHY_ICON: String = "res://assets/ui/icons/trophy.png"
const MENU_ICON: String = "res://assets/ui/icons/menu.png"
const PIZZA_ICON: String = "res://assets/ui/icons/pizza.png"

const ITEM_ICONS: Dictionary = {
	"visitor_badge": "res://assets/ui/items/visitor_badge.png",
	"vr_glasses": "res://assets/ui/items/vr_glasses.png",
	"executive_priority_stamp": "res://assets/ui/items/executive_priority_stamp.png",
	"third_party_proof": "res://assets/ui/items/third_party_proof.png",
	"fiscal_exception_protocol": "res://assets/ui/items/fiscal_exception_protocol.png",
	"maintenance_vest": "res://assets/ui/items/maintenance_vest.png",
	"work_order": "res://assets/ui/items/work_order.png",
	"legal_bolota_pending": "res://assets/ui/items/legal_bolota_approved.png",
	"legal_bolota_approved": "res://assets/ui/items/legal_bolota_approved.png"
}

static func load_texture(path: String) -> Texture2D:
	if path.is_empty() or not ResourceLoader.exists(path):
		return null
	var resource: Resource = load(path)
	if resource is Texture2D:
		return resource as Texture2D
	return null

static func item_texture(item_id: String) -> Texture2D:
	var path: String = str(ITEM_ICONS.get(item_id, ""))
	return load_texture(path)
