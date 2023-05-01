extends CanvasLayer

var iv_item_scene = preload("res://scenes/gameplay/ui_inventory_item.tscn")

@onready var deployment_list = %DeploymentList
@onready var deploy_menu_root = %DeployMenuRoot

signal deploy_item(key)
signal exit_deploy()

# Called when the node enters the scene tree for the first time.
func _ready():
	for k in SaveGame.current.inventory:
		if SaveGame.current.inventory[k] > 0 and k in Deployables.infos:
			var item = iv_item_scene.instantiate()
			item.get_node("Labels/NameLabel").text = Deployables.infos[k].name
			item.get_node("Labels/CountLabel").text = "x%s" % SaveGame.current.inventory[k]
			item.clicked.connect(func (): _deploy_item(k))
			deployment_list.add_child(item)
	
	deploy_menu_root.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _deploy_item(key: String):
	if not key in Deployables.infos:
		return
	
	deploy_item.emit(key)
	

func _on_deploy_menu_root_exit():
	exit_deploy.emit()

func _on_player_ship_player_ship_damaged(amount):
	%PlayerHealthBar.frame = 15 - amount
