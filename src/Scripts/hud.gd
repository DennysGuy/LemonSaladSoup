class_name HUD extends CanvasLayer

@onready var marker_2d: Marker2D = $Marker2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.add_rifle_preview.connect(add_rifle_unlock_overlay)
	SignalBus.remove_rifle_preview.connect(remove_rifle_unlock_overlay)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func add_rifle_unlock_overlay() -> void:
	var rifle_preview : RiflePreview = preload("uid://c4mt18ooxip2a").instantiate()
	add_child(rifle_preview)


func remove_rifle_unlock_overlay() -> void:
	var preview = get_tree().get_first_node_in_group("RiflePreview")
	preview.queue_free()
