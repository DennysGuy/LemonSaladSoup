class_name TimeDecrementLabel extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var time : int
@onready var rich_text_label: RichTextLabel = $RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rich_text_label.text = "[font_size=24]%s[/font_size][font_size=16]sec.[/font_size]" % [time]

	animation_player.play("float")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
