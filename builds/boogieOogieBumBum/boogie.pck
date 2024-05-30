GDPC                0                                                                         P   res://.godot/exported/133200997/export-2ddd04d543d5858e7f20c9299a8b5096-main.scn $            ��xM:��h����
0    ,   res://.godot/global_script_class_cache.cfg  �:            ��Р�8���8~$}P�    P   res://.godot/imported/bouncer_sketch.png-7d31320024dd3930eda9cc7ab4928e72.ctex  `U      ʧ      F��0����]s.�    H   res://.godot/imported/floor2.png-4393d21020c08eab7ab135b5fce9b317.ctex   �            �6�`Ya��Y�����    D   res://.godot/imported/icon.svg-3e7551201e48388aad76de708eac4068.ctex0            ：Qt�E�cO���    D   res://.godot/imported/icon.svg-b67cfb692a937e61d2bda8561d9e8db7.ctex��            ：Qt�E�cO���    P   res://.godot/imported/pirouette_sketch.png-f8d10a5f1b8fe97eb0b156240e7825cd.ctex�     �+     m���
����6˩�       res://.godot/uid_cache.bin  �>     �       ���J��u�Ow��9       res://Scenes/main.gd0?      ;      �p�Xe�[�	8�|       res://Scenes/main.tscn.remapp:     a       F�����X�����       res://Scripts/Bully.gd  p@      �      �Fj����~:暞�o�       res://Scripts/Player.gd  G      5      ��ժ�����<~�       res://Scripts/QueenAlt.gd   @L       	      �`�{}�p��r��y&    (   res://Sprites/bouncer_sketch.png.import 0�      �       �y�����%;,��88        res://Sprites/floor2.png.import �      �       K����/[�=�4���       res://Sprites/icon.svg   ;     �      k����X3Y���f        res://Sprites/icon.svg.import         �       ���H�k��O�L+�    ,   res://Sprites/pirouette_sketch.png.import   �9     �       �D�ȋ;�\�ux�I    $   res://builds/boogy/Scenes/main.gd           ;      �p�Xe�[�	8�|    $   res://builds/boogy/Scripts/Bully.gd @      �      �Fj����~:暞�o�    $   res://builds/boogy/Scripts/Player.gd�      5      ��ժ�����<~�    (   res://builds/boogy/Scripts/QueenAlt.gd         	      �`�{}�p��r��y&    ,   res://builds/boogy/Sprites/icon.svg.import  P#      �       pmZ��A�_q���       res://project.binary�?     �       nI�y}}��븖y��K            extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Restart"):
		get_tree().reload_current_scene()

     extends Node2D
@onready var tile_map = $"../TileMap"
@onready var button = $Button
var speed
@export var startingDir = Vector2i.UP

var directionRegular = Vector2.UP
var directionDash = Vector2.RIGHT
var direction
var rushSpeed
var isRushing = false
@export var normalSpeed = 50
@export var horizontalMovement: bool = false

var dashLeftRight: bool = true
### Tiles
var currentTile
var nextTile
var previousTile
var tile_dataCurrent: TileData 
var tile_dataNext: TileData
var tile_dataPrevious: TileData




# Called when the node enters the scene tree for the first time.
func _ready():
	#Sets starting Variables
	rushSpeed = 10 * normalSpeed
	speed = normalSpeed
	direction = directionRegular

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Input
	if Input.is_action_just_pressed("up"):
		isRushing = true
		speed = rushSpeed
		direction = directionDash
		
	global_position += direction * delta * speed

	checkWall()

func checkWall():
	GetTiles()
	
	if tile_dataCurrent.get_custom_data("back") == true:
		if isRushing:
			isRushing = false
			speed = normalSpeed
			global_position = tile_map.map_to_local(previousTile)
			directionDash = - directionDash
		else:
			directionRegular = - directionRegular
		direction = directionRegular
		
func GetTiles():
	var directionI = Vector2i(direction)
	
	currentTile = tile_map.local_to_map(global_position)
	nextTile = currentTile + directionI
	previousTile = currentTile - directionI
	
	tile_dataCurrent 	= tile_map.get_cell_tile_data(0,currentTile)
	tile_dataNext 		= tile_map.get_cell_tile_data(0,nextTile)
	tile_dataPrevious 	= tile_map.get_cell_tile_data(0,previousTile)

     extends Node2D
@onready var tile_map = $"../TileMap"
@onready var timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("up"):
		move(Vector2.UP)
	elif Input.is_action_just_pressed("down"):
		move(Vector2.DOWN)
	elif Input.is_action_just_pressed("left"):
		move(Vector2.LEFT)
	elif Input.is_action_just_pressed("right"):
		move(Vector2.RIGHT)

func move(direction: Vector2):
	
	# Get cur Tile
	var currentTile: Vector2i = tile_map.local_to_map(global_position)
	#Get target Tile
	var targetTile : Vector2i = Vector2i(
		currentTile.x + direction.x,
		currentTile.y + direction.y
		)
		
	#Custome DataLayer
	var tile_data: TileData = tile_map.get_cell_tile_data(0,targetTile)
	
	if tile_data.get_custom_data("dance") == false:
		return
	#Move
	global_position = tile_map.map_to_local(targetTile)


func _on_timer_timeout():
	var randomDir = randi_range(0,3)
	if randomDir == 0:
		move(Vector2.UP)
	elif  randomDir ==1:
		move(Vector2.DOWN)
	elif  randomDir ==2:
		move(Vector2.LEFT)
	elif  randomDir ==3:
		move(Vector2.RIGHT)
		


func _on_bully_body_entered(body):
	body.queue_free()
	pass # Replace with function body.
           extends Node2D
@onready var tile_map = $"../TileMap"
@onready var timer = $Timer
var direction
@export var speed = 20
@export var topX: int = 6
var bottomX
@export var topY: int = 6
var bottomY
var pastDirection



# Called when the node enters the scene tree for the first time.
func _ready():
	pastDirection = direction
	bottomX = -1
	bottomY = -1
	
	
	#get Top && Bottom Values
	
	setRandomDir()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if Input.is_action_just_pressed("up"):
		#move(Vector2.UP)
	#elif Input.is_action_just_pressed("down"):
		#move(Vector2.DOWN)
	#elif Input.is_action_just_pressed("left"):
		#move(Vector2.LEFT)
	#elif Input.is_action_just_pressed("right"):
		#move(Vector2.RIGHT)
	move()
	global_position += delta *speed * direction
	
	if(pastDirection != direction):
		pastDirection = direction
	
	
	

func move(): #direction: Vector2
	#if speed ==0:
		#return
	## Get cur Tile
	#var currentTile: Vector2i = tile_map.local_to_map(global_position)
	##Get target Tile
	#var targetTile : Vector2i = Vector2i(
		#currentTile.x + direction.x,
		#currentTile.y + direction.y
		#)
		#
	##Custome DataLayer
	#var tile_data: TileData = tile_map.get_cell_tile_data(0,targetTile)
	#
	#if tile_data.get_custom_data("dance") == false:
		#return
	##Move
	#global_position = tile_map.map_to_local(targetTile)
	
	#get current tile
	var currentTile: Vector2i = tile_map.local_to_map(global_position)
	
	#var nextTile = currentTile + Vector2i(direction)
	
	var tile_data: TileData = tile_map.get_cell_tile_data(0,currentTile)
	if tile_data.get_custom_data("dance") == false:
		if currentTile.x <= bottomX or currentTile.x >= topX:
			direction.x = -direction.x
		if currentTile.y <= bottomY or currentTile.y >= topY:
			direction.y = -direction.y
		#global_position += direction * (Vector2.ONE * 5)


#func _on_timer_timeout():
	#var randomDir = randi_range(0,3)
	#if randomDir == 0:
		#move(Vector2.UP)
	#elif  randomDir ==1:
		#move(Vector2.DOWN)
	#elif  randomDir ==2:
		#move(Vector2.LEFT)
	#elif  randomDir ==3:
		#move(Vector2.RIGHT)
		
func setRandomDir():
	direction = Vector2(randf_range(-1,1), randf_range(-1,1))


func _on_bully_body_entered(body):
	#Game Over Stuff
	#get_tree().quit()
	pass # Replace with function body.
GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�m�m۬�}�p,��5xi�d�M���)3��$�V������3���$G�$2#�Z��v{Z�lێ=W�~� �����d�vF���h���ڋ��F����1��ڶ�i�엵���bVff3/���Vff���Ҿ%���qd���m�J�}����t�"<�,���`B �m���]ILb�����Cp�F�D�=���c*��XA6���$
2#�E.@$���A.T�p )��#L��;Ev9	Б )��D)�f(qA�r�3A�,#ѐA6��npy:<ƨ�Ӱ����dK���|��m�v�N�>��n�e�(�	>����ٍ!x��y�:��9��4�C���#�Ka���9�i]9m��h�{Bb�k@�t��:s����¼@>&�r� ��w�GA����ը>�l�;��:�
�wT���]�i]zݥ~@o��>l�|�2�Ż}�:�S�;5�-�¸ߥW�vi�OA�x��Wwk�f��{�+�h�i�
4�˰^91��z�8�(��yޔ7֛�;0����^en2�2i�s�)3�E�f��Lt�YZ���f-�[u2}��^q����P��r��v��
�Dd��ݷ@��&���F2�%�XZ!�5�.s�:�!�Њ�Ǝ��(��e!m��E$IQ�=VX'�E1oܪì�v��47�Fы�K챂D�Z�#[1-�7�Js��!�W.3׹p���R�R�Ctb������y��lT ��Z�4�729f�Ј)w��T0Ĕ�ix�\�b�9�<%�#Ɩs�Z�O�mjX �qZ0W����E�Y�ڨD!�$G�v����BJ�f|pq8��5�g�o��9�l�?���Q˝+U�	>�7�K��z�t����n�H�+��FbQ9���3g-UCv���-�n�*���E��A�҂
�Dʶ� ��WA�d�j��+�5�Ȓ���"���n�U��^�����$G��WX+\^�"�h.���M�3�e.
����MX�K,�Jfѕ*N�^�o2��:ՙ�#o�e.
��p�"<W22ENd�4B�V4x0=حZ�y����\^�J��dg��_4�oW�d�ĭ:Q��7c�ڡ��
A>��E�q�e-��2�=Ϲkh���*���jh�?4�QK��y@'�����zu;<-��|�����Y٠m|�+ۡII+^���L5j+�QK]����I �y��[�����(}�*>+���$��A3�EPg�K{��_;�v�K@���U��� gO��g��F� ���gW� �#J$��U~��-��u���������N�@���2@1��Vs���Ŷ`����Dd$R�":$ x��@�t���+D�}� \F�|��h��>�B�����B#�*6��  ��:���< ���=�P!���G@0��a��N�D�'hX�׀ "5#�l"j߸��n������w@ K�@A3�c s`\���J2�@#�_ 8�����I1�&��EN � 3T�����MEp9N�@�B���?ϓb�C��� � ��+�����N-s�M�  ��k���yA 7 �%@��&��c��� �4�{� � �����"(�ԗ�� �t�!"��TJN�2�O~� fB�R3?�������`��@�f!zD��%|��Z��ʈX��Ǐ�^�b��#5� }ى`�u�S6�F�"'U�JB/!5�>ԫ�������/��;	��O�!z����@�/�'�F�D"#��h�a �׆\-������ Xf  @ �q�`��鎊��M��T�� ���0���}�x^�����.�s�l�>�.�O��J�d/F�ě|+^�3�BS����>2S����L�2ޣm�=�Έ���[��6>���TъÞ.<m�3^iжC���D5�抺�����wO"F�Qv�ږ�Po͕ʾ��"��B��כS�p�
��E1e�������*c�������v���%'ž��&=�Y�ް>1�/E������}�_��#��|������ФT7׉����u������>����0����緗?47�j�b^�7�ě�5�7�����|t�H�Ե�1#�~��>�̮�|/y�,ol�|o.��QJ rmϘO���:��n�ϯ�1�Z��ը�u9�A������Yg��a�\���x���l���(����L��a��q��%`�O6~1�9���d�O{�Vd��	��r\�՜Yd$�,�P'�~�|Z!�v{�N�`���T����3?DwD��X3l �����*����7l�h����	;�ߚ�;h���i�0�6	>��-�/�&}% %��8���=+��N�1�Ye��宠p�kb_����$P�i�5�]��:��Wb�����������ě|��[3l����`��# -���KQ�W�O��eǛ�"�7�Ƭ�љ�WZ�:|���є9�Y5�m7�����o������F^ߋ������������������Р��Ze�>�������������?H^����&=����~�?ڭ�>���Np�3��~���J�5jk�5!ˀ�"�aM��Z%�-,�QU⃳����m����:�#��������<�o�����ۇ���ˇ/�u�S9��������ٲG}��?~<�]��?>��u��9��_7=}�����~����jN���2�%>�K�C�T���"������Ģ~$�Cc�J�I�s�? wڻU���ə��KJ7����+U%��$x�6
�$0�T����E45������G���U7�3��Z��󴘶�L�������^	dW{q����d�lQ-��u.�:{�������Q��_'�X*�e�:�7��.1�#���(� �k����E�Q��=�	�:e[����u��	�*�PF%*"+B��QKc˪�:Y��ـĘ��ʴ�b�1�������\w����n���l镲��l��i#����!WĶ��L}rեm|�{�\�<mۇ�B�HQ���m�����x�a�j9.�cRD�@��fi9O�.e�@�+�4�<�������v4�[���#bD�j��W����֢4�[>.�c�1-�R�����N�v��[�O�>��v�e�66$����P
�HQ��9���r�	5FO� �<���1f����kH���e�;����ˆB�1C���j@��qdK|
����4ŧ�f�Q��+�     [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://dpcjhop6gth7t"
path="res://.godot/imported/icon.svg-3e7551201e48388aad76de708eac4068.ctex"
metadata={
"vram_texture": false
}
                RSRC                    PackedScene            ��������                                            >      resource_local_to_scene    resource_name    texture    margins    separation    texture_region_size    use_texture_padding    0:0/0    0:0/0/custom_data_0    0:0/0/script    1:0/0    1:0/0/custom_data_0    1:0/0/script    2:0/0    2:0/0/custom_data_2    2:0/0/script    3:0/0    3:0/0/custom_data_2    3:0/0/script    0:1/0    0:1/0/custom_data_0    0:1/0/script    1:1/0    1:1/0/custom_data_0    1:1/0/script    2:1/0    2:1/0/custom_data_2    2:1/0/script    3:1/0    3:1/0/custom_data_2    3:1/0/script    0:2/0    0:2/0/custom_data_1    0:2/0/script    1:2/0    1:2/0/custom_data_1    1:2/0/script    0:3/0    0:3/0/custom_data_1    0:3/0/script    1:3/0    1:3/0/custom_data_1    1:3/0/script    script    tile_shape    tile_layout    tile_offset_axis 
   tile_size    uv_clipping    custom_data_layer_0/name    custom_data_layer_0/type    custom_data_layer_1/name    custom_data_layer_1/type    custom_data_layer_2/name    custom_data_layer_2/type 
   sources/0    tile_proxies/source_level    tile_proxies/coords_level    tile_proxies/alternative_level    custom_solver_bias    size 	   _bundled       Script    res://Scenes/main.gd ��������
   Texture2D    res://Sprites/floor2.png r{���n   Script    res://Scripts/QueenAlt.gd ��������
   Texture2D #   res://Sprites/pirouette_sketch.png ����2j   Script    res://Scripts/Player.gd ��������   Script    res://Scripts/Bully.gd ��������
   Texture2D !   res://Sprites/bouncer_sketch.png �|��F��I   !   local://TileSetAtlasSource_388dd ]         local://TileSet_htc6d 	         local://RectangleShape2D_ubx10 �	         local://RectangleShape2D_v0m7t �	         local://RectangleShape2D_qsycm �	         local://PackedScene_csnnv '
         TileSetAtlasSource &                                  	      
                                                                                                                                                                                                   !      "          #         $      %          &         '      (          )         *      +         TileSet    1         dance 2         3      	   security 4         5         back 6         7             +         RectangleShape2D    <   
      A   A+         RectangleShape2D    <   
     �A  �A+         RectangleShape2D    <   
     `A  pA+         PackedScene    =      	         names "   "      Level    script    Node2D 	   Camera2D 	   position    scale    offset    zoom    TileMap 	   tile_set    format    layer_0/tile_data    Queen    collision_layer    CharacterBody2D 	   Sprite2D    texture    Timer 
   wait_time 
   autostart    CollisionShape2D    shape    minis 	   modulate    minis2    minis3    minis4    Bully    collision_mask    Area2D    _on_timer_timeout    timeout    _on_bully_body_entered    body_entered    	   variants    #             
     �B  �B
   ���=���=
   
W�H��
   H�@H�@                   �  ����         ��        ��        ��        ��        ��        ��        ��                                                                                                                              ��        ��        ��                  ��        ��        ��        ��                                                                                                                                                                                                                                                                                                                                               ����      ����        ��       ��       ��       ��       ��       ��       ��       ��       ��                                                                                                                                ��       ��       ��       ��       ��       ��       ��       ��       ��        ����      ����      ����      ����        ��       ��       ��       ��       ��       ��       ��       ��       ��       ��       ��                                                                                                                                                ��       ��       ��       ��       ��       ��       ��       ��       ��       ��       ��        ����      ����      
     DB  �A
     �?  �?               
   ���<���<               @      
       qU�?            ��%>��%>��%>  �?
     �B   B
   ��L?��L?         
          ?              �E
     �A  �B
      A   A
     �B  �@
     ��  �B               
          ?         
    �<�$�<               node_count             nodes     @  ��������       ����                            ����                                             ����   	      
                              ����            	      
                          ����                                ����                                ����                                 ����                                                  ����                                ����                                ����                                 ����                                                  ����                                ����                                ����                                 ����                                                  ����                                ����                                ����                                 ����                                                  ����                                ����                                ����                                 ����                                      ����                                 ����      !      "             conn_count             conns     *   
                                                                                                  !                        !                        node_paths              editable_instances              version       +      RSRC              extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Restart"):
		get_tree().reload_current_scene()

     extends Node2D
@onready var tile_map = $"../TileMap"
@onready var button = $Button
var speed
@export var startingDir = Vector2i.UP

var directionRegular = Vector2.UP
var directionDash = Vector2.RIGHT
var direction
var rushSpeed
var isRushing = false
@export var normalSpeed = 50
@export var horizontalMovement: bool = false

var dashLeftRight: bool = true
### Tiles
var currentTile
var nextTile
var previousTile
var tile_dataCurrent: TileData 
var tile_dataNext: TileData
var tile_dataPrevious: TileData




# Called when the node enters the scene tree for the first time.
func _ready():
	#Sets starting Variables
	rushSpeed = 10 * normalSpeed
	speed = normalSpeed
	direction = directionRegular

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Input
	if Input.is_action_just_pressed("up"):
		isRushing = true
		speed = rushSpeed
		direction = directionDash
		
	global_position += direction * delta * speed

	checkWall()

func checkWall():
	GetTiles()
	
	if tile_dataCurrent.get_custom_data("back") == true:
		if isRushing:
			isRushing = false
			speed = normalSpeed
			global_position = tile_map.map_to_local(previousTile)
			directionDash = - directionDash
		else:
			directionRegular = - directionRegular
		direction = directionRegular
		
func GetTiles():
	var directionI = Vector2i(direction)
	
	currentTile = tile_map.local_to_map(global_position)
	nextTile = currentTile + directionI
	previousTile = currentTile - directionI
	
	tile_dataCurrent 	= tile_map.get_cell_tile_data(0,currentTile)
	tile_dataNext 		= tile_map.get_cell_tile_data(0,nextTile)
	tile_dataPrevious 	= tile_map.get_cell_tile_data(0,previousTile)

     extends Node2D
@onready var tile_map = $"../TileMap"
@onready var timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("up"):
		move(Vector2.UP)
	elif Input.is_action_just_pressed("down"):
		move(Vector2.DOWN)
	elif Input.is_action_just_pressed("left"):
		move(Vector2.LEFT)
	elif Input.is_action_just_pressed("right"):
		move(Vector2.RIGHT)

func move(direction: Vector2):
	
	# Get cur Tile
	var currentTile: Vector2i = tile_map.local_to_map(global_position)
	#Get target Tile
	var targetTile : Vector2i = Vector2i(
		currentTile.x + direction.x,
		currentTile.y + direction.y
		)
		
	#Custome DataLayer
	var tile_data: TileData = tile_map.get_cell_tile_data(0,targetTile)
	
	if tile_data.get_custom_data("dance") == false:
		return
	#Move
	global_position = tile_map.map_to_local(targetTile)


func _on_timer_timeout():
	var randomDir = randi_range(0,3)
	if randomDir == 0:
		move(Vector2.UP)
	elif  randomDir ==1:
		move(Vector2.DOWN)
	elif  randomDir ==2:
		move(Vector2.LEFT)
	elif  randomDir ==3:
		move(Vector2.RIGHT)
		


func _on_bully_body_entered(body):
	body.queue_free()
	pass # Replace with function body.
           extends Node2D
@onready var tile_map = $"../TileMap"
@onready var timer = $Timer
var direction
@export var speed = 20
@export var topX: int = 6
var bottomX
@export var topY: int = 6
var bottomY
var pastDirection



# Called when the node enters the scene tree for the first time.
func _ready():
	pastDirection = direction
	bottomX = -1
	bottomY = -1
	
	
	#get Top && Bottom Values
	
	setRandomDir()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if Input.is_action_just_pressed("up"):
		#move(Vector2.UP)
	#elif Input.is_action_just_pressed("down"):
		#move(Vector2.DOWN)
	#elif Input.is_action_just_pressed("left"):
		#move(Vector2.LEFT)
	#elif Input.is_action_just_pressed("right"):
		#move(Vector2.RIGHT)
	move()
	global_position += delta *speed * direction
	
	if(pastDirection != direction):
		pastDirection = direction
	
	
	

func move(): #direction: Vector2
	#if speed ==0:
		#return
	## Get cur Tile
	#var currentTile: Vector2i = tile_map.local_to_map(global_position)
	##Get target Tile
	#var targetTile : Vector2i = Vector2i(
		#currentTile.x + direction.x,
		#currentTile.y + direction.y
		#)
		#
	##Custome DataLayer
	#var tile_data: TileData = tile_map.get_cell_tile_data(0,targetTile)
	#
	#if tile_data.get_custom_data("dance") == false:
		#return
	##Move
	#global_position = tile_map.map_to_local(targetTile)
	
	#get current tile
	var currentTile: Vector2i = tile_map.local_to_map(global_position)
	
	#var nextTile = currentTile + Vector2i(direction)
	
	var tile_data: TileData = tile_map.get_cell_tile_data(0,currentTile)
	if tile_data.get_custom_data("dance") == false:
		if currentTile.x <= bottomX or currentTile.x >= topX:
			direction.x = -direction.x
		if currentTile.y <= bottomY or currentTile.y >= topY:
			direction.y = -direction.y
		#global_position += direction * (Vector2.ONE * 5)


#func _on_timer_timeout():
	#var randomDir = randi_range(0,3)
	#if randomDir == 0:
		#move(Vector2.UP)
	#elif  randomDir ==1:
		#move(Vector2.DOWN)
	#elif  randomDir ==2:
		#move(Vector2.LEFT)
	#elif  randomDir ==3:
		#move(Vector2.RIGHT)
		
func setRandomDir():
	direction = Vector2(randf_range(-1,1), randf_range(-1,1))


func _on_bully_body_entered(body):
	#Game Over Stuff
	#get_tree().quit()
	pass # Replace with function body.
GST2            ����                        ��  RIFF��  WEBPVP8L}�  /���0h�HR��?��{ D��o�#,Il�#	��F{�5m��-��;��m�+D� �`i{�6IZ[�U��z�=��M��G0����m�_P�pbV��14�}�1h�h�
3�U�3�;.��������9�hѳ͂�0�Ő�W�2333s�������{��򮁴mCo�y�m[um��ffΞk���ЖEՂG�G133\�$٦mk<�\�ٶ}�l�ڶm_���k�6�6�^	Q���͹P!�
�s����w�H������k��1�5o#��8E�P��ƻ�0��*ڨ����ɹ�~��������9y�y�JwҶ�_s϶mI�$I�Bmld`  .Jì-��lk[��my���5ޜ�eff�?*33��̨1sY��S\�Rp�pb��Lv䘄�%Q�m���a�ht�'�{��a�?[I��Zbf�9D��S!h�@��(*
"8�C���#/z6������^���t;��Y33��o��4,�X�y=���m m����n�v�������޹�� �(�.�����|�|�1*��\�ٶ���[�����A#8U6p�3;�cg۶~���}��@��(���Da�����Oq$۶~�/�<�336wf�e����`0�f��<Fsw(B))A	�̜))K)�0��?w���e6��@ڶ���}m۞4۶��P�� 
�B��l�a���z���5�*Ƕ�c{����:��?���J��Ie��K۶*WN���!ڶT�ؘf�3B������Rm�'qa�vɀc)�GHĦ[�h�3V�:b�yڄc?�c��q<Ά�����k��~��m��?7�mm��F۶Z���^}{��͍$� lBl�`�(P�m�-@۶�M�Cw88lqwj3�,V��ڜ��;mqww��S|��Jp���n�Z�m6�nv�����_%�
��\0BBD����/��?����������������Q�����V�k��G{��]q��v��^��q�+޻�7�"� k9q[�k�Ǜ��5 ��V���,��=���Y�3I�[�1R�����c��-uS�[���]��i������K{~6��Q��k���T��R.�5�e�ˤW���V������@i|iݰ�>^�w��+�7��K��ݛK{֏���Y;�k�u᭝�n�e��=JǺ��w��]{Ǽi_#��t�)K��R�R�J�:&-�bkqm�����X�s�����3����V�U�$x��8V��YR$�,�6�++�7�뺫v�s���`:<yH�
;U�)�:��f5�6�X�vl-��ІQ�����H{M��3�F����}���vͩ8PYq����37Q���Z��IK�!U����l�k�=���0RH`���$+�d�Ϗ+�h�z��tkR����
 P�"�-#=E ��梨�b�&U�,C[��6z2A�ٵ�Q�;����R��I,u�ً�Lc%�X�^,w'���b,&UL�Vf҂n��њV�ެ@�3Z�F��-|q���R��:�A7�i��H1�r�����D[#/���۾Mc{��~u�*L�t�O�׮a�a�a+
�&H� �)�uc} �S�Om�z�BE�.t��L&Y�($	��u��w��b�ꗺhXŤy�����կdڴ�i�b�ꗻ��9�3cO�}'ն�m�Զ�V�������YR���w+�is �]T�V�]��Y�܅.�5�5"f�#�����p8}�2�[�1�[�ͺ[k�]��I=_ꅟ.��B*�W�����] ���͒TU�y��궭~�U���� n�L�=l]��Qy5�^Q�Emw���//}���R.U���rdj�������6޿q�� �Y�(WB�	��z��[ek��7����%��s��ڋa1�ʪNC�N% ��->��u2�IcA���z{��^�R����t,�)���3�;n.�C���  ��c
�,��������D�����T��n�p9ue0xҒ>��wZt3�0��D���j:,�K�6t��# E�Qs��Y���ǱF׌�"
l�0�mK{ `����ㅾ #p��j�,���i/t��c��1^ �������%�b�#�sY3i�:ZteRul <R��3K  ��.�i�Ka  �Gzv����yb�g��@7�Г ]��z��R).��&��8Iꓭ/��ڎ��BQ�K���3 mx��3��� '���q$2�.VV9O�K��7�VW���T�ߴ�oK��`{C�Fձ�
��]j�_潥���Y�vW/uk�%���qv08;�y��0���()��߳Ԑ�)�I��TRu�x�������Grh�\������I& � ���!�R�R��-�����>���Z4)#�;P@ ��J�'J����U�%�ij�f�o1v-�  `����h��f%n�� ��u��ϛItcTT׎�R�s��R��n�/�c�` ���Z���D��-�A�A>
"��X�������C�.�`�����ij�_�^� �=;Ʈ;���N�[�����g���?d�����Z��g� "�e�� ��g��Q�n��S9�����Sd��w.�H�v]~r��]B����P���������{�>#��+��b�vz����qoa$����^կ���\�k��`0�~��S���S���aa�;���u_  H3*���%��w���%��60���3���|�p��շ�kw����Y7t�	�^կno�-~Ҳ������Z�1^t�x*�;�1鬾�.zӢX�wG`�6�{*'��Y�����d���՝���ղ�;�I4Z�1iѐ�N�Nm@�؀�[6���]zr�1�E�X��En�=�Y�wv�h�|`=ȿqoӮ�m���k�$oYu�k;�v�J�8j�t��$�bK�"���C�X� �Eh�Y�w�0�<���0��������
���p1�_���/��? �XIci�2�k�Z�Mj���!|Ȼ��$��� ��`p����}]b���쩂N�JxR�K�˱�n'�i����QG$�6����Z��m�SHp��H�`��,5���p<ӡP V��)�3�E�;�����]<XBjH��k���2������ʺ���hEr{��hњ
#�!��:B�bO�ȩyB��<���+��䴅<<%����vͽ�ӥ����K��ͩ��h�K{��0�F�� ��Z��(�B�D6Bq�I�6t�D�%�g��̹sA�`)��߂\O�x�\���b���m?kk����bEKH�Fm�]:H
��y�Ԃ~�A�J�$P�q�S_=���
��:�>���gZ�ҷ����!��qP����H�C���6)ʍQl�A�B�X�R��J��� @�0�k �"�����$���]��i#��{�9��@��=� |�:�� �<5��<5#r�Eku#R���Q
� �Zi �s��%���������1pl��'6�m{M?iI�'[���l<�4>�Q�X���K#QP�$
17�J=���@���g���P'bFq��QE�F�:�i;�ٚ�[�#XP�A`�Z�o���M�����7���7���h�
�@�� �7ẹNo@s�/Wx��2T]!9�(:r�yG�ԉ g�F7�����o��F�,g�@��~�����Ag���aM��å�����]�(���fu��ʻs0�`�UCȷ(Qh� ih���&��I��d"�	}>Ԍ!�	��ӥ^l��iB�F�3UG��� t�UF�J�-�׾{���प�}o�u]��0�*+
��"5C(Y�(Bb�&J�P��"T&3�U��Pm#� 0H{�X�o�	�@�!�g��T5�ʉ6D���271_�V(6m,�]�e��t�Э���Б=k�����?���˩Yh�=� �",Q��Ϊ'#NH���UO*�4UtA+0�*���Lfދ6,B��	��GVwB��Ʋ��r�[������m��T��0|o��yp9�
J� �H	0����?-BU��ʻ�b�k4��L��` �)B�HH&]��� /�;SD�����;��1��7N�u��]5`tmG+>a{���&�>�e������b0���i8J�Da��Ek6-Y�t��.b$��H0x��GLt�)�Js�%����Fn�q�=˂����6ڙ8  ���p���`���!�2�e�Ș�����X�]�@r�u������5�"<oZa�b�ș���B���fL��/0�'�` ���#c���� @$Y�����/�h�05-1*�Y�ZGD���Y�(Yh���8D08D����R�9�q��LoY�d�jj��6�q#��ݚ��Q��h���Cd%�E����� H�MO�\��Je��Ƽ��1�xW�i SJOY_b�a=C+��;��&�hsG�m��S�9"~b������E���t��Ne�hՅ�+�|��eޱu�[����B<��ڭ���)�<*#�è�ܣ�~�S���
���y���?�Zt��n_P!� �h��,�l��,!5f�k��{�f�3"-��T�<��R���	�.5I��ۆ A�m���������!@��)7c�塯-Rc���)#&Z�b�g��ִt]��@�Z��Y)��Vr�B��A�_�<�
�)ױ���H��ܲ-V� ���� ?�󐝇Eɔ�ud1B�j����k7�捺�(jnR�@�幚aR\'��;�ٿl�_ꖁy�Q��ވ5��Xei)��:!�!�y���ԑ7�Lea�,��o��VQTP��Q�**�/�Q�߁mVu�R�/5�JJ[0h�<�k����aӵj0���)�S
�
Z�k*R���rTuA�H��PͰ�n_z���X�#���\jG`^ݤN��E��`(�iR t�&~��<����a�'CF�y��.�2��I�RX� ����݀5fU߰��!N�Ӥ���7��#�U�U�V�Jb0ۄ�����@UԒ�������ٱD�#�%��7�q>5��9"�Q�p~��`2� ��ͬB�<f��N�c%���4��/R5�L$�X/:sk�ę� A,Q���s�M�H���O�b.C���!�;�J-\
#@u1mk),��z�&Í<�  L(��O��e��/+Zx�8F�nߐ��� � �0�[�2�H�_���eX�����-��o�C�&m���+)L�i���oZQ�t�FQ���h�s�M܄; J�Ĭ�l:��&��!�. ��I*�5�'���P%��K6i�:Z���k�ɎQ1�K0���>�	s$���
�"�9=庛�2���4�AWRއ#�8�;U"ߏ\a�����L�s�o7#`L����5���j���jx�!�1�&��0V:U�d���2���&�Ur��"Q xWN�5_�N�ݏ\f��7L ��1�h�[MRI%�N�}O�����]% ����[�W�	�B�������](�Z�>;n�SZ�d��6�lPz_Ak�Ur)0.����G��Q�Wo�n%�&�f���go3�nF�夫z��H�o8iLQj���o�ex�!�X��v7)�薸%���؃�*#p��3Z2JB�����,�  '�UZ�č;bq{���Rj>��6���7���2�<�Q!�OrJ�g;�4G��U1G��M�+��B$!e��}8[�B@y�i����UY�CX= @�Ϋ��I�S'.��&��\ �v�Q�XB�8Q�|p1�n�mF���[>ج_������FS�n���ۅ�Z2�[�o#�n��Fƅ�@|^3�7Z�2P��d	
!Ē�^I�!t��G� @@VVm�t�Xy�q�"��[�I���]�^ꑹ6�7��N5�P���u���UKi !xI�9}`��-I�A�cC���HI�\"���ң@����c�5����UmQ�H�h���q�>g�,I=H�'�~�R�m����n#�~��	6�Q���Q�	�5�Q�I?��h&�UY��ܻrkt=�R��� йX��S��������.w�r�C�D�X[S��ۄ��=KM�^����zZ�T��<t%e��@�ih�-tY� Ȃs����,`�%T��#@� {}�[&�?з+�V���S�XęBo ��R��x��Y�[���9�.��s�J�,��J�F_�s�W5���ZFj��&����Ur�(�P����� �SS�:e���[A��0�&U�o1��h�n6(������C1*��I�r/����(�7�mOl.��&�k���ǻr¿���u�ì�Dlh�߁K$�8D*I@�shPk7�s0��S�9��Z���!e�ba�5��y�=du��{k�;+���nk�h������O�1	K�Uݭo�r�ų��<ԑ�&���ó��~���tk1���'�
��S�-*�U�2TFT�%S%i2,�7t�_�6�} ���
�0J�:�C�<B~A�H������]�RK��΁XIO�4��������Jk]�ϹT.ԌG�ÖH�S�W̟���Ԝ��>������?��yTa�D�=��Җ��v�0�0�y��H�y�����U����FZ?�|I�$MFћ�U!��U���`u h����՗��k��������&'r�����*n	�Е�2�)��9v! ݯ�Q��^rD���͔�~�Rϐ��m}�i�uҴ�̀����D�`�q۔Đ�G��?&��z��^��$�j�����Z��@Z�Uy.� G1$�4��D�\���ѱ���	G��Y�T��!F)��-�A��6YU�_�w�<(��ٸڻ��dyT�&C��[���ǳ���Oێ���i���I~H��l��Mc��aC�R��ݣP*7G�!�%FZ;�\(a�	�(�����y�R"a��]����=ZcE�B.".�(
9ڙQ�������p��3";��+���ؓ�5lϢkR��X�̃����{Z��f��L�䡐���m�����K���o�m���~�������B�͊m]�p��Q֫E�,M&A���jl����/Ls=�	�������E��bw!8���JX	C��:0����q9����+]���Q�%̆Ki�leɐ.$�nu���.�ؙ��{�ԋ�f���!}��!@��CMR�����O�p~b	;��㥮P���������fQ�&d�I��$��}Vb$y���0���Y�L�, ��BilY@�0���}wk���N�u������1p��0_�@���gC�6�]�<��1m��=�-!_�^�eL-��5������nԝ��}`�*��K�{7������;��3kwa��F��E����}��f�m����U�J�))�۠�M�ra���2b��Cy������(�����]�'��r��X�H�ieNqs�b��u�X`F�R_Fc?�v�]Ne�UT`O
N�bi��>�+5fI�����憐׍K�.��6�o�O�?۱��W�\(��ŭ*�T��o�lUӠ�3ފ��ȝK�GĔl�5�_�vf��rS�)��H�{�8R
j���[�����N��(L��b�f�;�Nr���cbm}�ӑ]�׫ҠC<�G��}ĳ}D�a�^�c���ӛY����4y2�H��tq<��/�3>:�D{ʚ9�4��pF�N������{�V'6��.���J�jG�T�
�ļ�f��{gP�qO{��Z���Q27��_������Q������o���cR  ���l�˹wl���b�{SӶA1@����uv����(\�PA��N}������m�0�!A@��f����p���6��ж���������'�w�g�vn��>����oP �p6۴R�9�ך��A����h	��r6N9��S���@��N�-*�(i�^"@���y9��ʏzb֥m�Ғmf��B\B�&/�����x��zB��o�'��'שּׁ�E�������N��WN�v�  �+��-8������QS�5#��� 2A�w�me�M�����29mS`�&}�e��_���]ZU��C_�g����I�������-Mt�@ֿ2:�8h�;���iI�R �2Q6[	�DP�9�K�>+� 2hk^�9G籑��mW�uW�F�������1��g��5�����%�Z��������w�R��le��N;�]�O�����'�R�Z�6o��Fӻ�Q�y6Й����[�h���R�����KԔ($B��!َ4�;a�U#0�������0u0n6<~�{�o5=h�رL�/U�e7��d�U�Pٽ���  
.{�#!�����j�[M�vl4�?�j�y8�(lU�s,���!@й��I��<�  P�����ۺD4�7)�k
|�pT��Fg��9�C�����S͢TS�j3��G��i�  HE�[No��#B�l!���4)3X~��� �6(���:gHVʭW�pY� �|�uV����,����\�1&�ފ�[�ӭ��L4{�,p)ׄ�|���)�QU�:����(x�Brq @��O�CP�Y��j"R�ƨ}� ���o�,P�߻~ @�]L��b��MZ=��#E�_��`���.�Q�@4�݆5� '��U)��P����*����x7�y H��VM�G�}  �����Vh�L�'�^<i� ʴ-�{ �J����AQh�X�7T�!@0>�f��iZ�)^�29rj{�"����F���y5��� _��è��Xul`��?�T-��K�h)Z
�h������w!�#,��q+Z[�ڂ��S7�I4eOk�:�#�I4J��p�%o��S��>���f�+-k�>L7pt�!@�4��W��y��U���pU��K�)�_ud=DTJ�P>�mT��A��vG&Z�T75֪�55� [�<C�c�'����;l��kC���Z���x���~������=�V�m�.:�K\����d��d#A�T��]L%��X�ҶUM ��&�Qs  Ep�ÄR�J5, ��t�p�9/�n����ZX����4NeA�YKT��W����S�v� ����=�ʪ�]Fr\ ���(�	�	�(7����Y��`�!M����Rkpo-e��ߩ��6h������8 �;���NT�/��Q���1R�� t�6ًb�P0��jO��! \�Q�1�vP��1�0�_����7;�g�n+u�T� k;����7:H	B�Pޅ��1{���)o�3��`�H@[����D��y�GM�>�,h�O�7I�,5�:VV�؇j�-($6L�C�a��ac�X���d��~-���Yw-����y	�����u��IOE�\|��'cOԘ���n��  �A��4Rϕ:.�# Eb�=y�(��Pa�t���2W�Wl�t
���*�
���ڵ��߀|���/`-��#XK�|$��}k���3��y$�c�3Z�ZKXЩc;ѱ�:ֱcv�c':v�c�:u�A���б�<1��PLu.:;a"���N���}]1u�yc�e��Z�67��N��A���E�7��i?}�կ�SZ�l��G�R�He�?2��	(�H3�l�;�F��*+͊w,,p	�C�@P3�38�ⴰb�a[{ss5  y��c���.5�
�F	ԨlF!Ah�t��$fl�L�~0�|�F��}�8i \h Mkh��F��|�r�F��.���-�I��q�!�g��[0@O��+���5��l$�V�����II�$�V��`�m�"�f��'��ո2��eFe؆L�F��7D��2@�X���q���it�`�����?J%��w�.1��Ln��b�bŐ���M�Ǎ���m8�`�ԧ�c�e��;��jBܽ!K!�#�s%�=lW�Á@A�8Rw�5>��U�
�H(�����4�DY�ky��V��61yr��&C�A�\���⨰�UMx�j�p��n'�S�
���|&����J����ٛoֱ�r5��=��q±���]:�'/(C���5�v-�P�&����x[a���&fIh#h5�n,�X�M���Q��al�'*�z�8� ���q��Z>�s����  �G��Dg�T�aaW�� A�?r���=K٭�N5ɸ��Z���#�j�N���R�@�vC@\���$��R����cBj���� ^p6�"���G���7����g��uD 1$!��)k^=�l���gw'~�:v�Y�Z�J�*Rܽ!�+�I��*ֱ���_���ԇ�f�-L\�	�F5c/%�Q���w�6����91Hr��0�(-�?ʠ�!Ÿ���T�'���{C����؈E2�aJ�<>`��R��m����8���f}�`p?{A���s�����h���DN�������~*�� �QS�a��}Po>)z�mTR;Ul�����B��1=P��a5܈��i'���x�%r��<N�\�^�@.��c�
-����g�Q�-�v���� @W��B��נ��·@�<_�(�J��l�}a����!Ԫ����'0�[ " �E�-$�
���� �Z�5� ������Z�Z�&����c'{t{�21?��zU�1�_թ��i�J*��m�wb�Jz�;kmSp8É�"}�`a�8|�٬!z�v��G���Z�¸K���A�poO0���@G 67($���_9Wə���]*+e�{�{�.�E��okt�'��5� ���O>�=�����hs����K��e�!  �����]��[�GOh8-�T��Z�	��BT�e�ʋ��?̚)ٮ�p�pXC� �S@���.� ^�yis�w�ܝ���лX��`ر���Al.q���?� dU��_���Ȳ
��������29�j�_]*�z%=ƚ"�ѹ�pt�� �e�W����u�@a�����M����V0��@���N���R�wq�w{Q���{� PN������v�Y
�}0x_�<R��~*�|�=�������+9� h�b�
���%.0���.������5b�wQ��T��=@����Ee�Ķ�KaV1wp���>b������}�_Km�N�}j�I��@�
�b���L+�D��\Z������2��C�dTQ�g��K0t� P�$�jwo��,/���`�����@w3����k�c����5�$F�_�:Q��nm��<��k5��?����m �d�	U���T�{C�,�	UT�����a� ,zb9W�j�F7I��(V���m`�	�S눼�2	-���lZ�UW�������d���6���Tr;�B=lQQ��R�6�B�Z����ut��ѕ`RW{�g�H��8�]*@)w��7Q��WM#��j�a��-���_�$�X�����g�'�� ��4�P��R'�$�+)����j�VA~�0j�S񄜐 ���ƬL�� m�T��C�_;DU7���4�Mcm?�]j�9Z>#�G��'ջ�EK�
��U�e�2X������	U�7PQB�<$�k3 pV,8+�Y�A\$�!  .��Je�];��N5b���6)���R�����U�\+��p��|���˪0n�U�:��%JݯS�+�&٪�� �$y4�r^V��JP� 7�T�M��Թ��u�0$�L�0klA@@�F-��8ͤ���yY�#���5����6�Q�*:\�f�GsG �AE�O���qR��x7R�C��1b��5��A@@dA�i�*-SמrJ  ���Bԡ�b�"S`>UP	��R`�
;���J?1u=� ��G(��@ �T��R�:{����4vq�Itq�x�e��LZ�M�P�����~�oTWԁ�e��Rk�J�ĮP�f=4��|/w �~��~�mR 
R�i�� �КM�{(Qp/�$0�����SN����δ�곰5�n�j? L�k�nY."!��mj�p�&�P���e��ȧ��h\���p��� �,H��/�}�,#�7I��
ߩ׾��`0�(�S�fEZ�H�>��[��-�� ���t�R4�#�,J�{8K�p+d����7��X���m#\,a �CH=I꨷��҈�8��6\�$����`���6�)1�Z�A�)�Q![�n���� ��S��|x�@��M�aS(�h�[����{�S^E �oVJ�]'3-[A/��� `NN�Yo�%��6�*��ܐ�w���>��Ĭ`��a�<R��<u[ Cl
+dT��kq�l�n�r�r['�O��a헺����P�Hۤ��S���
ğYB�h9Y�����-AW���� �b�TL�v9!圊C�x�o��w:k(;�g8	l�@�)��3<{�XC�@���m�K��|�XV�ߪ�UVƔ���ܱB@8�gED�	-�u��;plY�1f}={�J�hW��Ԣ�2(�+�4�=�m8��K�"���e� ���"�N�� d z�Ԧ��?�Х12AՄWe3�=�H�V,���8j����(��ru�45���a������+��-���Ҳ����[��efd��%y,C�ZA��4�mj�$I�Ȉ� �On-�2Lv���~Qr脟  ��/��F'0)Z��N����6��2��x*�}z�:a�＄HAˠ������N�)�7��͊��)�k=~���N-ʻ�r5�+N���<J�i�]���k�,*G�� ��8]j�}tR�3OK�UPFi��-rr�y��S9A���ִ������/��������ۻ �Q�B��Q�Y�d��w�j�5��ڵܛ˗e,�N-��2o ���X9�I �Y \���kq�i��&`xm��I�"�#fΎ� gG�� �P-pك�%�<<���]�u[	sg X_�l4����O�M>a�i�a�
{�b����k��B�\��I  ������J���3�����aL{�ڴ8�S��Tw��Aˠ嵴lP�Ǎ}c1����$�.��yj�"m �Z��p��u��;�+X�~$��6��^���V%�NY*��&2�;�	�`e1���T��ˈ��U��sZ�S\��6�O��VI_4k���v)Iئ"�F��`�D�ٓ�y�G�.[1��(�&���)o�4�&�:��:Ze$\�X�^���A��y���/�*Z��e���* `�į!Io�R�a�}	}�@G�ب"�P��a�D�W�LH��4	w��c�|�K ���7���'S��w�E)Y�HnӺK8��jZ.STiA�Q{V�o/�����I	 l[S*�ZQ;��/$ �S��&yb�A���v�!@PM��C`�c%j�����vpR��ڠI�FW�Pny�,�"�N4i�2���o��E{� 0x*���!&"D�rkZ>C˒z����F�K*BG�����6#�Trۚ�\�/�I`F���@#߆�xҽ��?`�����n @���t�XB��Ԃ�Kd<J&I1������z;��ƠI�FQ�T����b�_�إ���
;��d� �!�S��#  >�Z�I˷�6����1��9m+�G�?@���{���cKUz���-� ��* �ݮ=�ќ Ԫ� �֌�����lQ�f��vJxE�U�(`X��45��m�i����Krn�mky愝m��X)��&=�z8�%)WQ���e�e��O�;!�n���7f�^��2���e�rH}ᥓˡq�q���r�mעOL�,�r������^�A��.�����U67�uT���!e�e��}�!��i��j�!�;�Ԕ�	��V:@H���ƴ�|'��wh ��;y���;x��.R/��47;H�r?���yS�����`:d���A%�w�����f�Y���&7 �D)W3�Mͣ$;d�B�+;8h2%���O���M,n6.�v�C��2�f��hZF}<L2]D0�6₧;~��Sh9����A�efՂ�	��w�e��	gRnsJ���vpN�m-���[��֙��AU�r�\W��l�n֠ɦk'%F�7U��'�@Uτ���-�D��5�(�n�뇷_A�-�eU��sB�B�$n�7?z��h+f0�Tp�Ȳ�qp��[���R[�	�+F�)��ZR�o�GI=�����(�R�?7���"�ֹ\�x��������i�U��`?k)���J8% 9�&$3�	ɱe��QT2l���EI��+w��.���[L��fm4�<oi���UC@�&D���u�\��־�-33�D�W�g��A��`�/��[�E�BG�����OyrQR�;��c�l�(�l���_j��+-B���CD���q�d-�Šɴ���ߩ�\�0-����_Gd�e�V9�ʡULc+(��W[1��|��QŁV�7߃kz���k�w*��z=�o2��cֿr� ��Q�)�ƿ����wR��dV��������v��ȯ��ln�͔o(>�n�=/rn����o�$#w,'��)���}���2�}P��� v?�D��#<�3�zVrA]�ĲrJ2)��焯��\��x�{����� >SIY���qndhyw�u�HR;�"`;���;�7��ߖop�`��#v@�x�/��N���������[j?�W;+p|T$t�G��rWG��.�
6��H�K����"t���>�=2�1��#���fl��]MF$��;�������ȲPuY��)�r�r�^�]�m��Mm��
�C�� sf�E�"�I���m�f!�؂H#DZ13.ؗ�kv��@�S���*���^�&���QH�.� 0x����1�����;�>�-.��m����������
��Ӣ+1���"�^�*�ěZ3;HUZ{֐�d�j�p�&���D�����F[[�j!N�&�\�j�?b+�9]�P�r�S&� Bؑ������s�Z���CX['D�z�̓�ɣ�;���pW6m�����Oz[dݒ|鶭vq�����;)ʶh�6� ��u����q��n��(�G��-�W7��#��tTP�J�s�2��(bh�_"��y�k&$k��PnT��g�4L����)��#NtdQ` ��u����<�ች��J�(7S>qB����F�.[1��(F�Ny��@�o�G�~������:_����"�T��@�@U�'��h�F�)eyo��߅�,�2����tW�g��@#qб�t�ܚG�|����uPo�ZP�\yo,ⷷ�Q�*�r���w{ô�.��&MWDW*2���ɦ{1B{����P��'%� ���or��&�&�~�?�����[�p�V���6jm�cY�-r3�*�t�mD�R�(o��޳����f�̥�r(�⊯	� ?�d8��Եʪ'���9,A��Pw#N��@��m�2�	��m���@@@�۩�@y��+<��톃&k�LHz;�Q6+p�T�'j�#�o�*�rGt%CD�7m�����g~���H?�c*4\���^����m蝔LH��<�x�5�;�2%#?f��CG:��e���t�BY�"�A�6�[����n����8S��2��7j��b�'�Q.��Mp��_ p�6�ږ:���<���,�̉&�mw�Vv�a�|hx� �W�%s��nw[��K��x�:$=�<o#�e�m�6)�s�y@+;��v�bQ��j4b�n+F9�_饽�e�VS@\�Qr�
M��F�A9���(�*�p�3V�:��Q������"\N/�= }�ׅ�:1� �l��oQ%a��N@@@L����E�6��z��4B�3S�OR��=�m�1��v�r,�da�����V�H�/*����wkF��Ӂ�9 ^�$C�d��i�+f��k;�j_��0�G��(�&��j<�<�	�c���][ :k8L�aS�(f�| �ݴ[b�AW�b�� â�T]S"�]��� 3:ҡ�V�A�߾�  ���ˠ�~/v�����:5hs����w1h�(��wV���-�3FQ(�%.�����:����Ծ5�*�_�t�ڭ��M��U;HM�0e!�oW��յ�x����:�P�f������^G�&��h��Eٳ��[�7�E'�/��_�M�u!z�XnLmZ��!�o����t� ��y!�n��Gh���1Ӈ���f|�y[���U毓l� ��J9��12�慡5޶�M�NjPGmA��O]1�bf{��o����{�3�D˺��j��J-�~E�f�/IV��]�` �k\���.�k���P����*��������Pl��Q��>E���@�����2��ZFycc���{�+�`����;
W7R2p%����������}k_�,�ב��W{d��z���6[	ݥmm���X�>�����hY��c%�s�-T��* VV��!A�`�D�(V7�����
��lL;�X�UaB���A��(��v��K��&%�C��eŃ�4���ڙ�=������<To��s l-:�ߥGA�a:� h�ͷ��A�!(3[��Q����7�N��fhgZv�r�؀�P1~���K��_�5��> ���:5�LNQ}�EZ�p:��.�i�5���p�p���Q֕R����j�!��ZH�E�OYm՚��i9-J�h�R�x��y��+U��v:H���`ZT�_��e67�O�phV ���\VLHR;��	��Ў��L �x}$��НQ��Κ�F,F:�y�	�?�w��'%�(�mǦ�C0�
ׇ��a���-���H
"R� ��x�*��������8}���W���(�waK�کe�2dWV�<�[�'O�}f�h�E��l��p�+���p�Lp($�	���𩢀��Zj*�2���~�)9����q���a��������f���S[�̹7�S0J0 U�<w� <��eKlQ٠�Y�\M�	�_+�+{��+{3��͸�XvVD�����4Ʌ���s'0t�#{}V`l%Z>!By�oP9�*���w���k�\&a
��*B8 0pX�H�Ѯ=FI� �l�&V2~g�!�g��̦7��9s+jg��hY��9����F�*S��jm��U�
 Pp�����ܖH�A�К�H�Nʀ`�?3o&�` �X�[/+�(���hH�6���;�P�E��8"B�3��7������7���̹vӶ��CF�^�o�U��MZ�n*XIQ����Z/�DgR '�yJ`XS�a�� �r"��-QG�ۭ�����T(�n�@����/D��v�R�=���|�8er7�p�������Y�m'-�bkqmG�x�v�|���mԧm�`WC�5Ȯ�maKe�@� �O-�P3&J�$�4�\a޵w�Q7�6ܾ��t�Bn]�u�~�iX�-QҢ��` ������R�����ѕb�U�I(oo^�6l���oBjR�����0�����[g"�s�i)DA��[Ye�2Vu��`����O��k�a�q�C�3����|j�8 �(a�S}�	�u!f�>�ϟ�u�#I��9�U�/��c�% XR��1�[W'�uh|��w�s'��@	��}R�B���ƭow7��i�H�2Y��x�� ����B��, `2 �m�j�xW�Om;�&�e.�e2��{
dD\ƍ�Ē}2�*wH�r��+��!�����Y��۫���= `w[h�x��5U|ϗQ�;^V��Ӷ�"x�KR�;��x�7��]��2�!���/=�o��%L��~� ʕQ8 R#��9�����d����jd�wV�[k(��k�G����;k	O{��i�ks�[8��**�$
 �k�Z���l�s�f���s�@�7��M8�Chwz�/˕�JyC`�kI���J�C�tXH���X�ۛ�{����=k9��/�5q�4/���F��ki�E�a�hȗ$z�bk��$�d���HI@AFiK$����V��4��3�wg�f�y0(|�Ń�x�亅Љ���?9�C����Ovr����{Hz�I��[�����0	����q��!�LJ�(AF�2.���+�����*X9��a�KZ�n�C۷]�8�}����Q��!.���E��(\��, �q η��7����j�U6(mQ�yU���	1�K�E`3�\@�Ԙ�0� ��w��ӻ|\�w��qt�I���^�=N5F��z안��m.�:��\����Y~�@B�@����t�)Q��*���h:���b��ؕ�c��%���������7Ľ"n� �T$� ~�9Gj˗_�v��7R Q|�����Q*9�k#�
��6<��!���w`�@梪%;<' ��6\$����\{L�,� ������;��j)-�C ��_��^��E��}Øod���6(���"�w����B���'0�aܹ��uQig 0!��p� @� �V���1kU��Z]2�P� ���V��GN��&��od-����i����z�s��� ��0,���������qԉ�A�-����06k�6��LС�%V�����u~���oību;ݎ42�0
�k�p	��0�p&p�yݴT����� �����jg��3 Xz���+-�y�����.j���  J����W����ڭ ��V޾ ��V��p'JZ���� _���-�_�{�����r�-*���������tK�� ��]�K��Ԗ[�~#9#\	��o���.R;U�������6H"�FPc����6c�� ��(�)�m�R�����/��8����j���̨;Y��Η���P;ΰSGCT��b�z_u�%�p �C�ۥΐ�y�.�F�y�*�jϿR��a��6h���&<���5���?a�OW!L(��(��X
�n��|
�[���r�ԅ.�_�1b�\-��k;�j�p��o�d��ۺʃ A�5�Pa���oE}0����E�r�5w���R���n<*ues��M�<�  �)|�6s�F�o%�i�Rv+8��p�@Mt�� ����+�ى\�.ѡ=�����*���t~�R�^�O��V�V�M7u��+��Axm��y�E�! �a�Ør�� U��/�DF��6�b>X���|Q�DS~~'=��x<	p	t�~s~:t����v�w�?P���N��cʘ�LQ��|���6���Y��Ƭ��jx����H֡B�o�Ld��K7�a˘��@�����Hc��yi���?�'� �����F|̇~sG�+�J�7����߂Lo�����x��@��h�bA������g�D�n�k���M��-v9֝ۻ�W%[��M��3�������ބ6��/\>�a����Hp��+�2���6��8����X������Nݓq{S38�y*�D�JMO�m�3'�0oCb�f3�k\��ې����4��0�t�X�?r�@M`mD,@䞯���b���<�t7�|�.��mp�cv�\xv�&iM���	?Ol��    �e�>;1�3��6�$[�㐺Y�����?݆�<�w'�B������>?>���2+�ȿ\IŨ@;�@(�ķ�l�{��W�i�i�	�a4P�;��G��C#E@���K1w 1�-qA�{��Py���g|@�gx���d�Ip�$a�����������m��l�H�k�����D8�3�.�����px>���N���4�MH�A� O�S�(�3Db����A����a��0!�J�k�nR�w�劜e��rȜ]��lv|w���e�H�f\�*>�}����Q�X�z��*G;���R[®��D��+��ɇDQ��i�FnV�MS�|q>��w���-_�m}}�*! 8���~�1��r���xU��N��RCkpZh�u�Iƶ���&�    ��uQ��l��e��c!�@���<��[�ۺNj�ۭ��<Jf�a�`uok��Đ�|�{ݿ���/E�d��z ��r��XAFdg��--k[��e��c"-��6����������A&% g��R�߷"�Ej���:ϣl��z�.��6��D���bR]��n���N��嚜�r�^���WE����rqD��f��Dv&�.7m�?���`K�1����&�9��~�R��.�������C�=�uv�-S[]j;`�v�ش���BPeJQQ�S˺J�&�D��Ga�d�����f"10#(�e�y]I]Oֿr�������3�g��"�u�Ka���KB�V�P#�K[�
l�I��&���k��>�(���Cĸ��F(�[r�Ҁ=
����h�W��!踙�x;��˧V��XF4�*�9��1����[UP�5��DY�԰�~���T1�b�-�}�"A�����_����H�Z�PX	c��G�Tn��e�=�R������vh�������B�s�5N���9�ZF<����+��Hd(�C����Ta`VD�D�x�[V*g�>q�%��M��aLA�D�Ԏ��.�JR0��I�����x[o�o�Ǭ{�������4)�%�:��
�Wh�%��"�-�u�R�(	��2��X���,ܼ̿ �p  �9@��\i!��rLk��aP���F�ہ����v��vE���Pw�g��{ƞέM̕� ��r��4,�T1������\DY	�C�[t}�.��l X	c
`�\	�2�I�!$��@��D(�M��ҋ�0K��0޾6ޞ3ޮ7�.6���Osk����vca��J��w*c��)1E����Xҹ��#%Z�Z!���.�e��m]pG�]�-Ò�y�E�s7-ݴt��E�9a^8�(���.%�Z�������6�̳�n��s�v?O������$�AB���s�O�*D�3 �JjSPY��	Ʉ�Q�bvP�u�e�-�e @������[����փ���[1��.]6!9)�uB2.Y6�ʨ�ҧ�����z�ʃ@�2R&�z��)��_�0+�y*/�W��+*v�lTڨ�CEer�[�e�̅4�
�����v94�o��AZ�-~mfN[U�*�V1�_S�55XS�5	�s}w��Mu�� J��UѦ�\�8�M
�9U4�!AQQ��ձ�,���-4�3h�T5˼-fM����:+f�MG���k��̳�_�|�To�6d�w��)�x�������#��(��#���X�� A"���(��h��V´Ѕ�A��g�[�54)�������Y�z����.0�JN�j\a��(���
�@D��Ӱ�0��2�����g�fG�We�2���6����ۢ���&�1N�Ԧ��5b�e���lA�
`ĕ�!��;v��%�WR��)eLA2H�AC�!�~8(��I+�3���%����_���B��c���m$<�SO}�)7�VG֥��e�C��H�9��:�rkv����A|`#�ׇ ��YM�%d��P1@���iҊP�t���������@�[��#-�QI����!v�f%V4��7�L)~+�(級�uaڎ�UKD�ߎ7���W[=Y`Bz������Fy���� 5�؉(�z0���$j��ۑ{�̀.b�0p�U�+)��
��e��� �6&���IN�.�3MZa[wq��=��.�>�HK�X%��We��e&w����Q��K儊f,�{R�P��8�&��i$��K1|�8�jSM�!�P%�M����a2��Ɂ`-�����a�L�׬�c�Mmb!��s�<5�c�n7�6��)05�S�>p��q$�Md���"(t׵ǡT��5Dv&��.�	��D/�M�;%��|���눋��?�(���}>$��7�"��{�4�H��6Fu�8[�_���[��R����S�D�G��k8SB7x;E��&6f���Xg�]5:�ã�<�^3��^�k46b�4On׶�q�Ɖ_q� ���F�Y�K1�a�6UC�b� i^;�_��3���[Z4j�a�Ո`�|��[m��[$���B)�4�8���(�x�]\ĥ�*$=�#%)aCN�/�r��%0��U:ɧ`�^L��-�-�Q�<�w��VS���(+�o��q�T]�5
��X2���r����f����5-��M���0��-k�U���wyCϔ�v�D�
�9��D�N&���>���3J����lj�^���<V�udG@��b��m$,q!�#A�F��F������݃.��_�$<IK��A��-�Y�|�gپ ��=��d����@9'i׺Ԇ��N��l;�o���S�/%I@p��!�hF4wh�b�gg-#A��7�x��#Ƈ��E� y�t��^ɫ�*/�!`�����]+܃��jSS`�=�0]Z�A�s�����[��Q|o�
��pAYI_��S�b��t�����7�[�f��)'o�$tg�c���	�@� A�L�R�H���8śP�̀�O'v<E�_��O��n�D�U����ڰg�����	i���E-�3����p�@�?J�>�KmI�FR�{R1O��;U$��q3<��y�G�)��w�b�N�rݑP�tʕ!�0^O�;�4⚛�	���*�d�Q��Ν@����oo%FM
�n�s횊���l��Q��v:iS�sq iR�t�ȷ��_U}K�md�+���@� �B���C��� �����F<��Zy�A�r�kZ��F��:{�G�.V�*6�셠�����EI�j�m]��3";#�aFD��]0�2�:  V&9��f
�B�P��3Q�̨Y��Q�����Y���m���8�z����0�C9�^��@� �����Oj6��D�s<��µ��&���+%�͏r���t���� pf�,R(�I:+ډ����:L[�`�i6)¼����	<�dMJ�G�[/��n$!�*b)Wv3^N1�)C:���Ce=�&-}$0�x�1[Ե�3�J�X�g���Z! ���^�|	�W��,3�[����`�e��F��P��P�Eߪ�g�a
����N'g���դ0Zkޟ� �|�:�w ���yX��׊��!�N]_�Q����|�mB� �3��>d��x�`?�d�Ps`�_���0��C��o�BۗXcy��c��<Y؏smGL�pNɐ����|�+�A�:"4y�.��M����.$�]$��F�S��Nݹ ɦţ0��)N��s���a�ܡikL��`�
��G�� �s��"�������=�|��o�+�����CD��B�2�:M�o��$���UY&�&��EJd�8����C��NTӶ7� pS �5✱��\$-G5��*':V*Y���x��-5TfN��>������Wv�+�S�]����CY�]Hvყ����BI�F[���gG������������s�hK-$��]31m��vSC�~�+55���%���O��Ԏ���� }4T���/������}��˯�r�T���z��k�Iz�F֝��bNw�~0�d�c�-� �/���`��J��e � �RO���^�,pɐ���ܕ������������[��7O0�*d�3��Xă:��$���o(��P�0xbU�������X1R�,�JV���R_c��b#�7`m�!ǉ���?�����.n۶߲ߊ�VH�LJ�7$��ںF:�"���~S�-P4M���DT�<�--؞��^�ʯ7Mp���Me�P������ *�|�ʩ?������,}�d�RK���<yT��n��]���8��<��U�e ��>m���8�}�M��(����x�*���"������5+�������q�c�SE 1��(~T  ���fp}��e�Pk�>Zf��M���V���j���?Dz�����I��F�
��-:m��r�\}��-uFM�L�>���� �-������� 0�}� O��z`T�i��u�;h��u!IC� �.�-}Q�N0��\{�U�wtw�?6�`O�&�|���C6VŒw:BR�+�?di>[7��qa�����I�<f4��T��6�k;��������;�9� p( 0��Z��7IU�>�ú߳�(�xsZ�@���׆ �k�[�[�z�:M�N�-}gy�<��Զ7¦����h������Q��������~�Y,�����'��a��Z�F��S @������z�h��:h�kL�X���;�����;_�er��[@6y!h+���2�,���h���/��|
AW��AEWt魪N�,T`��Q���e�U:���ӷ�_A�hw�̘��0��
�]R�l`H3�R��!��Ӆ�ekk���;y��n_��X��Ƿ�*���K�ԚIj��QG���p�B�x35u�����N�C��J���hwTU'J�  �{�DY�`��h�u�(]���c������~,�ƭ�����"$��v<��¶gf��Sɸ}G1R�H�Ē�L��}j�>���y�=�ǯG���P��B6kj�>L�6YP}��hӑ=췸�^
@<�B_��I+�F�xY%
�ޅ�����+i���;f܇��(��X��55�g컟o�q�;���NM��en�یTu����d��k
y]58�����HvКvE�����ru��_�	E�0���l����k��@�����Sq�e�c<[
��vES��S��	� ���s�x5�6�����:6
 )J-�Qg�^����SFZ���d�fl��	c��jӽ���/P�p��oo�o}�1�9t݈��j���@*y�%�_��Aȹ���Q昏�f>?%���bJ]��_ �4��W���m��o1�{5��V�Ҙ�]9��k�B���֩J"�B��A�J��ʢ�^5q�р+�f$�� k��B��ۺ��l�3u%�}�p��j�V��~�8���<��wX"��(h~t��6��i��OF�/a��YVb4Ta,�skF���6Z����;g"����	m�V�AUk̓��ʤ�^6������ٴ���H剁Z�㦤t�U6��Km�Vy�5��>�������RGpca�'�j�ʴQ���\��eU6�fA�=����������v�f7��Q�&J��!��g[52��Bas3��,�ԯs��|���BC ���a,��O`*���p�2z7� aų �����O�͜�f0�nme��;g�7��v=���0�fk�׃�.�-+Q�zBj�(�5�Mۚ����n��Z:�4�Q��,��;(�i�d4��tUEvcE~c��P&�x����X�[H%���:V�[!�;7�$u�\�t_݌%*F�R9�e���*�@�8�֢I��[_ƘS&�-:��IgE�	��$�d�6��n9�E M��{�OmlB �n�J�l�ڎG�i[�U�2�-������HJ=m���}e2�OY�R�"�j�S9C͔��!]L�*>9c�a�:M���M�6t�`a��)bg��RI�� g�QѱJ�Mb��ښ��@*4��p[>{�` ��P��������,!���H��8t���Ui��>���06�Ȳ�;a�M�{{�М+����]bk�-��ٞ��`Ԇl�^+��Pz:����lD��	¢5��>���V�&�U������-��aɊ����hjM�fl)��:8Zh��k�~l�=u����_ɤ�܆4�,�u���` ��� tM�aob�^5��#�1Ӌ)X
�l�BRX�(����g[�=���l�UK��1=:Ŭ��ɐ��9r��Z�f{j�� �X����'�)�U�i[�5�$K/]U�ٹIr�%]i2���d��M��%���0$̒� �jŠUu�-�"��7�d�F�}= U�27cˤ@���}��j���{γ�k��b$:�"��6-��"��G�!@�?��ņ�D_�Q�ΰ��͗0�}A�J�kT�Ÿ,�	å[Zg�΄9�v@s3ޠL�4�ٌ�0�mi�d�*��!U��#�ڍ;�ya��}���%SB���/�BL�j fM:r�&iq8����I�S��+�֖�\�	�!LC�,&0>!��Մaͼ�4������}
�9/L
4� Au�;�e2v[r�8v������Jl�=mܵ���
ks���� ��"���}VI�#ۣT �[�do��YM�[�(v#��W���Մ�r�%
1e��Y��a � l��J����M�Ŕ�u��&�r�aT�l�'��8�A����b���[�r��Y��eL1*��C$�7���/s�0�:�6�
����1~�$n	Cf}rV̑�hX>�);H���*FJ�$\�W�(֛6�l��}疢��P�E��p�Xc���{|�+Wo���7M�{��sDp�2��+4�'�-a�&�=9iV��~W��2���]��<E��vi��|k��,�� ��o7�RE)�qT�ȝH|������4�|jvr�5F��l6D�m����C�$�Bll�Q�� � �R'Z��Wl1H�1�*'Q��A�4Y�R��en���ė�q�*J�䨖;���yk�vW�z������N����c�9"~b�x��1�VX���|ǖ_�V}�!�楋,����X���`�_?	bQ��� ��`R�EkS�<�akd����������
�-�Iu��(_���\_/ĭ��D���lQ8 �qyޕJ�d�8d�!���/9 a��KT��>�C&���l�#��eI�Uv��J��'#2cK�V�r�ʱ���+�d��	cb(#E1�uu�^��P�Ƴ��{�
���,B� �}3��|�����nި=
�_��=���$�(���Ж � �&��e+�D�MiR�M�q�O��I.����2CM[U�=���c�EX��_�`�O�<s�t @���:�K�����Q�k��x�/v(�p�$�	������0f�:lH�]���%�U"�I�K��T�����Ҝq����xj��E1������7.l���G�lg��q7]�0�7�D)xU�'�"��aH�X� �'8<:m'�ѧe�;�}�N*��Rj����v'��DV�ڣ�E1���.�[q��dL��,�Y�r�u�lj�G�9����? ix� ���1U&�~���2�);=m�sJI5bSv�z)63i閒y��v�M��T> !���֧����5G�:L��kV}�U$�>3�I� t� 0�HM��#t+F*�����H��e�V�$!�*Yu�q�E4�b5!~�N�do8��{��1��#P��ӎ�m���v+쓩@ѝ<d�����,��(A,J?��pz<A����D1�:Ų��t�>���D�$�'���m��<o�\�ylv@�1��f���Tϗ�4b}����� �w0�wDĩ1�w�6&��ם�z�z��~P3%�` xi�^��}C���߱���m~D�mu��x9��D��e%n�*���%3:�l��|˥0�G#T��G{����s*o#�օP�k~d.�N%�!�
�?�0|�Ղ�����o���d2D�qٳ9/�����o�U[�Q`o�V���#�t}�ryB�G;O�&�c*w����w��L8�N�E�k:�B�O,�o"a�L���jUa�:G"��~m��i;K֖� Z�6mg��\$��Wn��|�*��J�J��Ek��0��2��@��b�5�Tn���"�q'��m�CB�{X��	�`�`X� "b��h�1.��%�N�lwoê�ĒC&U����1��#��m3vr@�T�jW���[q�&��Zٍ#�Rܑ8�7���u�RP��kP�u���B�K�c� ��0D<�N�O,��@�lyԨ�D�ᝃ:TGN��ɢ�����&5�H?�bJ^�!A���f���-EM� @��Ms $L�7Q��̇o�bs�}AWo��Xԡ�ˮP9x��^�B��)�	�*A�+R{��0�(���,Y��#��r�1w N(6����d��R��M�?���� A/�xU��r��d!Pbw=t�5��in�K��7kǍZ� ��k7��-ڃ��4�"xԨ�$ԡ��֨�"���U?	���,-�#�v>�o��M:��FD8�-�<P�T^�E�[N���2��g?��|�P,C�Q 1p�́�!D�!Pa�%!b����Yp+f�i�)���t瞷l	�XVĬ�V̴�oJ�M*�)/ߔ����eKx�C�Tw�$�C$�셫T�P�P�D��Bi l��(|���h:[�WGR�̝-�e%&6�+�d]!�s͗��Ä�"��pF�_����I8O�E����_���M��1�aӝ.Ɛ�r[
n�+�`����&ݺ��a+]ʂ�` �{��aoO��䤽%+Kҕ� :�2i�L�R����I{���Y�*�i;��v�$���ɽ�%�-gE]:F�}`~@R�z�}�ݳ�v��[m�j[�g�v2��u��]�{�a>�f���-p����=ݵ�(��Y�`)��ݼ�d֭?��>u T��,�@jPU�|Cw�-�U�*S�^$r���St#�/����aC2����q1=Ix�ms�Zm�N#���)���DA���zU��7"���DN0?$��ʲ���2�$u=	�S�#;��@�{j�� <G#@��a����'�9� � � ���{3�lų�AՔ�}��)���/�fޢ���&�g��R9��UNb$-�����-3�2�rX^����槁�g�]g�+S"U�"@�#T��c���Х �P�H���M��lO�ܠ�"�D�/�r)i^�g�n�c]����.�Π��{ڬp�2�!�A��@��D(��ь�R'{}����]���4�S;@�a:�R:#`X������������N���T��u��/ء�{�>��}�������}����/�dti�'P2�]#a/��Ǹ:˻�҈��Lƶ)�w⿲���G�:h�:�s���J�C��Ѽ�� � ���v� ��0l��=0����$�e����G}ꋽ�s}�S��h������na�Y5�����&��ރ.��QJ����cD���"f��w���:�ǉF0̃����������ru�f?�u�=�s��ǯ���{��mn�w%�]`�ѥ>�x7Vg4��EN���n$�-'F���PA��I����o��7�N7�B��`���:�ƵE����>��}����qr)'0@t79z�V&#��������Q�纕,
�>C��T!@^���S�۞�^�x~��;8\
F{�4Qj�����V��،y7�[��(�R��+�.��G�ܸ�;�� ��U�o������3)U��Ց���Z ���eR�!G�SB;�0������!�6��f�f�IQG����E��YID(���{���B�C��}g4)e��Y[[��j�s[6��U�g�> �E4����ȝc�Y��B�*>5{�Ni���*>�R�9�&��b>QrNܲV!@�Z���?���?�G�q?>d��x���`F��wsu' ����汻��X��
Yq�B/�n̗�Ѕ`�ģ�4a��ы��(|uSL�v~gR�G @`sd��M�7-�`(CK�m�[� z-��Z[=����UA�Qb6����z� ��uV躽	�τ�G���M�9�����:h���SRuC�������.  ĭ��<0�It��v @�H,���� @�`5qm��N�s�n�S�׍Xm�����M��;UaQ�9���* t�PJ�E3�fy �s����N� @bư}a��-9O^��?���&yV�u���،��{����o7o�v�����ަ��z��7��d�7���We���ݧ��O���wgҭq
�o�v1Әkv�΋8�4Nm)�����{�^��p�Z�>c�n�N&�G3ힳ���ڨ�p�VU_�Sp��ê1�F�&  ���UO�v���e \V(�S���:�J���I�^����]B��i�������cp��Q36��n�����\��_M �`wZJ���k7:t�`rV��=�B��m��=Jݽ̽�7Ar7 ����=0���������]���|:/({��cڑ�lo6v�ݲh�� ��U�R�A����f��6�S�n��Ab���[�d=\d�i#�r��qj����jA���{�נ���U)��g°�H���[K�s�-�}j?ߌ�v���>UR>�"��wu ���b��R�	a�yt�N�D�!`�2#k/����5̓ Ar7����6�2{v�ބU�oq�ݧJʬ�8��Ҏ ln`�w�3� @0G�-g�$C�愣5��h��{���m>�F��u?ܼ�pn]�j[�����S%e�r��d��ʾy�^��=�h�'j�r����e�*z�G��9h%������<T_t����^߂�����ԍ�8	�0|d���G94.���A�V�t��3]!;��A��~��ف A����8�䨔�~�޴(�c��`.�1]�!��)���9�h=e�[�h�U%����Z����l���|������Qe�"�dU�����dH�Hx����@V�:��ho��U��'���!���)E��0�DC�*[���e�� �Qk|3��!���F�wʦ��}� y�MH��V�mBh���>5>���1�C��_���^0/��B�LZil����U��a�es��Ze��/.���'(�3���`MĮ�w,-m�o�J�Ur)0�*O+)X!�B&�(G�cD�q�������.ߢ-*)�#��ܻr�0�%9�ge:����*�{��$����V��Sy`+PަT�Lg���j��Nq����2�R!1p�8B2@f����LaE���C������-�-�	5����Q�A�;�C�ͥ�V١�
�O���c��fqh%A� �WE~���ҭ�-�µ2���S����Th�"����2�;3���}��O��jg/v�b'�]�d�i�UFʉ�@�q/�3vwV���n� A��{
C$�-ӂ�k��=���:x�ڍ���hy$��a5.pi3#����tq�!08���j�����\�pV �慎��V�E�`��S���y��߲����� (���MfEȄx|j^���ʭ�)�8N���qnAw]�e��!�s�Y��MQ�ެE ���VQ�jh �5C)���HD'bo{�� �Z]����� ����r���6�ln����YW����c	9���������q�H:��7�{��{�������A�N|
�׍���%R��CP��*45\��j[$�����Z�0'�	3`�&�56Vv+oi�|S��f��x3����� @� |�C$����QY8�-�����kk��4O�<��C� ��y\}n�E#Q�3���%.,p�߹�4�*X5�G�N���:��� �)��XYU��p���ul�A���nh��2����L�`����^H�m`^�&����8k+{�O�9���ڍcnS�����9Y6<F�յjl��Dٯ�(G4�똽>*����%p)f�j�D�GA��W}�`u�='O�b����I���h�Ni�d�d��q�oo�G_A�Mv�1!�Lzݢ��ܻ�(SMo��kt���t;w�fd��
8m�Ki��ZǪ������EƐ.��9��餟�)v"3���"Hc�[���T�=�&x��v��ߨ�/�����4��(Rj��`MT���J1�� ���Rz�{nI��t�L��M��a��ѿk���!���@�?JQ�&�v��<��(�i:�v����4��� k�*fʅ��4iʎp��L6�r�3>��{�W���(�U$Y�f��趮�������
+�p�Z�t*k>�s�ޗT�u�C�0�#��dB���]�qa%fݟA���K���]�x�|j�^50�VTN[a��tZ�Sn�|��ma�����hV Jną����U���� �-�Ϡ6H+�o*�+���ͫ� ��Zp��#��Q�A��(�o����V��N7��o胩��]���N��2VV�=ʼ2�lW�*3�v�F�&e��M٪�R���>e5�9 ��]e�`����V�(�H#){�׍x�1Ѡ\����v��-1gs�����v�(�#��i��=A��x�T]T�wQL紈���,*s�6e��S�Q�%e����
�ڥ~�cB�N(���p�&\`�Q���O�R��R� ��y�4�����;OZA��X���2~��0���a���>�Q�)�_���ۺ�3|cfJ2���zk�ٌ���E05��Y)
�J��NJ~NnC�s��ǣ -;G�A*E5�P9�m�W�*�4�%}T��T��}��oҝ�9��)�ۆ�V����!�-s�f������'��N{W��m���&3#3��v���;���d�%3!�2	+�|j��q1�Br���ڔ�����q��S��6��{�T� ��=P�]�	��������
�E��pZ�����{�q;V]��,��-�M8d�Ƀ:�ʙ9
�����B^�%4Ȍ�~d��퇹}A>5���x;�x�����Ij�)}� �p�^�ً����2�� k�H߃���jm��A�����)�k����n��%��a��;=��|f��Sڹ+7���OĎo�0]+��Q�{��˄�'7�q�~  �1�U�7���3�$j��/��*>�[R�b�8 ��)z_���Ё���>.��矻S��3|j>5�@Q�(���0������� A��J+�̴����ӊ�H6�jHܱ��9#X�����@��Ԯ��S�r�%�T]���_*J
���v���f��}�K�ħ�I��1mo��Nw
3�5�HXm��=�Q�w�WSR �����U�o����2���&�v+)�#��M�b*�~a�\�[�q��4�$���V��0o߼�{ay �j^�>w��,�_��/ෛ�[��!Δ~�����$��J#��j沲�Nl<G����pt�)��+��,��@L�}�N��BE!uȤ˷���>�62��rWo�8VO+pD��h8�o�f�_n�^9f�k�f�׍l?jt9yb�ТC�F6��1 @m~@�*۾��Q�S��������zlࠞ��TR��(�a����`�"�Ș3�Kz( @������վr��󠁕p����2���yVG�_��Un�;(O�� �)aw/v�RoG;��
�e䏈��E��4���_Se�sb�u�@�bBRn<lz42�rΈ�L��$̋�ʄ��Wo3�S�S�We��'Je[��������3���{|k�>n<{���(����IU�/բ��|FW��pl���ۻ��gQ�</� �>��Ť�,�k�=�����V��;�\"F��@
$��XuA�XrȤ
�]^`���Q�*kVȭSr�q�*�9��x{�7��e�֍�,�"S��Yb	�����*�L�4����8}�RG���mY|�"%���{�Y��;��=
�W܃pԨ�Y ���Q.��ᛉ�v�8��V�����9�;G���0�2�< ���6pZ��"���s\T ��+��b�3�Z�A���M�v�y	S�0�"��L�uE5h��0	~����{��[�/�m���#,�n^w��>P���#P/-���{۱��~�&Jq�,&qG�l\XըXQ��L�  ގhp��yX1�5OZ[�l�Wײ��Q�����(��(�+��@�U�)E���Ԋ*T��3���4�8Ut�N>b���ȲJ%~G1�"�lj�3�z�J0/μ��uI��L����]N��a�ޟ������¼cW-TzX�n���%RM'η5�f��n�U��r���^ds���
6w����S�� @���WE�4N�`�fX����q�(X�4_2_�N�����NO�����S#�T"u�N)�;����T /�趮���m��D�}���)�'  ?��dE��&�u�Ilo�� LJ�To����� |�_�Թi�n�C��bw!0À�E�}�1�ߌ��N�.v|M�	6��U�޴v�B�/@R5�ҭ�f��X�I���Ȏ����z�eӕco��9"���9w#J�����=nI]I�	�r�'��peھ�		P�s�\� �eL�eeP�.�:}����p
��*�,���Zl)���^�C0U�:��~��e�n2�K�����?M�o3�]a��w��`�9!�oiz�����K��K�W�ԼBe̷F�j�7�0��X�@̏�C��d�fTM�B�H��a�gf\�a{/d1I@ `+K�,�n^�.s�!i��gw�Q�P�W�� �BL��eeR����Y��~_���<����*)
��y �a���]#w��{�������&��i�e��Z޵5h'�t�yU�Q�#ɐ��I�RQQ��Ce��b	V°�f�(X"`�Ԉ��fX3��a�7�����uǁ@BI]նz�o��H9�����e  �@2GÕm����KV��-�>�^vV�����pO����w������j�����cA_��k�e��v���yC�_P�Mz�0�	��K�u�33�؃K�PG��3)9�<V�O3�V9!�jۍd]��}�Jz�鮫7kRb,��B+�)�Ol6R��x�(�r����&%6pݘc� ༬�Q��eѨ�oU9?no��I�Zf4ʣ��M�_�iy׶�s���tc*n̂���a�y*�^����9�UQ?�f ,[�	S&3�@�鮬����5���x�X�R�F�F�4%x=tI���`o@�����~<�U T�� ����g�m� ��
n���[ �׫sv�����k�� 8#$/�ۃt����-3��z�^�ݱ
�Cl��/�<f,�*��(�a�K�!��ˈA��@c�Z_t�%K;b�Y�jQ��&UUP���r*��i��i�h�u�B	�����9� �'�ۓ�'|�� �,+J��lu�.�T"c�Vu�|�#��p9*E��	�P�ܧ�E}V���y�G�.A�R�R�iˉ�a~�)��| \E���TN��p�~Ը* @P'�+8{��$|i�+�h���H�9 ��;+d���  P�r�6��=���4 LJ�͍����ݖ�R�V�v��aN0]R���M��`�Lt���.R$k:t=3�h����	I�حt��cl�����RŬ�x lD��#@Б�s��f�c�.��� ̂�b�]gn��Y���`m`?+�\����J	��@*�[�������8tY鈍�p��>%�6U�9!��F��9�ҶtN6藇���y����ZfS�Cf Iէj���,�}!���j�T�U��h��E�I�@�@X��Q=ǡk�l��%�q�ޅ� �"j���9_R2}?o9��w ����sLD `$�-�����JôT&%v��V�jd�Z44U�-@*$av[FZ��(z���!�3Z��,��F^�Lo�#�;��b���hO�3d����:�c.�l�Q�2���O�[��
 �*�o���xo"�Gq��	�4�D}�>(r��l��KM-+n��I��z��r�ɔ�&���I~�nG�G=Jm�$�
�5C #�}}�|O���@��Lޅ�k��{�u$�� @�`�z&�?�[��˝��Q%���5� PƂd*�IQ� �������=6!�oTc������l#�T�$�,\�Rj��Q�*��$ᢼ�!�i��<
a����{y7 @h�e�xfpab$f����B�-��k�O����� ��m�r�g@ I0���	�h���k��IU+Y]kBR�i���Sp�z�~�2MXk4Q� ��Wū
�* �D� ���U�jf��lF��V<���`@H?0���^�e U�'D���m ���mS��T�h�y��dhS�]�\�U���K/̀�!�Ԍ ؜�2=�X�[I��14�U�@C��LΫ
B
�*N @�B�H�MrˇX�͸�#��5���MU�*	d�4�*�j�����@�R�}ۋ���ݮUx&������>t�X�.�5���j�����{C,$��������� �@#�� �   �3����\�NT*jC?Ɇ���"~���Ԍ���F��}䖒0����q�´���n/��mkaf��Οw�i~�O{��Tj�qRy�ʬ�h�岛r�$q�w$R#�#.���!@�/񩥶`@|�����
~|����h*�1e�D(߹���wA��(��b�Ae�r'� ��o�5�+�,��������Ih�̡U��9��ږ�˸��2�X-5���{�5p_ `��b���?o��B�E5�Y��� с�!1�u�!y�|˶�:�8 ��U_��
� E�z����X9���  ��{Z��q�N�&��f��qO-XN�9nĭbf�#�:��.2v\D�=7p��S�'�O�i����Y�T]����&������W�%eQy(�  �Bjˏ?50ԀY �U(^`�A�!hnŐ�@/�"s܈�7��~f�d�T�P�p��#>u�eD�F@@|_�! �5�{�c>���J"��/1��ސ��Tu6����W����\A��ɇ����0�5���Vھ1[�檯��S��oZ��֝/�3��&��ӃVMa�IfT]��`X��G��aw����(���h�̻7��B�!���M��-���Cy  hM%v4x ���2O{�Y��z$a����<����e���?n�L���U�PT{[i,X, n@@@��(d�AYH�,�p�����h������wm6Ͽ���rR�V3H������	��������^��<�Ag��L�"�<&�ɗ�k��I6����B-@��#V�}�j�˵8xG#	D����h��m�ٝ�e�{��^�rf5߅�a�PfXC��~e�r HE�|��H��(��p��^[�lRj;A�[2��%�ف�5���|�G��n�Y"$����w�2�h0!��u��۹����>+3;o�q���3b�MA@�E�mT� ��U�գTN��? H9C*���IP ��5ʴ������±�#�xJ�=�[��	߳`���g�v�Ս.R��   �" ��ۘ�ȁ#��xc���(�<��J
����sQ욱��	�H�@G�(��5/�/%�)�1�q 8,��4�� � ��x��P�EW�"�}/TV�r�½D�uO� @PxS[o��q˝D��k^b�'W�r��6�� �lcɥH��rE�̯��2����@x�!��a8���͏�QVr�];d���v�S�l!��D��t� xk����'n�<q��
���a�.�(�������s~�4��
(��me��68H�|�� o���x@�l+!�<4��Y1�=�
߹E�S�w_�Z��(��Xn2�
L�{�j"��`�-~�^G 0� G�ߎ�a^��2�� �$�| gk+J����)`��#�*���L�b/�!�*T��d.K @�h@�^'�_�1��*^�a��$,�u�\1>��3��Q�yq�me�.[r���պ:]�6�؛V����}�&_ˌG3 hjS�sf5��0��S�:�=
\�� |dwc��#w�?�5z��W�iܑ��<dx'�G����� `Jj���ه��؀H���<��Ć^�1���� �x.�P�{��B���jR,ؤą�Q"@@��PxD�����;��Q]h]�{�܇�e_]$%�3� H�hEo��i��^�z�=<  �Ez�����B�5qhe	WPT�if���3�=K;�`��ėˉ�;"  ��6�߼K<j�u! lhM�w��S�v @�羥����Z�~^�{�H�rA�#�B�yO>���3z?=�q��E��^��v��'uU�D%�Q�E_�Ƕ�1�1w��W�ƙKօ���1$?I�rv�K*�!� @PP�����]_ ��  x����>x��@K d���~2�)9��f���V6
'�ytM�jiG����~-��e�cĿ�G�F�K����;�]��?�hI�۔������od7sY 7,׹Q�?�`H�W �5�����=���k<P].�-���o�J�M���v@d�w����m��>�2�� �ͅ�  訋ڬ�nS��Pn����E'�8+�>�B�;���:�@gha#��"$�`�	�@JrY�!,E��$���8����n෷�{w�W��w���w�\���t)�n�Kv�f���յKW�n�&���M���d�K���j�E5H�1Ū�wk�DLC̰�eRp�m���˰��ӜC@0�e���{H���\%L���5�Tr����}k V̺��h�8�v���P�t�=�XSf{@Md�v�y�KD�11�r�#1S�n0|�)�7���6�=bRC���I��]ʸ*�%R��N�;Ю?T�v� c� ��TQ�b|ٰ��5�%G�[�v����fM�BQf
�lQW������ڡ���~�o�ݠ3���S��1�aw5}��K|���:���Xj}w���1�_e�	eֿr��ޱ�� ��y|8�(_�i��H�m-�d @� �=�~����j! ʈ����@�~#�_��>)����V�pP�)N_Q� @��������]��ڼ H���2���v%u=����C����B�<!���U���B�$�2�9�<;"#D�FPe���kNy���;Ͱ��Z+���!@��'g�Xfc��ڂ0'D��ҒK�2���q ��U�!︝����:7V[��e�;Z{�ɆRNnPG_��od����QAT"���\�M3w�nۧn˞;��<�`�6-�ܔmh��H�G�`)��MZ���D�Q�������" �U��m�ޓ��Ի�&��W3��G��e�&Nb
�X����� �E`�G�)/��M���n[�Nh�9�����#s��x��t"��.�!��3�}b67�u4h"���E�'�xd \�,(S��s܂B�"���G���{�:yޣ�;{��{���أ�;�)����;{ޣW;{���.^w�?���p������7����o9��\;@� AzE0�"�&b_^3�%���<�qb6���!�K��<�"y����3Wh���&#���������D4���2k��*��<��]���m�����s܂yg����mqe�̂P�P�$��;�}]��֫k}w��}1h=��l�c8r}#ח�ߙ�f���]�g����^�7v"aWPf�X(�`bbs���)U��k���W����.��nV���T�q0�0O��@��S��yc��o��/���<ۃg{�n/�(������(�ʉEoN���R�	��]�I]�(3T-�=0��LK��G��n,e��}�����K��;��M;����xH�L��Ѧ�c�Y,
c_�[��P�v�M��v�))�V i  �;(�ujO��:��{����Q��'v��Y<4�3��`���/łN��? zgY@l�8	1�"  ������u`>?%  ��;��v��� ���r����w����jaeV�B�,�P�U�|7��������_��W�_��xꫧ���}���ş���}r�>�������N X �x� �����0�1�>�
Ɔ[� (_RV�z��ti��6���� *|BB�fP�a<�ߟ�Y��(�x�����:�O|t��l���s-9D]��p�L# ZeJrBR��QŴ��*��  f� ����!�= (wV�_٣�6�-o��)�')W7߱Pb�^iR�i�^������,����/GG��~���^���^;�Y�  ��l�g��AP>�L����?���  2N��V��Փ�o���5WnZZ1�˰b5W�:��������n=ڽ';x�?����))){��a& �l���?h  LU�\�_V�)߻��G   �>��C������wz�n/��Ň^}ڻ�k����  $K�*����=��5�	�de�)z;8'۶Vr��l.��=�%�P6g!'0+��?J�
 ��Q9�-a�NVK�̲3��=�������=�eS��xA�O(_R�bm X[���qQ 0$�,6���-;s�ޭ�U�V��-W 5���Ԥב-H�U��	�d�� �_cyٙӵ-��-���'eJ�X;�'�c�+���Uk 0�XR���P��
 ��p�'���`�
%Ǫ�*��b`�1+z~��bI� ��@��roe !��ʠ�UF~U�rM��B��9�;K� �~�|X2.���z��  �7*��Y���]�c���v���X n��H�H�X6~g�*�Z ����A�x|Q�X�G�� #J��&W�� tu\)]"
�Ay�r�2��� ��V��rrX�� G�  ~ؐ��+%�+g��
eP��ʬOX�iA(��U��o���<��ޤ����!�r��V�U dIy��VYq��.��P���oE]�K����<n�u� 	&�p�aI�U�N5,DYV��� ��9��-����Q�&n䈨+W�+J�Ǖ+<��(�Yy�2(C4Y.�
t��l�T�#�*�rLԕ/l(/P�*�+���(3�'��2R�/�(����SY������ v�%���,Pk5�w�Γ_�����.eIY��/�lÚU.�r~���
T��6sj�ϧ��Ы~�g{�dA/v�7��@�	� �����BM^��H�Y)�ьT��5�����&{m�-M��������=u��ԩlS�=ʂ���S��e��2��~㚲�S�J��T-���]fv�ʾ슕e�2��PnT.W6)�*�T.U�+�jʹʥʥʺtM�\�Z�\٪,(�ʨ���7�� ��6�(�O�e9 � �vD��   �F�3�w�]Q��e�2�lSf�m�U�5ʕ�y������W.U�����+���/��
�쬦�S.P�V.�k�:�
��쬦�K�BY��j�����^����W���y?�ܰ��5O�ox���G�o�����l����u{m��EqY)��*_J�c">&�#���È���/���f�UM~U���ɭ�-������>�vӫ�?����a���I�  :b�$v��"PY##7�t�;Ί�J�WXvS����}��?������|#_S������|N9��S��|3_S��|S���%�v��C�qM���U�#���1�S���I�6ʿ)C5)7S�L*�R^�|@9U9W�\٨��lT٫,g�m��x{� \��
<*{�Ӕw*�^a�?��@*H�o�c��S�)�ʒ�K�I٨�M9]��r�r��\�ʤr�f�P��	p��^�i�Ԃ�����4�ȃ(�2����#)�\. ���`wp��5�f�4� Y��@̲����2M�Py��\����'�/+�V~��J�����^����֙�r ����K%3CeEYV���ʬr�r�rR�!�\.{� ��  �x\���ב6s*&1�(��y�ze�����BJ ���'���͙2�S�> 3�<�� 104�p(`�3�H�!`��L1��Ҧ�6W	FF�� �*�c�)g� >$�E��T8%��_J��D�)�x\��݇�s�JW�E t�˓��m6@�f~�_6�m�=7]�->پ�d�����ĺf �O��o_��.��]���m����{[/�Ӿ�����յ�^�|��� nN	<^E��P�ErJ�&u��A�õ����
L���@<��1�B0d�Ҫb���������pX�|�#J|@�^���գr��r|L�����r|L�G��Vb �L�G���A	�A� ePJ+��Wڰ�`m������upOd�`ػ�.z�?��?��j⑨Y�̫�<�$X�H�

�,s�w�Ԃi���%��\��:`DY��7
�5񇢴Jg3��3��j����7-A|<V���4f4y�͠�H`5X怙`
�\N��1�aSjz8dˬ�~��l�/I~� ��)`&��F�2�|%�Y�����(�Sj4'���J�7|JT@�M�)X=�%C��If�K1�
���;R��S�6ސ�n       [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://chwvicwgpqow6"
path="res://.godot/imported/bouncer_sketch.png-7d31320024dd3930eda9cc7ab4928e72.ctex"
metadata={
"vram_texture": false
}
      GST2   @   @      ����               @ @        �   RIFF�   WEBPVP8L�   /?�g�8��h�����W��2#���P �{G�b�6�g��� A!�?Z ��f�o MKPo>�2nj�v",`Ⴢ�gX�@��B@r��8`d�C��w�Wضm#�t\��	��Bu���VB�n ?��W;pJ���p��I�����-P��
V�����}��J���������y��I:����      [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://t7lbai4iwbp7"
path="res://.godot/imported/floor2.png-4393d21020c08eab7ab135b5fce9b317.ctex"
metadata={
"vram_texture": false
}
               GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�m�m۬�}�p,��5xi�d�M���)3��$�V������3���$G�$2#�Z��v{Z�lێ=W�~� �����d�vF���h���ڋ��F����1��ڶ�i�엵���bVff3/���Vff���Ҿ%���qd���m�J�}����t�"<�,���`B �m���]ILb�����Cp�F�D�=���c*��XA6���$
2#�E.@$���A.T�p )��#L��;Ev9	Б )��D)�f(qA�r�3A�,#ѐA6��npy:<ƨ�Ӱ����dK���|��m�v�N�>��n�e�(�	>����ٍ!x��y�:��9��4�C���#�Ka���9�i]9m��h�{Bb�k@�t��:s����¼@>&�r� ��w�GA����ը>�l�;��:�
�wT���]�i]zݥ~@o��>l�|�2�Ż}�:�S�;5�-�¸ߥW�vi�OA�x��Wwk�f��{�+�h�i�
4�˰^91��z�8�(��yޔ7֛�;0����^en2�2i�s�)3�E�f��Lt�YZ���f-�[u2}��^q����P��r��v��
�Dd��ݷ@��&���F2�%�XZ!�5�.s�:�!�Њ�Ǝ��(��e!m��E$IQ�=VX'�E1oܪì�v��47�Fы�K챂D�Z�#[1-�7�Js��!�W.3׹p���R�R�Ctb������y��lT ��Z�4�729f�Ј)w��T0Ĕ�ix�\�b�9�<%�#Ɩs�Z�O�mjX �qZ0W����E�Y�ڨD!�$G�v����BJ�f|pq8��5�g�o��9�l�?���Q˝+U�	>�7�K��z�t����n�H�+��FbQ9���3g-UCv���-�n�*���E��A�҂
�Dʶ� ��WA�d�j��+�5�Ȓ���"���n�U��^�����$G��WX+\^�"�h.���M�3�e.
����MX�K,�Jfѕ*N�^�o2��:ՙ�#o�e.
��p�"<W22ENd�4B�V4x0=حZ�y����\^�J��dg��_4�oW�d�ĭ:Q��7c�ڡ��
A>��E�q�e-��2�=Ϲkh���*���jh�?4�QK��y@'�����zu;<-��|�����Y٠m|�+ۡII+^���L5j+�QK]����I �y��[�����(}�*>+���$��A3�EPg�K{��_;�v�K@���U��� gO��g��F� ���gW� �#J$��U~��-��u���������N�@���2@1��Vs���Ŷ`����Dd$R�":$ x��@�t���+D�}� \F�|��h��>�B�����B#�*6��  ��:���< ���=�P!���G@0��a��N�D�'hX�׀ "5#�l"j߸��n������w@ K�@A3�c s`\���J2�@#�_ 8�����I1�&��EN � 3T�����MEp9N�@�B���?ϓb�C��� � ��+�����N-s�M�  ��k���yA 7 �%@��&��c��� �4�{� � �����"(�ԗ�� �t�!"��TJN�2�O~� fB�R3?�������`��@�f!zD��%|��Z��ʈX��Ǐ�^�b��#5� }ى`�u�S6�F�"'U�JB/!5�>ԫ�������/��;	��O�!z����@�/�'�F�D"#��h�a �׆\-������ Xf  @ �q�`��鎊��M��T�� ���0���}�x^�����.�s�l�>�.�O��J�d/F�ě|+^�3�BS����>2S����L�2ޣm�=�Έ���[��6>���TъÞ.<m�3^iжC���D5�抺�����wO"F�Qv�ږ�Po͕ʾ��"��B��כS�p�
��E1e�������*c�������v���%'ž��&=�Y�ް>1�/E������}�_��#��|������ФT7׉����u������>����0����緗?47�j�b^�7�ě�5�7�����|t�H�Ե�1#�~��>�̮�|/y�,ol�|o.��QJ rmϘO���:��n�ϯ�1�Z��ը�u9�A������Yg��a�\���x���l���(����L��a��q��%`�O6~1�9���d�O{�Vd��	��r\�՜Yd$�,�P'�~�|Z!�v{�N�`���T����3?DwD��X3l �����*����7l�h����	;�ߚ�;h���i�0�6	>��-�/�&}% %��8���=+��N�1�Ye��宠p�kb_����$P�i�5�]��:��Wb�����������ě|��[3l����`��# -���KQ�W�O��eǛ�"�7�Ƭ�љ�WZ�:|���є9�Y5�m7�����o������F^ߋ������������������Р��Ze�>�������������?H^����&=����~�?ڭ�>���Np�3��~���J�5jk�5!ˀ�"�aM��Z%�-,�QU⃳����m����:�#��������<�o�����ۇ���ˇ/�u�S9��������ٲG}��?~<�]��?>��u��9��_7=}�����~����jN���2�%>�K�C�T���"������Ģ~$�Cc�J�I�s�? wڻU���ə��KJ7����+U%��$x�6
�$0�T����E45������G���U7�3��Z��󴘶�L�������^	dW{q����d�lQ-��u.�:{�������Q��_'�X*�e�:�7��.1�#���(� �k����E�Q��=�	�:e[����u��	�*�PF%*"+B��QKc˪�:Y��ـĘ��ʴ�b�1�������\w����n���l镲��l��i#����!WĶ��L}rեm|�{�\�<mۇ�B�HQ���m�����x�a�j9.�cRD�@��fi9O�.e�@�+�4�<�������v4�[���#bD�j��W����֢4�[>.�c�1-�R�����N�v��[�O�>��v�e�66$����P
�HQ��9���r�	5FO� �<���1f����kH���e�;����ˆB�1C���j@��qdK|
����4ŧ�f�Q��+�     [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://dpcjhop6gth7t"
path="res://.godot/imported/icon.svg-b67cfb692a937e61d2bda8561d9e8db7.ctex"
metadata={
"vram_texture": false
}
                GST2            ����                        �+ RIFF�+ WEBPVP8Lv+ /���(h�FJ��'}/����d��
4�N�&I�%*q\jY؜Y?�*$�R�K�m Z��f��jiuF�<@�_��Hm�m��^��@��ʁ������lk�-i��q�&�n�Nk�=8q��3�;��YUu^W]u�W��=ڶ�H�$��ԑ�9�G#aH�Do{���}�����W^+�_K0k��`	��DMi$�<��1���{�7;����}�8��E��M~�����_wo��M't�p#����%:|4;���N����p�m+�Ĝ,۲6�l?��{B�m��k���&����v�I�m��{�����H'!4&��#� ��(*AD��D��xGl��1 m��!d�Y��權��Go�mg��m�nD��|QTD��$�!@?����II�����j�bEe=�Z>i��,͇if��
�pUg����" �"�2���m۴m������O�ɶm,?m۶m˶mO,L,�^ö����j+�m�`��v�)J)�����~����2�^$$i���/*�Lm�H���t�%]�uL�
ݰ�����m+��U�.�����z����m�Vl۶�=����J�$�l%�H�#nI�UK�T����������Qz�����+����������q��̼Sf���*��>��u��b�N||v���C��@���]y��,���Q���;�D��~��i����O�c� 	E�@`��#�k�8�ⴁ��lQl��k���S�rx�ŲA}���9����li�{�ؗ$ɪm۶��NX�L��#J)��R���Ҷ�Q���׍.P���"�,J`¸@�0ETA��
���9��h�g,P�vlSu��k��f۶��v�m۶m7��m���Lv���%�
;w��b����������7�苢�������э�v[�����)���)L$]K̦�������Y�9ϝ!���m�VR�[(0��IFJ�J*�eq���m���K��m���f�eϮK�^.{'N�w��loזɖ%�����À������Iʁ1�O�����(���7�
C��c�ʌr�e�Nܪ�4�9���ɲ,���Ѷ]��I2R��EQ�R��uA�v �2� �c�0�MH!X�/�=�� ��aa`�n�e� �;�P�JЅ)�CX��He��&`3��L�ܲ	l@���+�V؆!ԡ5�@����`z �Ё�� mف %h�1� "Ѓ.�+�]؅�-�A�a	zЂ  # u��$�;`�p)�>m�ӓ0��J�]hX�H�" �� X�В�^��؜��W�������1X��Gb�_�S`,��piK$���ʻ?�zR�F3��# `�SI�6���S�0�\�s��hՃ�%����=ԣ�N�|�;���m
 �!����5Bc�����f�I��5�d�%[ȧ� �	�S����s������X+����v#�,WZ� ��|?�'�N��'E��D������|�w����7�S�?S��y9{�"�0�r���j]I�?- =4'/}v�\�8Є:�C�͜����
}��
P� з\i�"�^HR-.
MH(4�r,��u	�p� {�\��5�b�D ]7-R�X�D&�����V�5�[b:~�Ѐ!t`��Mtmv!��;�Ct�t��d��H�1�.�JRQ�	/���X����ʮ��͟�]��Hl�a¹Q��5��'Sy���h퓢K����A�J���M��t~���P>/�'�����%i�0�&Tl�ـ�Cn��ӷ`�R�^ J�� ��$y�bjq�$��n�| 
MX<l��w��~VڀLa��n���n+������B>i`�p�ЪW�>�]��������à�zt�K�ݟa��ޞY#z�H�*)8��@�j��]���-����6մ�@> (��$5��͡&ԣ�zR�=�D�֓j��?C��b�!I�Fts	Jp7�aز5�D�8����r��(jq���{�[6�ɹ�@t٣�2�fu�)$q�0� 
M��w���ۇ�mP� p
j	M���u��9������T�߹Տ�q$������9(J[-.*�"'����`&�&[�&�a��ZO�zt���̯���N�hƚqRhBR��?��{T���X��g���nceW�?%w7@	�A3��r5E[ �؜��U�������!�}�wgl�+�,[[*�X���\���n�>O�������@ߖ��%
�oA��L��1���t��W]��մ����k0�m��:Y�V����vw�W^ } S؀`;���  RcU��\�llN*�Z��� �]g	l����#��Xd��u�zR�g��saY�^>�����J8�r8�%[��4��┘���$C�-:�	3�ry�؜�����.��_�,[T�%���/��7ܶ�����خ�ܠ#�|���3cT�*d~�*4��/�2�୮�-�egu��e-m$��
�t8O�K:�fP�&�^�#��7[�S��R�%w� e��M&��Jt��r���A�]�r��s�a`
w�t��:`ٱ�Dp~�YǴ� �kz����~�a�&{���%9�
ki#�+6♿���2�� Vl�&�pҶ� ���i��\�����R�{� � >��I�G�6z�i����$�����`SK76'��6�chbs���h��^!���|��Z�ɝٳ�G>�ol�r���������2^=.��f��3p��v�����K]��|rg�nC
��S+����+lA��E�=��;=��%+���VPxpjM������P���vS�ӷ��E sx�֘��w��[!e���{,=��O�&��W~�"<�܉K���O�����d2�C��>�`˶�cXw�K&i��>�r�	�9��Z>��˵�g �`Ҷ����9��a�0��z�)��"�a Hl'a�s i>&t=:L߂c���>K�MKU{� ���v�d�x�B|DvoT|>��
��[B)� ��g� ��m���̯�f�?dT�w�`ֶn�|C�����Ӣ��Ѐ�u׾�T,�|Z���E�ݾ�R�_�89�ew!�C���!��8�N�&t}���Ҧ|^�����X$�">�"������� ���@@t�:�Fmh}���ˇ��<�{����ǁ��14C�.���a�d��tMj�S@�WFF�=�4���}�����a=��=����,6��� �' f����Є/��r6,gC�pe?L�@���)1��=]{J�qu	b�2�UI{�
Z��eӷ �o�]���� ��A޶�1��~ gO˩K�(�n��N��Riݟ!�w�9�ϧ�1����h.�9h���f:|Z��G���b�'wϐ�{	 ��_��������b>�	�z���� �u��]�׀�X��n��W�������=��>`
 �}�q��W3*��?������i��5���[�Oc��뻑g��9m�A�h��K]��T�c�,.���j�E#�	b�x���������>���|�`���d��1��K��M�&����$Aw�J���b��u�$��]1?��4x1����_�X� .�uha��
���d�K���n��ہV�e�kI����f�K5�ﯦ�'Kl҈n�7�-���{�$:�K5mbs]��FKn����ϐ�Ȳ�l�(�8��&��$�"�k�u�{����&W�y9�a$�kP���g�Rc����!��7��+H`f�z��%{�����(�'�!1 �dپ�&\���\�4��`�*��i��"5��f��Oɱ�O���r����=+���-p�MO7%�b��*s(��#Ϡ��릑g����y�.ٞhD׉��n �=���Z\���:X4'?�G%b�=�؆�!<�j�%4W䬊��vS�����9$����T�l��(4a��c#�}m#��Hw!�݀*p\" ��`\B��cq�X`Ғ��5S����X��� �����|R��X�K�{�����c�����O4�����d d~M-.֓�X��D��S�Nv6[3 ��&�)�}��O˟��~�i�il�k��Yl��C��;0�.W��vxwЈ���(��=<���w��f���3,�@��:t}p1o#x+�Z= m�����Cl�S���v�j[��M{,B���J�NLE����"�Ft�#rnI��ztX<ݟa���!=���Zk V[; ���y�R��f R8��<5����ﶂ��`!�5{��=<{���؀\_�p��n@	��e'�Q&(K�о��n����@ڰ	���3���0��A�nxd#�SQ9N�0�|��ׁ4�^&>�6�4��@�|+�BL�� `�|P��L@��Sb*�����N����q�Van�RH @	� BE�<{k����g��`}7�O�xd*^<-�G�zt��9��N��+���R>/;A�v�@�&$��4@ۺEi�(��X�]�ܿz��!��P0�:�^ex*lA�p �j���w-hۭ[ ��u��M�1.���Z\�ŷ�T�|+lB6 Q 0��{߱`!��2A��Z��S�
s���Cw���[Ё	� 0�t�0�_͏T���}��K�I�K�,���p�ts���0�ɱ�w���O�S�������ưJp
�' ����5rw���-��5��/��P����	#����P��m���s��;Wr�T����v/Ͻ�����g�bW�,�?Z���} �Ⱥ���t+�B�zcs���N�̟� ��	؅���j�����K��L�-��\�������¬����Y���}�&��|�ݳ�X��T$�">�tBd�u����ڱM/��Ջ��y�_�=�-�2�;�l<^��]py� �..�u�$!��9�����x�Q�H�O�Qh��]?h��f{�|?��ʕHw�O�|����N�1��YF	T�C�%�|��ߊ+�a)�u ��,�؜E��c��r�#>q�3�zp%K����O����`a�ق��ys �>�n[�f�e�G��\�|�l�	��Ѐ.����x��fC���T\��;\>���,�����;\��P�I���s��A��T%����b=�����%�v�.Yb*�c�+#{t�"�86���ZN���;�q��,�v�t�$��p��������ќΰ9�`���rt+:|�TaS��v9W,ۡTlAjZqW�1�-����QU��R6�J���O���B�?�w�lKosqf�M  � `�뙶 M��x��Zڨ��R6�]¾ע��j!7ڄ����0ͱ���n:|_q�:��]���y~����$&�/5(|�FyļO�)�����|�� �pי�0yT_��]P�3X�X��a�����Z@�X��`!��o!��:�s���S�m J�����d�����I�8���ףC-.Vw]�F����g(U�X�Z���]2�%���n*�Wq��z/�����a	��Eb��:x�<8�!��ߋ��.�~ݜ�)1*������Xjsa���*��!�JvJ5m�cq�8�?N�Mz83Xz� �V�Tj
���1X�AB&˙�"_*�2Y��g���̯{�g��|�s8V��X	�e�֣�e��(=T�^#?V���K�{��^,2�7�
��a=q9�`
]x�b���(��}�ǩK�	x*0�[�)��t��]��<��M���]�B>96C-�n,�I�Z��pV���1]K�oY�)>��P>��|����֡ch����0�j��;c=]�\�x��񺟗�}+1忒�6` �Qx�WA��6w￱9���Mj�:��l�� �ܣ��(��3�ϧ�T�<CШ�9_,�Mz�Q0N 	p� ��������u�2�e��j{�RL���z�	���_8V>���9S9�}�������~X</���G��]tɀ,Hcs��w�}�>;����O�ox�++T��x��Uk����`�3�zP����v����OK��5΁;��H`79 p
9^"
+�� �f>�� ���
(z�  ���e/H�#��98V�(B�-�Ty��P�t}��T86�9�ϧ��r�����洞+���%L�AMC�v%��.I�W��o�<����9�ʐB!�d���s��#�6ʫ�(�>�`3�m�I0���e���N�4�$$�C����-B���[*<� �d�*��"hU��w@  @��lM��� \�A�65�Y:���0���Rױ��#�\�}i�]@b*�  "�t~����'ۦ�N���Z�+�G�@��,�̯�پL��m
�l�W��z��"3���j���g���r�?7��݆Ft��\@�ɑ���aNn ^�Oxߩ)��M���f��꤉������|0H������,�Mp)�Js7u�A��C!���}�>�Z�ǥ�l(��h�c�)>�2�������Zڬ'�ޝ([��Tcc��<�k
�Ȏ��������5��1���;�U���u�]����}hD���������is+:l�v����G�e�K�P�-gL�����ѡ�3�\���f����`9    K �C����	@����JZ*�z���)zv��g�~7u��:q�`	�2J(ڗ�8�oE{</U�f)�o�����I4�Ȳ�ϧ\�=q�ee?(��A:��6/���&�ŨvW��c��׮V��տo�W��j{7�F�8����r;̤�[A�\�@v����^·���:��-����a&Z���B?�{��T�>   ���C����aj�vC��k�#�R|��L>�G\��8n����0�������f�X�%1C���l�I�ߡЄ�KX�u��P&��|:|��.���/�k��]l&�]�L~��?$)�� +0�)��4���`��� ��9��v}��t��i��O����⫛w�L�}��
�׊� ��	��E+�?�oV��#�]3�������]Y����uZH� ��� ��[3�z-.��#��D�o��:d�.6gJ��O�&LԡT��9,e�r6�'EO7�8i�����x���?7��4��W4��K&��:a�A�>�ˇa+�t�A�ն�G�@L�a�]��o�z�ր��aO�R��! پ�w��� Z�S E%1�H  �� tp��&	@�'�8�倂P�c�(_K'V$$>
��3�,;��n�D<	X�S]e|>����X�u3א�̯m��[��ӗ�xz�)�w������C@b*Ԧ�H�!>��)T���Ӳxj�HR����������A
�L�.T`39�S��f�a&}������*�*�r�X��S��]�W®J�*,C�Re��p�s��L߂��z?Hķ, pUĭ��lx \
����ߣ�"��E-�al����if�t��PW���[K���R�MH�e8�L�鬗x����7z� Q��B>}�6_l��}�����}�v6<q��.HL�p�j���2�����bs�؜�[(��2�f�ky�/�=-ӷ9���$�R���������pms�K�ߢ��Iȁ<Y�K��\�t��O=���!��7�6�aN L���HtIE|>���� �og2 ���< { �z .   �"���Gܙg�����O�K;!$���O��`������!�n\Jp7� �q��)V���ڪI��A��쇗�E-E�űy�_�׮SےR&�0Q��gH��Yl�D�vlD�plԳ���B�*�M'��u�e�؜v������mu'̤�w����)��8Q���p�0,��2<q��o]�e؂1La#h�>Ԡ
eX��C?5Vc�P���t�d p�2�d� @�i <�P8�O�8Ӽ����j�/ԏ�L���xW���$1I����U���)�B�֓J�<��!�w�9~�A�$�>Tv&���%���tK��ذ)�|�N�=hC�ĵ���H-A�$?�ō�s��@a���Z�� 
Mx�����&��P��|����|Q��׺>-x/��Am����EM ��_D` ��� ~�o8����MR�e ��� ��� ���C ���x	 T��`�����:�����<�?'Vt/uUz�߹∽,^c �r�9B�fL؄.�¹��ۊ�R�}�0��5����Z|�u�t+��r�JU����
�p'P�Jp H��w��f�E�� �'�r�0�=ͥà�^�:��|�2��y�펮��y�����c���_K�w���zt�ѻ�A{�2�̐8p*  x	 ��+h�p" � � � t( $ h�����
 c ��� ��� �6���-9����3Wk�����>	7�?Oz ���k��� �k�]i�珄d����A�q��Ga>���A�o�?yU����kis�ދc �9L`~R��T�ux3/ז�a9jq�UR}��\�C�0Q��2T�E?��C�c���X����0}�*�6�!0�S .�
G+k� \�_��� ��@M1��@�E  �p<IR��+����~�f�c36�T`��e*�R }s�j
̢a#6�v�N`!�($��R=4�ɟ09��zRT�1�	�l��v 0��s؇���@M��P�LԡЄ��p�����!�(ߧ��IU��v���?NK�PM�W�˾�R��[8��N��.�
N    �p ] $ (! 4 L���b�Ȥ�g$�= Bv&�kϯ�z��<_��Y��e��+������:!Y*$e��P�= W�w������T�ĝ�q��k �˛CX�*� @
U ��6y�}�e�k��& S1Y���f�K��E���vS��b��؜����@�L�v,ڙQXU,   `�_ @q ���q� 1 �	�r�LY�L�z�jꩶ  @����B�J�[1 ���(����B������*�GГ���7��~�5bIj�B��:K�v�|�����r�p�T=����*��r�E���chRc5�^�`5�.@�H����lPE��a(4AF0w	gO��%���Є����s� 4��Nr&S����(U, ߢ��o� �0@�Ҹ]/�D`����̶R��;�����y��E�
��_@��ۈMBR�f��P��竀}h�@�ۑ��²�t'\M��Oˑ����V�c�����M5m�Ѝ�i����Xo��4���-*2��m��9=p���/��?��F\�����8|~���R,�eP����d~��3L�A5�$aњ)��5S  _hQ���y�cXz���ߊS��s�iyԵ<ꎥ5��UUA����Xt��ڙ�p��� � � ����w�M�\������+ }s��# #�;Y���P�m�8��WH~�R�wB=��8�,�!�-��{�n6�����w��H�.��%���1"G��s� JY~�}]ޜ�[%\���1�����춿�
o�����li*9ɱj��3J��2{�,4.�dڙ��?��<�$K�	2�2���t]����=�^��}���Z�~�(q�"%�V���iucX��]��Qw;�t\�55�/U%�]�aQ/�>��
�S�k�xc�)�A���|��#V���:_��?O�Vξ�,B�-�!֮���k�W^�U�a��q���R�N�5U��,�$+�a�_x�}��D|(UAIP�g�`�E�L�al����W��'��>.�_��'���c���m���l�C4��TD�T�e'H��	  p�Ch�Cb ��C �M��*�6���ܼt<:w��1���ekmz����iö�OUv���4Zİ
e8�AK��p���> ��ޕ���q�u��5_�vɂ�ա��o���>\���}�B0л�G5Jb�f_m�7����I��7��a�jq�f>�Г���/�z���g+�����G�1���!�G��Jg�K�%&6�	 �SP%b$�G�{��k����j��q�"�l��7����o^�2�P� �6,�I
9[�����T���$0˾��/ �eB��Q�[���N�_O�o���1h@l�|�\���i3H\��z{� �ݿ�x��a�\}▍��˄�/���+A��; >���I%UӦ�HӒ��B���~o�;���P���A����?ó�����)�t�  ����S��j��ї�=P�+0K`���I�v�I'�Z�2/C��x�o Nމ�o�P���&������)�$�I��w�����'ϼ~W��~p���_����G曠|4�� ��S�L,eC���d�Jf�"�[��[Q�(Q��W���-)ldD�#���
�A��m��+ڌM��Ļ$w�o��j���]���]N���q�O��64(�"^���{\�F�A�:�yI��7��xd�q�������/ܿ���+_,���G���/0��ȲE��(�F���q�sꬸC�;��k�ߚ,:f��H��a �s�uF�$�)�.��#ٕ�s>;�]�if[��Kn
��zi'F�5v��m�����5��m�+��\�cXOǅ|
w�|�mS&�^y|�+��m-9]�{�1�Ɂ�K����#����n�y�؇-���Uh6�� �Lx�DZ��Έ����Q��C�� p��,�^�ӡb�._��J�ya�ْ��� v�05�Y������6cS�vG��#�l�����e��J�o���R�Rq\v�t��2�]:T�r���0m� xt���r��C�����C&_��� ���q�m�:�?]�%�Q��bx�Ђ�?C-.���Lay����y<�+����d"�Em1פ(�^��|��C�~������?�tf��H}_yQHa�.���`)�05R�[��{��g�Y���Գ��zv�F��n��j����/�8�8��#|�'x;�auk�	��5��;��r�h�k�k�s�Z�V�t�������kr�b�mѾ�ه��s�� D����h2.���he p���[���������I��!����߿;�|m�y[�)��E�~p�aJ�{d�Y�O�o�GL���L��ң�����߂����"dV�:|��C`�N̡!���&�֓"9���?;�>�`������(��T>�����T�p�����W�����q_�> {A|>������D�f#�ˉ2A�{�~
:�[� ���A� 2&�����?���*E�b���f�ʌ�+����L,]#�^�E�"�\q�/l�Gӵ;����R����t.�f�A��jڄ�]Bd� p�{^�}����֫w��|�z��Fye��r�|����?�*��Ɍ����=g���Ό,�W��������(D]N� �x�xr�"��&��BUQ�$�������>�ڸ�|�!�l[z���^�!�d�����K���q����|�|��|>f���w߷�_���VnŷE����V�N}��yF���t��`��ѳs �����_�9Qr��Jу��(��_���$�	<|����o���L��؜���'ա��Ϗ��z'1?���g>�>��=>����CV��|���o����|����f�9���D����O������~y�g��,��
 GNa��t�9��uu?����mako���g�|��\qǬ8v���⽹�⣆��n1�c�b��96�cC8v�|����G��)����^�uu��fF�p���4�)��YM=[��_�"$��n��3��m\�^��(&Ό3���3���w���� ��a.�:�K�%�P)0�}U|~�q_q�}�w�;\/�^>r�|�k�[�T>���֪�~��,`v�U�!:��f��:R�
��bG?<g�ix�ٴ|߫V��p���o�\��n��5���� /N�!&5��Jժ���l�� ��� ��oB�;��96�c�����7�W���jg�BAp�H}_xD3�� ����zlQ�;Z={���\��J*%��7�/�/��>>ռY�q�]��
h�7@�?�9h[���op��?�O��3�����KN�@~�=�~�j�A>/��=����*����>C��p)U @71�S��!��Ͳ�v"IY��o��1s�0�L�˻���)-���fI~�)[��9l1L^ 0L^�Ö�~SQ���^tV��-& �f\ ��������dҹ���"�ǗS���	�x�����F`�^�BN�<���ۘz��O�9Qg�{�|�U{� �o��K���%�ٮ��?7C�_� �������#�c��f	oڬ��D���7v/JM�"�ǽG�S�_���1�U�����N4?�� �؜�N�� ���3>�����
 �p  m�4���j-||mZ��4W��a�����%�i��5���f�>�`3.F�W:���n� �;�c�-����a������� `4M��㿼Ha~��Ub���	���|�8�*���OÍ�6�w7?t37�����mψ� t6 t3 ݀_F�8��Xv����- ��R&�QP+R��Z�l�8���i��h$O� ��О*�V*�o�{a�f�X�+>C��X`9g2~ג(�(   j��pl�'b Z�;x�)j�ֿ�F�� � @RX�±k��+���� �5q�w(2 � 8W4ktA���ޕ�~t;ذP�
��[T��<G��"1�D�>�4@+��3��� FJ�q 3� A���*�|G�C�b�A�d>~(��:�   ��p�8��*=���l�8m<6��L3�_���8�AP�������q�lHղCL*�68�� ��g�3��Y��[ﾯ-=����� `���Jm�w��m^�q����!���e�n�1������8���u����h � � �8�we��u��w��3��	  ���{�.i͈RI��  �)�2���  �K�n>`�4G+��o��"L�A/l����9m�Y#̶�ċG� �3�M��rA`2z  �Q+d�O7���� ���s��j\J��j�y����(']/��1��z�(@6O�g��-3������nz��w�/7�S��3W�s~9�h�Ia�.ո���t���3�s|�ۿ� � �AY�Y���L�&Cʉ, �ڵ��v-��x#� {��m �#�� ��'�+k�����0ya� ����=I�Gt�rACΫ/x)��y�1�8r���#���$���~�1{���R�VtPulI�ŭ[%% | ��/�ߔ��e�9�uղR�*Ko�O^ �O^�5ռ�����t_�YQ���eBlH�Y�K�<��n�Q�+�ʏ�r�5L��g�������Ǭ~�X�r~�;v�>�@׵Il@G��41�}��J�����f?M�<*�Y�KA�Q�͗�c�H8�3`[�y�6``{�0�X����]���(���Ё� �Ny�}$�Pȉ,TK4 ���W�.�S�P���yI�*=4��b�p+Hn�ٽ0��e�����v�J/w��Qح3[7d��w�rn�ްA3�q��K������ߤ���"86d�$�%��U��۾ʼB��(�)��5HKZ�
O/Wyb�d�� ��U��;G��^�C�L$�"� �8��s@ ����g�6�t�Fl��\�Vi?���k�>�Rf�(ʏ���ʰfw¬f�A�$Jd
LQI��o5��r{; ��v�,ހ+��e^��d�.���o��1���p��fplo�ð�5i�)1# �0@t��9H��M�#z)/&w��P!���iW����]L>�$�?��� Z ��_�anOo�� a�8�)��E�� ���bLļD����� �r}t����C\�T9NA��[���ƌ#�c�e���1�͒t��:±�m���-?�����&�%:�}p��64"����$��HT�����h�l�<aÿCg(�t t�l����&����6��uܦ]�,�<Y���-(ј?-���&s�f�׏�z��AV+�q� @;�+�6�$�e���Yݣ��4��cs�=����K��mu�B�'��h �c�	���7 �[zXf�R^l.�%�!����&��Yޗ� �jp@ ��=����F�wn7԰���c2���W�+ո���9	�ju��H�K�+`�`����tSn�P��1¦E ��$ 8*��&Q:�1�uY�ãV��;(4����p����6�ХM� L	#x ��Y1��w��k��T�IyF/���ީH����`28�|d֙ �>�8�� � �g��������{�_={g������L� ��פ�9�X�Ie�\��[x�/�NG+s"G) �-&$T�v���5ّQ�����ˑ�k�ު��� t���m�Ne93lF�ı��0/+"d=}�WbCQ����c�$�2�A�6`U�����ev!J=b5��1�j�#�A��	��D�4c�`0�.@�����M��lx4�� @�$۠!>*����|�bBu��M�|�W��i���uш! h��� p" b�EgV0]��[.�WN�cQ�|��;���g�De�_8f9*�Oj���H ��6�7��������7x[��|��|�G���4� �{�SN$`%?oN�����4�0}�/�k�̧7��\�L���idloB:�׊⊕�]{���f\(N�E�S?�u���Ҍ�ܵcm��.e�\8R��Wq��Nq�B�B@�_���t��H��0�M�Tq�)�8��9��+ T���i�|^�f3.�n]A��:n��>���$�A�cxs� U �n6T�&�w:q=)���B4�����  �l�d;�s�e�*�ʻ�Kk��^E���	t��-�l��Ѳ�{&�P�V}�1!6$��#�X�,���t� �м��(�����=}�����m"�R�^�μC�/�8������& %ʟ� 1x�/H[�Qb�p��m��K0�`9|���� �K ��?�۹����%X���$n_�94[Po�쓤��k��y��X����j�z(���u�i~6Z����^���]�9H ���E��ڎ�ڎ���-�~ޱ��[�� T�ρ.^��d�e[���i)�e�-x�K��x�%���\uIT>/�^|��G�g�P���x{	  
+"��%��=ȟ���ٌE�&Aϵ�d��ۖ��^�.C�|�f�=��뎹���ۑM=Y�̞,g�CNFb8�g@��_te�������S��+�HW�)CG}5�&=�j�  KqB!'�HL G� �Yj����~����k�A.�M�wq�'��Y�MXe���(�,�9"������<�ȉ����K|k����,�E��~됓��! "q � gFZ ��ڎ�^�фs�l�l'�uw�OiX��
 �ꫛ����������&bA�O ��`�E���#�������V_�Fp�w �x�Y<�{Z�wD|E���+�u���<����<  �\�3i���c��~�Wp�b�� ��%��zq�?�b ���@�6�E�~������`q����Ň���qr�k���+�~
���(R���X̚��»� �r�	/�ùb�.�U�K�{��vB?�`���DUb�����i�;�DXY��ӄ����M��p�"Ć��]�GB��@���8[i�c+�{���A�o����/�x�
�Z�Sds��B���U�$r���2U>0l�� ����%���a�D��,�_� �U�n�/yQ�51Iw��7Ĭ���3_NY,�&�{�I������N��S���h?����~��Y"Q ��	h� ��I��_ ��k��	�Ot�k�Ʃ��$�6���8[��3c�P��؜mv~��nZ�u;AR) V)��L$�N�cDN{ �PO��b�A��l���ݶ�����E*�B��Έ�]��J�ҽ����_��1��Gj�������8�$�� ک�y�f�W��ͽpw�Q����|�X �<%ʦj��,�S��\plVwݩK��|�=�ڙ�W��JV��!�yŮ�EOx�/D�P�?�l\��l:$w�����6�q!��q�Ͱځ�l�ѽ�ѽxD���H���U^�?/ß��/:�h-u P���{U�(�p�o�/���B!G�Ӆ�zä�� �v�Ϯ�.e�.1���rJ�'I��şا @
n-�n��p����[��G�.�*���|I�||��;&1~��plPU���>1>�'ƃc�H  �
�F!�BH�9�
�����pU��/��G��n�N�g]�a��o��	��X,�Le 5��!
�>*��$�i�7���̮�G�^]V�+8�lڈv
�+Ñ�?���g�F"1N@7�p%���_�q^�q^��7�:��a<��Xg���M�4�٭�����Hd#H�0ql|��z�I�C�yyM'rJK^�qB��8y���O���Z���uu�E�F-�uN4VϱA�C�D3���I������d��C����*`
`��ÿ��r� j��{�(��&� Yɪ�� yڅ�Y\�86�l+H��N#��B�C�����ׁ����G��)�l����Y��b������r
�ı!�t���>��������kK����]o�[��
r�������#^�(����0Ю���. ���Q�&��4�c7�)��  %"���0�㏰��b�,��5,�\�yg�G_�#�zx?d��*�%��)Afu�|/��AL��4U����b�"��7_��(�]��%���ʧ����p����g��H`8f��8]�9��U�����9��c�%��3c�G]}��W/B��"u��$���f�Ab��O���,>��v��Oo'b�9_l�w�T��;��4�uDr���)ɱ���G��/8'#�����_WD�BӃ��(��$q �0��D����#����s��|?�"&�b�(�t+̶�d+�tM�Ab�$����Ɏ ދ��T-�mC%��h�v]no����2��K��,g  ��8v��mϮ�%5���}G��8��ó���)��嵷�y�?&�yY�s�e�O\�ʜ k ���ivB��҈Q�.c�D�bK9-@68�߁z��*u3̌3m��:�&9������T������}��:nå�����+��v�_NAED��ۺ�c���#����F��O�aq1W܀�4�r��l�ozm����_p ��/@+ ��*��*�y��<|��iG;������� ��o�q?�C4�! V{1���^�����FZȧȲ.�.�Qn�"�n�	���G$`U�rm{u���O�vZ�y��ܡ��Y�]��N�����:~|��Sa���<O����s��ME�pA�{��?q���Dx	`*`M@�b�]mQ�r�V�i)���5��O��h�o��Η�w�{av3:��F���[a�fˉl�ٳ��A-�E'{��
   U��z����? ���8f���6�T�  �?6�Y����}_&u|���y�-�]�p�D��w("�g���{2L^#��)#�q��ǁI�;�{ ��r��8����.���y��.�v�t�?��� ��rlA}�Q���;����d,Cv���)�fIT��w��c�(�p�k��M��O|�4��3��?���و~n�,��^{���C���+��=�� ����˩��$��3�w ]
@��vC|�)z!�#΄A��N:��P���(���V&r�7��Gs���ވ�-?���_A�*W_ٍ�ޱ�"���E����������4@�%WH/T�qzBw$����
���U	|O������/�By��>``$ ��MN���6���A�f�z��g�F  @$�ȭo�ќH�\"�[ �DT7!<���|~�,Z�i ���p��o!��s   ����I��K$C|TB���۷%q��"��y��I?y��G���Ey��`������Pݮ�\K�mX�mF�oD�#�z).AQ��h
�L$�g�	Xع�틢�R5!�ϱ�,�v[]/�qy@   ������{�!e�>@E��N�	�!W�s5�<E����lg�w(Ll\��	 g�ۡ3�m��o�/�I�qF�����
�zٕ6�X湝2�T�m4���ޚ�	��1!}�E�b����P��k ��$��#�T��z���x�[]/��c��SIv  ��W ����f2���1y�2  @�[<9ΰ:Ĥ����_W�E9"�Ӯ�w(l��k���B��y�]}�_LE" ?7�#��m�u{���\q�4Ɋ7�8��C;���R�  @�
��y	Z��ȹ$�-Iբ�X��y�E��>�  4٦n�YZo�&\��<9��o�YP�G�����o2L^�%��ƣ�'Jy��CA�1�
�Lg�Hӣa�򋩿�P�q���5pk�.�(�}L�~nX�G�O��q�����S��D	X̡�1z�	9�+�T��a-r��#���%�Ow `�F�H T*�1�fߓ_�� BQ!�d9C��Ǿ���]V��2���|��}�X5i�
� �O+ ۦ�)�8V�]�w�j��h?��C4����5�1}�5� ��
$YF5	�A�����#�l�G� @��Z�iց��o���w�>o^�^ ����ݥ K�u�� ��]]��gA�Ѥ�yvU�E����La��Na�Y|o�T�4�i�O{����9�Z3�2La��y�>]|�^8�9f�7�����cW�������Uc����2���A E�||�A�y$�r!�g���̏O�3�%Q��	�-C�0���E湝�~� ��4-�{�6<���=���  _��e�|�~$R�5�/%C| 8fq�m���Fۮ)p�:��Xt�j9  
q�k������ �ʏ�+?Ʊ�c����Ջ�����w鞝�s�-XG7� @Z�3c1`�.K�|�P���ql�k�->�,�Z2F �c�8���[Yշ"�5�Em��Um�
�  .E%i�3s����r����������ȟn���V��W/���g�",=��A�#$����	���  &/C�B�J" �'����Y�]{��b��|�����U�@R�#�pA�(Y%��1 �.�ȘBV�y�B��R��z�<�w#9�����͹��O��x�}���vI�| �r�.��h
X�Yi����}��c	��_M���8f���[�A
�\H\�Y�c���� :R� *��٧W���]������PB�����ձ���y]���)D�ޕ���*m��,��P�  �1�$7r<�(3���C���&"���r����[�R�(*��$�b�g�oo�!q����l���OU��Y��?��|���k�;��ۿ��Y����m��o�9�J��s��ඌjRm��t�����p�1���  %7ɦG�=dy�n�E�B���O^�k���T-�b!#7Œ����L���\���%  �5���G[~̮�w(
Ȯ�3̟!���,_�����f`&�G�p+� ?�����= r��ܯ��Z��E�Z%��"� /��p�Ē�X��<�f"� `�Dx��l۫��c����W/��ȫb!��"Tvԣm��D�*�^��q��a){��S�Pw(
I���{�������S�9 �}sߠ�q��N٦T��IPr),�k�9��#؋\L���ۉ�v"�HB!�=��ʈu��UZH�j�y�|\C9+����l���W<���' hgZG*[��ۋz�[Di��� ��;}A��-�������i�;�d-
��?#o\��.�Ο�u�,&�G1i?���3�J��k'W���6�rK�!ryԊ�z�mt@u���� _���'��/p^븭�Y�T�"�Br��؏8� (.��T
9,��e�An6�H6���,_R�V9�u��+_��2�0[7W���ٿv��'�m�L 8 �w���k�=  �i�WN�D�S{���CQP�s����<Y�tN�3�<���y-�I��� l����j1�t�M���� ��� @���A8k �њ��$r(�/\�Z3���  KFO릏��G� ��z، ���W/���P�o+�n �4O��j��e%���h��.�@��"�Q�Ö�l�LYLϓtiz��?=���P�W�Qa��,~���n1���N�݂��$	�P�5
g�0��1�3UHEl���G[X�^2G+#*h�^�r�]�HC5+ո @��%O�P�!>��7�߻��N��e��އD�s��A�!y�?�������E����뎸CQ\�y���0yݡ���CŨ�����|$�O@�&�r�/�[@�j_x�p��"sؒj\$o&/��g�L��z�df'i�x�!�]�Ge��k|�D,@+P$`���D,8�!�L09j�8Y�h(g��; �B��z4��p����҈��7��lYRǅ�¦%ǲ�����cb��)�ESѹ�w�I��y_k"����o-bm\�-?&��rJ�
��+~�5�^w�L2�9>pY�K� ������y�:^��Gr���T�Y8]�Wy�.�&J�  �8�ծm}F�..	� �#������<�p"[� `6�RI���^��Dr;�t�d>F8k�8r @�>��V��?8� 4��z	��;�����{^�k8f�ז~>&���^�7��X ��#2;�@Ԝ��	��h=d#�����������>=~[�{�^����sʯ�&Y�rJ��;ȟԪ������H�U��2�l�`K��"C4�ߏ����#ϧ�
 ��B�'�\��L�F�$�YHkF�����@ �����<jE�Z��۵�7��_��ֿd�_�7���D»�D�<�"L����{ @HQ���z��oB$q��}�W0OC;��R�V��5ȟ�����ВA��N���e@����J\�9�tP-�M�ڙ�[Ef'����_M�5�T Ka 1L^݆�rV���-&`⣞Ұg��l�,�����l�:R�T�m��������5� .�W�n�|���ך�P;�:�����
���;�+~�犟c4����H8?��3�j�^z����ۿ��wj=�����?���Ǳk�WC\�������Vk ��A��?v�[��J���	��'�7�SH���"��k��K?y���C"Q���]��ql@q��H���1������/���M5+7�I���=��,6;�;t4���8��(Cn�����9�4�߷#&���ig��}_�����Xz����7��'�|�ٺ�T�j�yF��e�ˋD�u���<�.'������ P,. �\r����  �:�8%�f�7N���9��1,�c����0y�o$c�@<�Te�����?��}أXӟ� J�T�;bCH�S�q��}69�j�U�n��{ő�Cw��{я]�x�w]ݏ�%�����|�����7b�,�uk�o��v���Q��.f�)�ɉH��fr�o^f�2ڔ��&�p��>d��Ͳ�Q��@w�0��%�O�ҚiZ2���w�:�$��)�����1��rٚg���=S�g��'�D2@� ���+��7cSw��+k���i�������cΖ�
�l\���ؖ,Ꝋz������b��o�J��S��]�����ig��{ݱ��Pc���
�Mno�j��>@YE�B[�#$�/9fe�qeL��zp�w�.T���/���*~9%yڕ4�!��%~��u�㘅 *c�)w	X�M�$^"m��s���s'~F���v%2ɿ�����&ۮ�X��ީ���h)��h�Iu� ��t"�Xƥ�	x���I����k��$N|S�]��iv���w�Ih�����O?��K�/�Ap�&Z��=�%�{������Z�H�H���0L^�r�  �S��2w�� �������^���S�&@672粏�k�`p*S�%M"o^���V�/�4�oـ�	� YM�M"�o;����;i��p��a��%��GD�ث�w�F^]ND���+�� ��ۅ��Y$R`�?bCځ�׍�c���BK��B�o?�o��E��⾍��2��e�� Y-���*:��%�`�̉�V���w�f�9T�}_!����U�QA�Ɉ�M��e3�n1���A��%�~}����a,���lc�`�0FϐS�z	�ɟR��_k�5��K�h,? 3p=r���H\�@$���1��k�%����_Ew��?v2�~#5�C�������֌���/'�@���}m���ϼ�!n��c6Q���um�u��t|z�Ʒ�?f%�6h���������&�c�M��+��^�t��)/�1D~��i�ݻ��m�����y�6_���e���]k�|��U�y#_��3_��42~��A�<�o}��S��ıA+7�]�K.^�a�7�,�d�]��ܻ���r
�+��ײp,��n�vM�� ,:&�5`�CǬ�&��l�=p�?�ǿϘkz�'�P���MGW�2��,~ ���݊��cђ����^�;��;+i�ú����#���m�������ɋ`U{�	$	[�a���*���٦�ֿ��C�g>�ÿ9vc<�%G�s�#o"�d�΅����0y��5]qKcZW��4'_uz+3�o^����X�M�jɉ�Vξf�%���s����I�G�-+?�  �>���O{/9�#�cr�|�m��]6.^e��w?�c�,�=~�� d��H3N�6J!d���L���6{NK�M����B����|y|��]�o�ک�y�v<+��.��:�(�wII�  P/4��l�z�  n*���o��F�W:ָ]��ude���@a��"��r��Cjs P�u���C�#7�P����>��\q���og���}�
�!�vپ�g���3�^\&t�N��w�<�]�<���ͽ����߷��>��Ir)n�]q�٤�H��z��  P: hf���d�)�UN	/r��	�׌{]��r�☕���̶jlƦ�.����X�N�u ��9ȉkOٳ+�_��%4K �v��%H��;V�A���{&jI"���/&���D����p�=������|$CI�����M py�Q��g����(hL���S��A�Ru�-�*�xz�78����%��c􀘝��	�Wr�K��i�� ��[ $D;3�ٙL�"^G�L�CV�|-a��|~�Z�B�Y�	�Yz��k�Vxa��Ӂ>��&ӟ��>�g�\��Ϻ�Gʩ�R��1�0>��Kr��#����θe��5��Cy����y68b�ϧ8f��uNM=6�d���F�Qc��IW������Rƽ.��  �#��)�f�I8R�'Ć$����I\8f!H g��J#�},Dgսq�g�\ӣb��[p�Sd��t��2���[YmV5y����a�#�M�ߚ�j���y���Z�m���B�Mu� ��~>ƣV�4J��R-hz��{�I]ƽ��. �^� ��DA>N� ��A��z���`�'�¥�_���]��3����I�^h ��r�ꌛ����}��O�N���s����7��!�jB��2b�H����5�������2�k�;�`ǭ�O�4IT��F��BlHB!H8Ԓ6�N�@�:B��i:܆\�����l\BD��n�:>aE��� -3i�U��%Wf�}�t#��K�n������p�����i���]';'Z�i]����%� p��"!!�x�}	 �uFE��ͪ����+R��2y�2���=��Rr�,�9�^X�h��jY?�P&6A>�D�a2$�FdZ=�X�t�9��*A���c�S��D @oez+˩�Ӻ^��Ϥ���T��/��Ym]��)����1Y���&��
Bb$�?%�Hoe�����\շB���O�X��*�n��I� if馠�*ˢc ���ȩ3�]\�ē��v-�
6"���2��� ؖ/X�Eg��\��^�pg���?�PP���O��8 �W9g�n׃�Sr�Za� Xp�Ԓ��:��Y s��1���&4�+
1<df��D����:�d"��$�ꉴN��t6iH�DI�`'�U�����͛�����)�y�t!K�%M"��
��%q��I��ڻU'���h픣��>�������3 Ȯ3�댴� JxQ_��뙴D����;셠�^>�2��]���:�Bˮ3�[��Qg�13u���BRq	i6QY�LN��_�D���6 ���*2}ЙL�f�I�8��zЀ�<����^ �9�"r�s�I&H]P �=�\�j���@.��j�������'�lN ��2JxQ~� 7��Emғ����Z��d9 �b�bW˸���Sh�x�u%M��I4y�B�sܮ'I�-s��1����N�
;e^cZ�똤n�Tif�q$R�����9�kpD�,��j*����z��TK�mt�$_J�����:���>pW���}��Dx���b̹y�qS	 �&��O@s�7/�C,L��4T���ϐ~A��oY� �▸C4����c^l>U�
 ��Y%�(�5(BmV�y��TM�uz+��kLk���I�"*e�˜��xD�Z�H	Ǟ�&��>�G���%�LK�̱�v����5=�*���Jx Jx���4yұ��fp�C|0L��)�A�j(g��q�8���#�* �T�\R��]��I�xWo^�l�&�Ѧ��
��[A��R�JřW�:��t|��2����)ڙ'v\/%R�VO_ʓ�������p�����o����M9u���R��&��j�7��#��i�2�?4�&��s�k��A�@W��,u&�5 ��%�_,��i�*�Ti �ڔZ��ek�TMZW �4�&.e�f��&-��H�$B��)!2���ф��9 e��H��$�1����lY_���=:u���ʘ���d�J���1��^��E��`'c�CN̩���*c8�$\j[��7�M��T�-:&��G�Ս�d"�m0��u��%�P�#R�8�a�1��%`��Jf��@0v������y�^.2��������*Ћ��96i��[\��ͥ��!��Sb����e�)ꅆ�r�o^��؉nGSy�s� d�3�CRFF|��|��P�fU 8�g����߈� ly4�$�Ϫ�3��3j�Q�ʽ'M�Kf��M�%g��HC����4�R�h�ٺ��E��l��RU�
 T*܇}Q ����f�)]q�7/s���L�ڬj�� U�ǧ.�BK�'���I5O���DIE�,Ć$΍Fd)�}�Wd���β�� M�3݈�����β��P���[^�!��N��������SG]�a�sS�7/�v=�U�7/4�gBZ�,9a}��N��y���Y�Ano��nI ��M�C���U�l(f�ҁ#��[�<���펕Ͳԩu�LD�$�xk����@����g1����ЋT��#��]��*f�������:�T� ��<%���&�
aث���4��1�;��ɰI���\�E �Q�����q ,�,u�V�Ax3c�\��:o^�SgȜB���*C�����K�D+yT�2���&��<�z��̔6�S�}�K�%�C���TR$
*
;���|��u��;�S+�Mz*e���i�y�^��KD����1�˪��sz+s����.%ǭd���.I��y&�r�Ө� ]>	dyj����H8 hFʔ��K��[$
��������W/z�Q�V2�RNs�k��C� ���&� �oA����#Y~�u�UQ sj����M��L��:��� ^Aжa��#�gʷ��F$0+MAP��Ș�{�����a6Qg��N�uum� :Ĥ�K$+����o@~��d9#Ko��>���Sl�K�]GSz�+�E��BN�塒��7� �.��v=��\�#�t  �Z�uP��6YuAu� �\�05�U20o���L1�t6i0���]�ژY8�)��P�V,4J#���ծi)��&HV5�<��g��z�8q�u$�+
�:�[��b7�R3��!���G3������*�y�O%��SQ/���,�Ơ�w9n�[����Q���j(g�`�%V�Q�P�*�6��f�Fp����w�1	 �ه�Z�҈�m�oK˾t~��y�!k8и� n*4Jd�1��X��� �Ϣ⎉����Ui�i��H��� ����|����`vh�q(�&�߄���=�:nCV� ���3cˏA�`�i��0Y�^>�n[���	%����i���[�`?!rj*�	{��$�s(-�s (���lt�\�5�'�[��J�FԠ�U�� �g�	�4��V&�K�;TR|�嵏C;Ȇ��P?�/��	����P���>�����^��}���_��#�R�M�Ce�v�MK�p��Z��z�O���?V&��܋� �n�}طP����(aц%Y��<�g��+�P�e�� �	c�Ҽ�wš�<jE�lhKV*�RN�_p���| ��6\{a� ��p�A�L�_OSe�)"�o�ʾ�2�ltÁƛ�!�����[��E���8�F���8���C�"���|-��8�J�H"��z�_ 2�f�� -�4����>��}_�!������:nÍf��d����ߚ�:.�Msc��Q/���ܛCG]V�7 
x.���Mק+'���^�|�(y��'i�4T�8f�@	�bEqyp?Hs�i����֎h�D��!>��d�CH������f=������*y�e]��Bdɳ�:+SG]շ�������H�c��w!�˩��O��zJxQmV��6��1��l��^�B�%Z�{�Aǻ]�y� p�kBlH%�e Y�?0���w�S�>'��Z���]�쾏�{.���ގ�wA���� �� Y��fA����5J#8v]$ٶ��h����ٺ��vxV#�&�>��X��M%�7�d�R^�]�o�rd��s�Z��U8�r�b��DyB�(^@M�������m� c%��bAa�`]r{�gH�P��֝b������Q1�G��-�N3��@no�BA�
���lZ��j��8�*��cJժ~>F�wFsEl�BDR}�WD���#y�ܩЌj�7�)��� �j�|���sM������"�&���*P�y�??v5�̳�8f�]�jb :�$�w���i��綎�U��Q (U����1��c�5p���e.Q��*);�������ӿ��&�#�az�O� �F��m�umy6h����J�
�B����;�6���[�ф�v��S���4��^�uTw��c���W���)hH���~�5Q������n�[}�JK /&�\zG��vm3dNN�E�c�E���r���Lͧ���
�@9��fC�	2+t�����]WGGǽ	 dQ��p���T�W�A��S���V}�1�VnE ��h�ȫmr�j����Ѷ*�N�f��,��VG��A9� �#�8�1 ��M��[�2М�Q+��5���R��)�P
��6 \���^��<�� ॱ� !�Y�eE���HY3��%�P� �Φ�v�>���L!Bۜ+lV�4&;�e���,g�,B�Rɪ�{$�M)c* �H��TB��E^/��5v�T_�	��|8�u�n�#�G�Y6�Z�Y�*�/V�,:�u�9H�1!��MXrLi8f���G�������t�rw��"�=�J��Qbw��7��M����!��q�b��QU�T��Ѧ�e5]q�C/?v�~6�� (W_=�a�Q�V��vt_�����h=�Se�XuL"e�2���4T�m �8Ќ�5_k��᭡�sv��m�wdQ7=jE�Z�BA��L�t1�]�+�\���,��p�G�MT~������o^&}�0�K|�y���f5�5[7��z�����ם�:Jr�,�>2c��i�6M ��~לH��c4az+c"�54?����J��6�Ǭ(��cb��c�d�|�#�>�#
��4�����j���n�B��D~�c�!����d40��}��f��184���J&��4��%�s���,���Φ��,  3&���e YE O@c�%;�ᧄ�}�U�if�p�as�k�3�y��;d���$���>��EOiX���n��r����H)�'  ���{X�K{+C�Pp��r[|��q���t���N�5�!'��v��a[2k�*�2c1]�Ѐ' ����g�˜�P�c�1l�{] �[��}U�g�l �Q�CK�_d���䥙~9e�F��\�ˬ:Ϊ��? ��ƥ_M�~�t�����&=%�b�$oـ[���r���
���sm@e\��3��5xQ��賷�~Q�<u�L3�&O],�t&Q��)h��������!B���l�d���VW���^��kb6͎��&�G���H3�\�~>F.$2>$�1	 7^�(3�AE�,!2�O5���iB�Z�3�g��c�����[ F|fe�z� ��f�r'@6��h��B���6���k�����*��"��f7��Sg�e529��6��-�LHY�� \�x���EG��v���9.�]�	��D�@�s�NΜ����K᭡X\H���8�Gg�a�.�0yi��S?ñ��骯Ǽ��A^_o-�l�����}e6!z+;�zx�ͪp�L���ᕂR��_N���C|�a���\��A�q	�M<�֎fO/CQ�#�'\�ܮ��kz+�ߚ�>�ڬ
 �i���&�ٺ�T��W��4�l� ��}��	����+5Hfyu�)R(�U����R����DzVmV5u����q�%�;`����	2+���:��:�H�f�[���h�Ѽ*P��c��'������hS��L��ި I����ɫYN�f�F��v*���V�^8����Jܡ�/�c(�EEn; z+�55=밿AF�V7�7;�$i^�k&��ޮ����?�&C� 3F�T�-@Y���cK[���|9��d����T�����0%��o� �����G7���_}=f������:�gi)�)QȱrQ��1�����~����Q��m�ʚ?��nw��
<�{�ݺ�:��~A; �˙�x�?�����'�� /��n��=�!��W�+�E��:�V�ed�0�z�_N��Ö�i���j�_Eܡ(#��9۸�W/������>ܤ�L� iU}+�y�Ce�Sfy���Fc9CzW����;�ݺ�&����`C������2�t��6�g���S�T�>a�c�|o�`�0_��ȒdS_ͱ��S��[A��~�Ѯۥ_6�Z��,~9�n���WA����EFa��,� r�ڬ�6�4�72���n��M�l��R���4�T����(�(TC�,s񰺬63T��7�'�.�9�2�Fn�12t�3�Mhm(W_5�i�q��3=R!y}�s�?�;�����v 2f� ����B�K���c�����m�n]��ãVYvճl�k6���g�~��J2���)�x]oe	�"K[k�=��S<'�: ��6�sǼfC�߈e�����Oiv~z�w(J��2�,A�"��cd"[� ��pSI�:s+�P��q��(����i?�����Y�J!6���a�~�OM���Y���~��)G�S���݀���s��nC�{݅i�7�Lĵ�-暘xΆ�v�}z�\}�!&�U��`'�Z��zQ�nX��#�Pw]����] Az�y(�6���CyYmV�Oe��~��� pP-�y�★<V��,��=ϼKtT}+������a����Φ��p~[���<�>�l���
^�M�ɪ�Y�u� Ya?Cu� @6�m�n�|�m�S�#�μS�A�L�?F��: �'^���w��{�fާ�}H�:�U�F��*�^�٤!e�JN ����*6�*��34Y{���/��}�}N��Fm%�X��7�:����1Z����cz��r��3�
CA����ۿ"
dt?)�ӷ�ӈ4�<,ǙbyUv5+8��<G3�sv눶QZUhv�w���Mؾ&���,���D�PK�0����}��#`=��T��B�D5�Ͳ!�^g�N*U�j�y��%ո�Ws�8�W<q����kR��C�y-�+�;��1���O�߯(��AOUR&O:�9v��U�V�ϡ���0|ˠ�����K,l�"��]���Ȥ1�AF����C�|�%]�#�̊���&� �u��r�U/GNG݆�nC?$�w�I�,%�T��j�0�C2��2�(� �ߛ�EQ�[�7/�h��/[���Aϡ3;Sq;I�� �U��Ќ� �h��@�,8v�~+��d`��1+6��Mz*ո �n��vA8t*�e��?��]��l�ux+�oਣ�'� �0���「@�!�P��] �!l�M7��>�n1An���9�,:�_ay~�v�Q��F �����fjg6� .֔��1��]r8v���/���v�%�d=n��S��z��[�K3(c���-�5�\��c�KV����ơlƥ��aOS�,AᲒ��sM᭡/j+c*�BS/4���MA*�p��E���z��
ʱ[��@�0��b���B"@��@�Z���b������ZÞ���F�� r "Cc�ޢ]�.���4�0ا\� h? � Jx���4y�)��2������W/zJ����R�
�gMS�,�~���*����1�'���T �^h�o)/p)/ X�m7�) t�I�f��C�-*i��E��E�4���IAp{�g��}Ƣc.�ML���6W��O9J#��W�̆j�?͢�l�hu�M���6n�M< $M"��3�(��*�y(b�ShX�^k���Ör��S�P�r��A�0 ��Yf4=�V7�b��:S(�Л�긤I ���M :nW^]#��M����vOi�,�Z�5if���(�5�L�q< ^�MK�NCF�vB$�[�Y�l�S�����磨S��1�v��8�Ws�Ұ���t�Du�d�T��j�,:F3� `2fe�!�O-:��[���Fm��>%n�l�� P]/@� ���S?�d�g�u5j��&e����z������[a�1f��2�1�(�� �f�Yt�Ce�y4�W9�YՓ���N��ٌKS��(� �Rf3Zܡ�fL��c^����z*�c=���?o�o�Cl/	��_NAvf4*&�1z@�:��KY*�`C,:&�;e4a���^h �wI8 ��U�]
���!�p��n�9���A�� (t7p���*��H��43��%�x�	K�NYt���d�3�sWշ��-�4� ��v�O;\�/�3f��9��t&!�<���z����m$�#�x N?�+���A�j*߳'W�����.ig��﹙cW�(P/44�#� �I�)FVQ����#�c$)W�2�-M�{�@�ڧn�S�.�r� �f?{�@�)q�\�p��(TF��^oЉ@k�z�����j����S�I W��M�Q�Vy�
d:3[7����o%SG��D�����.M����gH���:ӏ��{ϸ����_���&*�3r0��?|�"~J�e��ы�/�eqۗ]g$M" M H��8���[ P�]��$��������/�T4��@�j^S��$n��z	P/�Z�Sg�ߛ�]���  ��9T�U���b�&Qv����æ'[��5��b �
E��[w^��M�L�a���<J�[C�(HoST����`�D�fjgq��#8~l��E������$ۤ�~+U�Z�;�|Jä����	��c����p��`6Qi�)�� ��6�)�2}���W�TC���!;�����,���pj4��4ⓛv��O{2�5���@��>c��Q�T����C��+(s��    ^����u��&�̣auc ��Uߊ�[�f��,~]���o3.�n]��šd�:c�$Q8���� ��8����Kc�� �N,݃�
3ON��1pl�~9E7��F��i�u��T�$+�G8��{���*ҺS2���M p��I�W�s�������VT�q����Wy�
|�Ws P]/��>��1i�	 ���5�*�]Mx��[��Z�K�UY�9 *�� M����+)�9iݩ~�Q�ڬ�)�Z�f�
�͒ Y��u�I�\h��٤!e�I����yةdF���@��m�vл{-a��m�±k$'�t�n���>��%"������܀�k�_�7/��V�    8F�������9[��� ڇx��@#g�Ǯ����Z�˯��!#�e	�����K7���o^&����7/3�(�l[��[g�& T8�D;3�?E���[��˂�z�Z�Em ����P! �� �<��P!��Y$+�d���
��Z�f2�����o�[�Y� R��2�D3Ri��;�4f����S�A��C4�\}U�Vj����&�*c4f�����j��ڬ�2���,u��%�� ����<���wIV'k v�p����Tz��"�S��M �.~� P��p��CVg�,: &a6'43 XT8`Ӣ�N��魬2�@oe���M�O�&/���z�z	��;����<�ZF�y���ܚ�@��'<�z*�A��+��	[=T�wIWu������R���>��1�c�Vnq�"8��[��q��sɕ�k�ը�M%����I�Hoe 0��L�fy�I�<&7�X��AG�����z�mtq�k�� ɣ��~%���Em޼��%e�4����ʒ&N �|��$:RŅTq�C�[�P,.N�FkA�n��K��͸$O��n�1	 W�*�oYq�B]T)]  ���K�Y]V	`:��m@��5�g��� 3 �����T6@6}|�p�}͆���AѤ��6%�β�>��J�[�]q���\r%�MQ/4��G�,u n*�/��څ�����H�j��F��&ո �2�m2��T �R����
Ҵ��u]x+�bAԣ�BNqI��^h�Sge�)ÁFTm,�EW3�a�2Y���.@6��)�����!+�`�͟�f�n@ܽ�Qc��2���{�I�tS��}� J���Fd��{@���2�7���gG���9��e��t�DY�f�$������.��ɯr*
 ��6��_������lH^uΡ2d�:W��P]/@�4b�P��*U�L� )��9v�r����������f�;\I(�D=!�� nA�(E~�3u����f:q��E�\�8���eܑ<��?�e�T՟9�u������X�0Z�{4B�g�6ă�
u�JxQz�ا��?�S>]�pP�4�&/wem2��\�3�	���f1�:�=eÄw�]�2V����� �#��H��^$6�f�}uY��� ��>2'�ʑ/0wV],\l��|��o�>1[7��]�����a �s@�����'s(��)�9��S71�Y�tĉz4��BNaEVDA�(gb�E#� 's�T��j\��]g�[o� �Yp����P�E�l�9 ���L�=�<��c~5�*�M!�3�b�N9J*H�[�h
�w?�������i�71�0�k>�6Q�[�C���Vqn*�ͪШBV�t����ߚ�Մ����[a�!��[YN�UQ��2d2FNzց����Ұ��B�
x]7ZZU~!��41��S�U��:Koe���^� /h��H�j����_+�dTxk -hd�fUn*�_Exkpʼ�<��Yf����������('�QOivt�4�I�	��[L��6EW.{��G��e�Fd��$M�8�쵌��+K�\�Z(�"�����>�!O���b��!��'��D�W9 pʼ�o�2 A+�*���]E��WB�]ҡ���ٻ�#�*n�#�(�t�SV�f�Ws�=^~��)���  �e5��|!n�s�Se�Jxѡ�; ��Ԋ;wIԣI�`"@QIX��A�^	�DT}+�2 �U��Dl�p����UƝ,?@�Z��ozA�aF��6�F�|�&=��X�*jx�I3F�P�V�G����*A؂��3���A6��Q\�Z�������h�4;`�;�e% 8�֡:�M1�0[��_����Bu"�K�D2�d"f:�^�[��%�� �L˲��v=uY �˄�Bt�<T���_��KZ�xe����Ȱ,uE^e�ɱwI��yᭈ��G�b"GNn��ΌiZ�[�`4am
�O�u 8���7R�c�����l����t?��j��Bh�Zq^��Vкj��9]�]��,\��43 <c��u���
@w�S�-�6"c���gY�]�Zl}�٤�q������A�<c�����f�|�ؗ��.�ɩ��Mo���I�Sg�MT�$��Id6Q�5ЊB� ���_�e�)�lBc�	�n*�:���jf�)2�`C ��� xmS�����6��ȩ��& z���@�Sga�%�\����?T6K��>�n?���ٌK��
� ���PCT�����<ɘ��2��W�@F�1k�ϲ�o�CS�����<9B�=�#^2+1��|������z�yYmV��a�>�o@v�Q s(�8w�U��J1�r�92=#�5�{]XI��!��2޹��d�wQԣQ��%(�Qd�2 8�0�B���43 &���fU޼�����jU��o�ֿx�/x��8��"��_`?��ۙ���zL�mҼe�bJ������E�����"c[�����tIT���3"�S򺀩���PU*�o����1�Y�T�9�$jv����ś�*
U�: ,�֘����l}��AG;<*
o��$�_^	/r���g�\VD�r5=�*}BY� ��  �-ToB�u� �rK�:SQ���I��4��q�v��O^��!���G�@��Q�,���wf� 
�Ñ�?�,&[?[�r��c� �955MAc����	�lwhiak��P\�����^�u�	q8e�[�	;�lHG3�E��t�cy_+��hg�~
ʫc�DA�JC��w�Ƣ\�*�H�dISjоVv�GbAԣQ���FP�B�s�G$��&�2��}c~ ����#|��O	z�%�����b�v�|�"�th�c���`�����#�q�:��3����P&���	��E2��ƚ�c=� Y��!�w(�QQ�l}N����QR�MBI�u5�(�Kz����M � � rɂ�*G6G�L:*Rv�:F?� ��9J��=�x����kݣQ��3N}��"�8rL#O��il}BE�"�]�¿�}*a��M?y]�=��&��X�(���l��ݮ2�f��+�e��n]��0ԒM�t���S���`�_�5���t#e�xT���e���bJ��e��>�v�Kv�,>d�
y����Pe�4  @3�N}� `��ޫ�ꐉX�hc� �Q @3�M����I%�=s�S��H�,�EyUV�(�M�| y�b,��eãmx4�?���);�!4�!   S��ׂۺ���(�;���r :Ĥ�t�[6 +��}*��?Y������dm��Dv��Vl�tC�~�LL��Z���S6<�ݸξ`�8��78f��j�o���
��4�����1z ���.m9u  p4'(�3��ɸP��V��T��I4�! hg 2ڔ��\շ��
%�Ӫ�yչ�6	7B3��$���h�gD=�LƂ�9  8Z�Х��;�\ӎc"k��5!�q�b����'l^?gـ�d�@�x �f[�L�_�o]4$�SM�$��[b�@31%b0�!Á��(R3o-�Ͳ��� Y��1��G?y��?N�3���7�|��l��E8��YeL �r��0�2��,\��(��NG�J"���ڙa&f�1�>=L�����9aehO���J"�#ߞp�Bly4:�<ڪ�X�& �T���Yh�{�O��1�~V�X�ٺ�T��M��5|B�ȷ �<���z�.$7��\��H[ή�r�4BA�g���b(J��{y�k6��mA�⣴��
*�����0��u(�\�w�"���d��<e�At6i`�4<$9J  hg��J,:�l�ʘ��!-������&�d"43[r�b�!!��>A�s�g|�b�q�p  G>U�s׹��`�!�8>��ڧJժ	����W�h�� ���T�N�`:�^h�i�C^�'R�*Q$3f�!ʉK��R�� ��kɊL�ål�k�sMm���[ٵ��T*�XQxk`gjOiZ��i�C�Q`4G�&
� ��lk0�(�I�D��؞*��Y���Ϡ��]�tC71�ː�IC	/�8�>�������t&��t��|�H����l�UQ؂I�nA�$$��`X���e�^|Ql	-�D෈u���v�⇋D���Qӝ�K�ꚾ�&4�] .��>D�>2s���d�Ei$2UpB;3 ���cHF��ѦXu�7/C�P�!޼̪�P��&�s��
�KȆ���h+>��e��>j���a�1�L�}my�O'��T�ӻ`��]�@�| �9(�:GOǽ	 �omK�4�'���o�u�E���o5o� �t]�sV�5L�u�I p�k�Ç�a]?o箩��Hd����Kf6�ɓ�V�9�L#�Bd���,U��a6 �:.��BV�ɓN�@�5M�t�ҔSgYu��S3� p�"֒�>#mz�M�A}&S����5ő�I�]_#5	���n���P8Y� ���2���9� r��<�\*�C�u.JĪF;LΦY!fE�hO=c�����U_�!���?3�l�M�φ�:�d"�]�X,�uY���sM�[���4r<3��q�hg�u���n*)�9i�){��P��M{��֝*�9�{��&q4�*c* �f!��s��_����3U\}�N}���OAY� �.�e5�:W��͔���yɮ��� �MrQ2@��c����]Z��`k��� �3eL塂��Zxw-�c�of��T����X|!�k��k*
U�$@�"�r¦E�"�Ψ��`�&9$.���nb�uQ (|�
��@vș�N�1�4s�!;�Ce�~�� ҺSz+�ф��mq�r"�����(�WަG��c���xx�{v���vf�EH_Զ�1�O�:�\D`��,��W�_����T؇~��-hÀD�"PX��ryd8�`��{o?�0���O��v~9=NW������*�8r ��i�
���I�Q��)�(\����"tC?��a�.�����n* ބʶ���J��eLe��]RoKx��U����#�*ѥ,r&���P�W}�o���%�SP|���&��:�;g��l =A��h�i�	B�q� ���&@/Ĳ�Ʀx���$�c(yDwͲ���ݺ~>?���SG��D�LD�#j"� ���E���5Ҽ���Pȡ�����4��sUߊ�kӈ�A��!Rh�@Zʈ��6U}+���Bɚ��<eL%
w	�����_�<�0���X&m7���O���"	�A�=���ig��J�iFʖn*8~l+��]� ��T^��7<0�8�,yY<A�u|��*�C����.�ժH�΋B@V++�3]q�����jx�����H���ՙtC��S��I�3C;3R�cV�~oZ��2�Em��Em�nÁfuch�7Yu�E�$M��I�P7/DEz�6 �U�$�2=��VԊ7�W��U�g�!>�HdV�����՘�1|�������)G������ Jl�$r�kj�hw���x���&��
�Ο��7���|����B�yi#��#�!��[Ch�3��Y���L;+ʮc�s(vJd�w���8�n��w@ �̇�& �y��:��T�ڬ���j�* ��d��v=޼ I�H3� P�T�E�+n@v�!�52r܂p��E@�U�3�3�a��e�^3K�� 0t�`x	�K�ϞN.�-)� �)Q/�B*�:/�5�s��a�a�n��rEL�~��c���c�r	�O9��;S ��6���W���iscZ�3D�+�ⶏ�����^����z�-%�DF'9�!.�d���eȡ��u4' `6 hf�Ce]��r�<�TSG�S��q9tis����E� �DZ'�����I�z��W9�U���3�=ں�Z�)
���>��%(���7<�U�0!6���ct��e_^�� ����$S./W Q�g� x�u����g�L�t�>��;��Y���-pA��\�5�<��sl��}��
���%Q��H5�Ȋ����0s�ͪ��	����A`9 J$b���G[�"V��L��IҴ$��&����e5q�r.�R�U�,���M%�Yչ�Jܡ�e5H�E�&��h�7�lsʙJ��ҺS��ŀ��3hv�ƈ�WA�[1{	���Pe����t�Z��&1���k�(TǏm��	�g� �3��-���LM-���ǫ�O�󢸏�W�! h�o4�3��α!��}|����xH2���g�Ē��ܕ���ĵ�,r&b�D,L$���!���h(��X�h+>c�g<$>F�DF'��  �`_��s�z�%W ��Mu��
 hf^�:���:v�8�]Ǵ���(w�f���]��3�smz��/��h��Vd�) �ȷH�0W6K4�bq��R^D�����"K��� ���!��=�\bj��
�X쪚ڬ����_����G���^�9����Y�H����kI�O�P�&n��~��%�X, ט���V|��<���V}Ƨ������*� ��rt z++�E�������ʸׅe~׷�6l�M�V���)�6�Z�vӯ�I�9m���if^)/�[  ��2 d�)�/���gscrS	  p�װ���3>AQ����H�\D�#�lҐ<���lȦ�ېߜ@� �2�`em�K6�*  �n��m�Tx�ֿ8�Cu�6�?� ����M��?^�]�z���3#��Io^��l��@�!�V6�H���2�� Ą�S�ʞC�s(���g��:�l�������4�w�H�: ��+���+�]�"
9��%�m"��I7)r���,I�����v׹gQ�5�PP�\ZL�.o���4�2��N��|��z$[��j[�LuVw�-c�G��B@���"��p��P"�9������'���\�0���@z����{���y�NfY�����[��i�@� ��K:�r'�@��;�d��v= ��It��D�_+��ڴ�1�A�Ѧ ��u�j��{�-���3��<Z(�V��X`�>��)B�kQ�nR�I�	C�;�&�<�>Gpe^aju��#�ͤP�n!�(��t-ǟ*�ߌ��ڼdI�h�z	0[���Ǭ�^��猜Yd_�B�� 7� �cxk�<����bq �,d:��c��o lZd���*�)����m�D���?ø��}mI�N!7�ф  U�
4&g��t�k�w��se�YQ{G��`"�dӣ�X�W�G����ѐR��οkǴ�C�0<�SoN�P�i���>&���ڔ����uXh���X� ���j�޼ݯf�9T�DF�����Oi�n���>���n�r��>3G�3,:�@���8�@xљ*��A&��H p�h�� H�2ϛ��oM]q ��$���I�4��%N晈��g��M�����A�bl��@�;�l�3RS�K9L|�3�������*@/��a�{[�_ɊO���
�U/��5��~5FTKxk��寰����;T(n�I�a?�u�ܙ�n����P�L$�q� Z3��M�-��q;�DV(���Нq��å��� Cָ� �$�ߚ�& ��ƴN�вZ]��<��hkm�g�Vԣ	1��K/�֮������,HⳤOY*�>��ݤ �9.����	�z��@l
fjWՙ/��j��������-eUsM���ۿul�e��: ��?pAs�#�n��t>�uE=��Z
98��D=ڗ���% ҴD�N�
d�z���t��r}�-L$���@���y��m�<&�̳c�f"g}{���r����h�����Y���N0%ݪW�G|�ů`�`�zS� ��f>foe�#�%��b��jee�&���d"43��)��E�� �Qܡ�P�:�g�@2���0��=O�^<I��������_�r��r����]|w8�r�k*�[��S;���m��۪:��w�-���[�	��B�͸Ȇc�?H�9�#CQ~nK�6-�_�^�ɵ�E֥��8r&b�8�UI��0���e��������A�
4�4�v)3���̧�f���&J��_�8�c_uN�T�0>��|��i�J�[CU^,bc��3Y `�K$@�le�[�0��_y(yU�bS��C�DD�\���A0�����Z}��i�����]����7�:\=B���DIbǠ�
���$�ǵ���v*Y���>��&R�:b���~i�����t�>�  ��@,߽$Fj^u�ME������������i��==!J�ܥ�2�$���i��V2��(5k���7l�U�\J�[CB��p���Z��ߚԡb	��L*(O��k������ɟ��"ի�ɓ��C0ިh�@7���pl��#a������ȷ:LĂ�3�m4�D���Y+�lzD�n��P (�ٔڱX`6��_��_���L���~�
�!l)[���k��f��覂��	����_�oSlmBK\���ӽ��z�����ݝ~����c��"�5��d�*l�h,? �z	��_�ؐ�s�DE+
վ�T(�(����l���1���!����&�~
:�N�2'O:d�T/�̆��Y���jenAp�	
N?T�A:G�a�"o^Uq�j9@b��䢱������*�W�g�~�P�ٵ�7�oW�������j��y�T1��q���|C@m~l�o� �6��\q۷E5�� 0�H(�O;��?v��H�'��t  ��;����@3t��ߚP��D$M"�̲i�X,�sA�L��iԿkT�a��?�+vSJ�x~��ƥ[ x��v)�o�}B2^HB�f�[Ќ��2Ô-�[���'޳�U���;��ve��e����<��!��5���,�����Ijx�GZ3"�"r�DVD(��^�1���9/��ԇ �
 �^h� �$�� 0A%�O�ݚf#��y{�>�V��D��C;�v���հM�'�K����O����-_��a�O��1n?�ޱ����x��Y���zT���[Ғ7�(&��G�� ���wƮ�%UQ7O*��"?I�p(b�U܂@L$��DQIdt���8 0��RI<$��%g�J%Q*	΋�iE�(P/l�ЎdVLwZ>qlwb��⭉��;��Xtj�������R�}�F4��-�F�Y� ���L��p��e����8y�����.m��?X쎯ِ��dyn�o||m�[���k��{7�r����(Jx���3q&b��D2���n"� h�_�=Th�`�~��t�ӑ���u�-����<�Xt<ylye���㼲��gIČ`��cj40���#�T睼�߃s�!=���΋��,���<�]��s�)@66��9m-I�Ti}XÏ�,�xa��P!�g~�M�Ƣ��C�B����w�9��b�O����0h
e��8��IƢ��
U�20����=�y����n�yx�Տ/Z���<%�_���m�7��Gt�E���c�tE��u6-�w)�a�-b�{�iQ�O�u�CI�qn�PS�K��X<2SG]mV���kK���v�����"[��6-�
I�_�Q[��:�8>в��_��U�moj��}�w�5y�=O$ܣ�G���{�AQѴ��(ŻC;�]���lI]��t3�1w�W,rR�
:|�
��s4�� ����n*��yu�������Ԏv��{ӈ�c��w=o����my�=	�[�t`x�/��z���|TʸC��K�ͮ�w(��ܻ��"��cG�+%�iLֳd��L��VP�kE�6%�!ڙ�mN$K[���ɻ���7�7�,�$�i�z��Q�)��Þ�Θw�0�����]����(���(��c��4�������L�C�\��Q�T��*X!�[���r�l�JG�(�z	��ɻ��]���:�긳IC�5Q�^���"����<(����]���] ӈ�cԖ���[p�vZ`�qn�k���ۓ�����$�>nO�i�]ϝ���'/��w�)��So^V*æ#�2�EXB2�J%���NG�*�����f��=��3�yJŶk
��Jyv7�a�[M#̟���Q�5'�������k��-�W헭�8�Ɖ�� N$���5��B�+�1����[ײ��8��yc��v��.~������@��%��"xx3n
9�\Ӵd�@ۊ�2_����B`�]��c�&	 �5��]צ,uF��DcT0Z���=�Y[i���i��)���0�^BY�߳�����I�����xW�z }i�G�ӣn����z�`�L� �?.�q�Bw)��O	
+�<���oEau$r�J�G�C�M��! �|Ů�AM��i���蘙�N����%�� ��d�_��	Xٳ���6�C��ޚlû����`����1K�{=� &� ��i������{p�U��}�����H�e7���9Z}�]���?���dܡ���Pi?���X`6��{����b��ߚ�F2�(%���^�e�� @o�5 bC��	�c�2����ɲ�NC��j?ћY��{R���\��$�h����M楳�;�+~��'-` � �"�HǊ��X�(d>�K޸��W����-G�Ot��f��/���ߚ���.l�!���D"6�S%<ZIf'�K�{1ע6�UJ�$�	�o����tNG��(-�*
Uxk`( �͘��ZM#R��ĲM��/��5v��ҫ��{��� �00 ��a �x�
���OB��e��I_�P�g���I�v�'_���5AׯܮǛ��KE(���oƑGe�h�q]z�d��B!��$<�x}RQObg���p����M��2��;�g}�E_�
�r���|@S��r�;�!{�Y�tۛw?q�G�ҙa���l ��� 
@�`����"]4���X��[�^�p��rBlm��9&�iЖ\���#�XI�sg����a%�F�႐��T�kq���UҢ�s���ݝ�_�ͽa�޲T��I�!�k��&ʲH F x  U��qRQ3Z�v�r=-k�Wܴ��s�ڂ��8e?T;�X�We_wvSv1 @����r��}+.�U�
�8VL�4��������;l�ᡵ|�`��ffS�E4~]#�b�̌���!�ً���2(�F {S|�8���[=e�T�&i������0/�D5��_���']� � �  ��a��}�L���XO���D��2����:0��T���VK���<� 	0 �@5�/��Z4�hޱ��u��3'OO)�\�gـ��Mcѱ*�:��}�(9�͑;j"GΉ�
�dLx�s�8r&b��q5�
������J�0������^szI�QY4�Jx^xk ˖0�w���' ܕf����GpQ�� Abٶb#[����8�046�hk�fd�@��A��Ji<a��x�����ͻ}Y��7��ݾ���>*G^�������a�0|�X+g�f��k��9��kYk(űjưL�v��Wg�]�O�!ߧ�
��������w�	Xi�l�
�����6��\!Ӱ�m���J��m��o�ۆթ���Z=m�y^Q�j��T;W~�e��7������ۿ�fi��A��F�F���&�Z_��w9u���	Y'	� 
+��� ���G�Ne�ɱ�:�/���#��0ݺq�<p�z���-9Xf��.e�����ھP�Ҁ&�yz&˚�:+�-���c#�θ؟h^v��`S�v:a���*A(s��0ep!���w�����~��'s�ˇF��N.	��-����"Р7/�ͪ�sQ�!� 8�>A�[T��9Z��S�Y�7/�L5�0�4U���-���1pg8�tP �iG�P�`r0��J����I��RtLD˵��
��{v�M=Z��&�d�f �����;/��������bf��\��ͻ}K���������V{MQ$�LE��Rgn�Ur����3q��&�����3Y�LE�bSc��� �ϔ��>p{��U**�ƴh�%Jc�	�CT�%01���Fd��Pt��c՞�~��~��~y}�X�6#��s���8� x��F��ׯL���GY��>|��-�홥�wKEߥ���/�w��?ʆ�J�6�Z�}�lFg� �j� �5T����g$`ܼ�fU��H�0������O��M7�E�͇��Y�2��י���������f#2vA79�iDW ���������3/<Z��`�Ky"Ȟ�{}n�r�]�G��۠}��cp�Wc������tP�}|bzA��&?Q���J�ԝ�"��P֚1q�Hcb�ĊtWǽz �b�/�Z��+�(��r��~�'�� �8͞2>���:b�ǂ�r.�Z���D�����-��M(�[׀+�~L\�o �侒�u�[QI$`ȲE,.��sZܡ�Bxk(�q�%!�%���E�?gB�U�N��^�
 �j����	��Jo���S���������c�*��^�V�|���$�Nq���5��kt��3�R[+N b��G����hB�4"I�Fd����N��2���\�1N�*fB;�� �����I������L!����7̡�x�"�� ��\�Y�Tz�9�	�a?d!*�������֬N�	w� �H���|-�j���,���} J���p'��B~�Swϛ�9��F���+�z�zf�3&rX�C�VV�BVOq�B C!��c�V���
��˯��EˆH�H�4��>�o�S���N�3���z�<�C�`�(�	��(���F�<ЄD1�Իx�N�-\?���!p��*i�D w�Sz)�����X�zQ�L��()c1��;w�GALG��C�MB�K��w�&�bI�� ̥��T��o�ϙr�K}��yf�����F@@��t7�8�I����T����}����ٙv*=�
�z����3�ok��g�ı�|P9�# ȍV�.`7ƑoQg���s�HӒ�����|��`�HӒ���������]Hf���t�~���2;5�Lx�{��Fm����Y:�h��?�Az�W�}��8܊�'��������=p��Tη�) >ox����iލQ"��@(�t�
#�D<$_�!q�"#��n09�%�ǈ�TAۂ���]ʎH� �K�";�t<_��EtS���k�MC�)��f2�h�8Z*�Sa�%�P%wB���V.�7px�R�F�7/K�Nxљ*�bA$`I*.	 ��X,�aY��8W$#"k,�]I2�yYF����� ��O��B6�X�����9��PKZ�n�"gz��6<{N�x�z�ʚ�R�<�SVb�S�9�t��R�����w���0����[S�8 �ȫ���$r�D/�� ��k�Ba��ݡ�3�� �J>D�0���)&�^�5!}S��}�gJ'��߃y8_:*D\���0�X����'���2 �����؈��ݯ�ª�͆\/���\��sNT����p.�b�q&����[^"N}��o�S�K�[�a6 �5
~	�uuq���p^��W���k 0AaE�M8�	���ɯO �d"�:�\rYG�=����O͛<�E9�JD�dT�@y�%M'P�y[҆�'O0�r�~}L"���k�`�-P��Pxx�+���%��Oݻ)Z ��ߘ9���6d.��:�l$f#0�u�AӚx��O��O�:�Y�w��״3�<t�� � e��	%��������?D޳f*Y���Bv�_�+Ψ���H"�R�I#�	�2��3��#Jz�t��X%�ǣ�v��Tv4n6T��w��K��>�r#U��A2s��sM�5�;"�D���X��<SCI��ˬy���退3�f�9������`O��N��r�h�%i"�����	@��F[=��z���-#���{��%���P��: ў���'p�N�j���'�U�I�V���MH���\F�vuS��洰��a�` E3+E�]��g�����U��n�_W����e�q� }`W�r[�� )PZ���Mڏ�6�����b�ՄT�AXo��!{[i��M�&P0�ӵ�=��W   �����g��z]k�_�w�_�0��"�½��Ty�Nۢ�SG]mV���d�8�{]�qo������=��Y�/:���<�wQP�4�-�w�ı]���vL��Qr3�%���J����c��������ې��j�R�^֌7�yʬf���Áyb������NR����r�v�g�~~6�Z��gQ�@-���ה�aqk����1�B ���@K�t��D���#�۵9�}rs���\(Pn!@J��ce�>�̚�:@,�b���Yg�֥�M%n*	o�� �ǀX�dm����*�	A����寨9�Ԏ�g��W;�$�=S�3q����O���0w}FQ|�ݬ��}���o�!�ϗ� ��?<wYu�U�=<w�^��6�O`H�9c���7�����<����A�����2CQsz|�>7�#=L��>_�C-D6����`ݙx��z��<� �������t�D/哲�\�j@"���w�-mJ]V���z�y�*�H�5���j{�~lּ�+�2�4a� 8(� ���q���4Y{�x]�&i�10�＠���s;U��'B�~/�C�6����Bg�(�:;]֔�㼱{��Ӵ�<�;�ķߛ �~obZ�*c8�(�H`��Z����'�-^|���]��NA�`��㣦9���F��7�E���;���ڳ�L�>�ܯ�mc�zF�w?��/$�C�8Ԓ#�y�r	��Æ��4B3��[�C0Wb�1�T���W9W�6�T��7/�%g���qx���7ҁ>^sC5���L���S�4��g�gé}P��EZo�Τ�ϓ}?�� Mv��o�8�z��W�̄�&::7,�v�|��J�4/j�Fd殝��6�~ ~O0��Cӳ.��4�yжT�P�P�|LǆF�J+#�Xf(�|cZ`��ݨ���U��4')9�������ѓ�|�B�ճ�P��-$�Iz)pWܰ|s\�uS����N[�#�0��� ��۠g��1��ٔ��g��~oR,���[�x�k��.�������[�֍=�'O��5٦��JKs�[*�%�eq�c!l4n������S���*L�L����2�t��l!CwrɡkW���&���w?�V�n� ���|xk4�2���sMTq9uRI�<ۛjcS��Js��	Xk�l���}l��y�Gܥ�a��ҙ�y�	5� �T����M:���ڴ�6���8�R�������RA�=��P��g�+�>�W�W#u��W{��<�Jz)�R�R�Yf4Ɵ�<d ����p�?�� P��p�
�d�A�8�-O���Û��7����V �	��-��q˼.��q���sn[�
�S�������<EGs�1-&��ʾ0Ҡ4"���BC8~�g�C�sΫ�'0k���(9�H#V�|]k|�����"xs8$B��)@� �?n� �����#�����:˛��p�a�o
�GN{����+O���Û�����ME+��w�^ʿ^�KN[������Y�B6N;ҳ��4S�.�����X���Wh�5߱J��9�Q ��Y�n���PK67ǹT�K�V/�7�^��vd��=�;vB~=�n�����=�����}d8�x�:K<Uxk�Q�`�@�w3Ȟ��-��0�ka�vx3%�(׏�g��'��q�>���b��TקZP~*�H�YEsZ]V�߃YO�\��|����Q(>��0�ि��ȡUrh�(D�ʴzz~ik��Y�L���^6�ޕ��^���	�`6 1���D7���H�s}��^`̹�
����-_��[~ȵ0�kaZ�k������=��7��"����f�c�]�u�zle=��-� �M"ڎ�\�rБ�[�{�4��l ��]�_���� �Գ���3w�%�]��ڽp��J��]n�P� S � �	���$�G�\
y�6ś��Em1פX��m��|巙=wε��0�-�<�څ�7�4����'n��E_q�8>	����V��"XR���G�}p)����I-wCn&�t~`-u��j�����Ks-����Q�0�������  <��m��a�o�x�4H8�3���_�5�1UF�R�T�[��Q.�'Ə���m��mf�m�Ƶ0G��J�{��ٷM��DpbE�e��|�Y�����VT2���鹺攝����W�%�(�+{,?t����
Z*�~� �ħ%k��]#�+7��f�yqde&^ډr�   evD�Q��U ?��p �ds5=�l}  `�18sM��smK������f
�n���Α�	W�/M؏E�r���}Br�zW	�OU���g ��g�0t����>�fRl;,���ߙ��=�~l�~lGc�a�0t���;�"�]� �p2 \�V@��	�l�o9��9�ƽ�q�k�o��&����3�̏�=���(�w�y�>4������ m՚o�L���!)YnO"Ҫ���t��һ2g��J+��C~�+=Ի2,t_[ �P�](�(�O�y+s3y�8����+
�8�R �E����Z ��q�Ҷ��;;��!�����f���t�z����Og��&�Gl��AkhܮC�T�ds!��YX�҈jU�y5� ju����+y�G����o�[1B��߂*yD�O�y+'�+�����3=��� @Uo�v X�%����B�ͯ�����^�ȱ������y���yN�� �6�����2c�q�=�.d�E��դ��,4z��;�m� �3w@&�� �ʰ�.�8��	�0#?tm�L���� �@:X���5p�_���sN��C����3{�#��#���<��� �-�}C�g��f�k����،MB�C󢟅���4"�$=�Tp� �F`�]�Hn���^)����]�S�&�c^�V!�}�M�[��ʏx�� ��G�$�_��F�G��)���b�C�
� �FW����q}������o�jb�k�=�̶�d�%��������<��;�.�m��	��R�Qm��6XU �2@\P.��Ùg�4U8�.��i� �`D�q��:ppZ�A,����|nε��2��)D
�}&�_��;�Wʿ��=���J��D��.ea?Q� r��<�/KZ��Re)�:��oC  t�;T]� �c�s�������Bz ����8X��l	;�u<��[����{�\�ᗙ�_f6,�kF
�'s�ϛK�#f�k\�M�lc5Z����D4�TnuY�8�Q>��{�z��Rk�Pw[ڟ�E��E���ͣ�����.3 (�^��O���j���ի �MP6`p8��P������p��[�3�4�w�[�{+�?����l(	�� Ӌ��'�wӼ�qN�vz�!���J��m!'��&F���w]���ߕ���hK*Σ{OH�ڈ�zv& ���-���#?��O>_�����+؊@n&��fv��m/6�k�#�[ 3�� n����>��bji��;��yǆ���k&��og}l��:GH�n���D0w���E�u�N�f�3���h)\�R���N�t��0�L�W���*�3F�uF�u����5����N��8��W���E�5;�֪�|����h��" ��hm��;x��c�����wl(�h1e�K�T�g�	�ٷ9�N�X���-혊D.�\\'�R��pO?Q�YQk���E��Y�(� }�T�u] �;i4��X(�,�I���P�ܞx]z �~f�^)�ط!R<t���v��L�"y,��-�F��eӂ� @�L.������l�oů~r��~rm�a��� ��N�^����qGVf�vwl���rTp���|�ŕ�>@�J��8@t��c��7��]� ����>W��'W.��z���+W �ۘy��<�PS)���"���X�����D$�g�ȱf��m����ZgH��y��O�W8���9+?��KDz��a}�@�[��Ⱦ�'$Uc��c"Z� ���RZg���=r��� JqCH69��J�S>{�t-,\��:`=J����Ε�N3۟�Q�����@q�u>�fN�4)������X�X���>��yf ����
 :�������-�<����e��>���"�w9��e���q��+����藞�D?����:SϢ>T���1PlLHZ�d������6��\G�ؑ�w� ����#.�THJK�h`�죿�s� �m�����gfN��-{�R��?�֟3	5�G�u��]�LXN���:�#���L&�f�^�l���8��MO\*������] 
i����x�o���m���rbE��=�R�t�Y�[� xӥ~�N�40k����G껵�ACn&<��J�/ә��4fD��He����y�䭧��^!�6~t�?d�>��~�]�L$}U�!��&WEKq���i���^�*���!/ � �i.��߳�U���|��IHɣݸ����_�uSA`���|�zL~���P݆x�LHF
�_�'t��~j�XWf��yN��\v4�Y	��;=��ԩ��w$ybE�+#��z�*궶t��t�B�="EjTkji�'������g��~t�O>�����^]@BȆ�+e��H�ô�^>/�	N��&��}��}��u=o�?!0E�$"?��墠:�jܮypx~�h�"!�����W��L�����p�[�A�/�4/�4/����4��v.?4��L,��-e��k�HD��H�"	�Ljo�ڛ��$����G*�%��S��ͪ{���Gu��K:�����<V"JqL;��a�еO��gN�}��7����|���]NBR�M�-Q#��c*�N�G ����y�y�J��؈v��\�J�2+�����x@�6w�J��ǉ�eR����΍����5ڂ�H�Hw�F0%
�����OBSKC5�h>�Ȝ=�Mm}�ש���{.�����f]s���]�]"�s�Ҟ�eڝs��"}Х�c``u{y�#�6�V���v"�� 2���T@e*=4[�������!��C����!$]B��Fh�j��Z��  |��;���}̷�1o�p�Z� ���2+�a�f�^�z/u�[Q�u�H=�(��^S�|cQB{\�L v='�E��u��?%�n�K<��(�Y����������j��>�U���T��5��"DzK�[�, ' �����.�ݶ��@-�I��l�ݶ��@�
�SZ�vm��u��C��3!�����+���<3��P�vђ���D����G_kf[�z���@f�f�ys=���uT�P���窆��ch�g�Pq�#�]�S#��p��o���n��G�z4��z4,��ՙ*|��J���11�������d��g�a:+�7Ez�ŗ^ZB w 2�Dg�~�3�����"!�+� My�ȟ ���~�m۱�J��XA%$�x}�0�B��K���vɈ�S��;�|�L�{~�߹�6���_zڇڤ}���C5��F_���G�YӬX�^��_�u��� �^Ԛ)B!'��B=��d:�U� U���G�����G3���Zwa�t��"�����
(�U �\�/����t��ƹ��}�k@�[�yu&ޥ��:d=��Zі:T�%����m��)6�1if�4�)I����v�T?g���0�7��_����y2������b/W�����<$( ��BNg��EV'h$�	��,$��:�:���@��j�{k�-��js$�8�2Xx,0N_-8��nS��qz��ޛ���y�n��K�C+Z�X������?�HKs�A <AqK2M$$���y`���;���{���?���&ο�o�_�����}��?�UK9��ڥ�=�աޔ�:bE;��;�\�oH �1M��C��"��w=L�9�����ݷ��zm�?@��ر?�Y:W���@/8ƹ�e��$�*8�o覂�:}l�lW�rn���Y�ì�VT2u��*!Y�F�\���!���>T4*KH>��k꒪W:��g����k��o��o?�_��{jg3�y=���U�m���
��N�-W�=�^GA��M����ܺ�$M��5�|�XK9-@6���������V�&�tϗ^�e�=?���Wg?}�v�鿿�d�K�Ͽ����)�yY�\ 20+}���)%uN[��k��rFJ%R�J��z�?�_Z�"/��ĻD Lw:��YB?�[z`����0zv�Q��ǯ�.���`dy�D��:���G��z �h=
�-��r���
�6�h�E=��`�?z�%_���w���u � �9J#�F�����0��uKԁ�7h1�>w�;D�wBs�H/Wf� �F�_g��mK�{�'�Go
����)��LɊ����u���c�m��ۭz��[�^��!�����?뾙_� `E8���fw �h��E�#{�kj������?�
����`�8>7���| �����B��j`�x�I�vd3�Gu�I�-g�r����G�?����*�^�����D|��l	�&��Mԣ�G����)`'���鈻a����ך��q�����l�,�_����Ë��!%3L�Ε��1܍�v�b:0���_��=?��{~��xp�<,  �z4�D8Օ����o���uN����z�^�H�D�P�#�/��\,o�X���W��7>�H�P���^�P�ڇ������V�ֶ>7�R���Y�������50�N������~Ka����VϷ5�mm�˕���/}�M��oZĲ��R��٭sh �GA����%,��[2Äu�%�����XW�v���u�;̦3�6���I �8��`L/�9�`\rg8�[g��5��-I` @1���-Z3����0ێ	�� ڇ�l���C��>TE>��m~6�V�k��\�ƞ۩�ϓ��'��#��C]ο��[�bJ��Znog�nF�a����l�r{;g�ΣV��ӆ�� ���JCo=N%����Fbذ���͋�p�z��j � ��5�[��Yh� �i��R&눛��r	����%�D�P����(zv�Fd��oM�n#�*���'�# �5w�����>�ɓ�k*�E (�E�Y�%���8U����!���r�
o,���]��M2͖���[L����:�Wo������'�� H�;�U������G��f��� p. �p* ��? ��XH�;��_1�y��n�]����2#��)��{��W�)G�ۈ �9 x& �l�f_�1�K8fy	�,q���C}=�P�X���e�>��'`c�5m�Q�޿���M�m�p�a`����򴶣g�<"3L�7�v���Gb �P���Sgտk���՝Yml[�;�]�j h����� hW��� ��Dh��F�j�P��#��W }s?���bM��n�E���]ʄ��o�+�= �6 �p�mtm�6_�:[���/~���3�_6��}=%��k�<��[�ɨ��o^���/�[n5��p���[�K{rU�j�H�ܕSg@�I3��[Y_�e��4�Gs���_N�C͗:���f��$ ���������t����髉w�ܣ�eF|%SZ�n��fd
҈����  �0@  j��m� ��c�v(ip״�� �T�Ӌ,�uY �2 }Q[� p���5���#������)Pq���2_1LF,� ��.�� �C;��7�dEث���z	�p������K���e�<37� �6���4"{��J)� 04 ��t��@�uW��/�N�3r{;<��'�Ғxzꈹ&���l @�:C��w�f�7�ۺ�qN<��O,�wv]��z���(��bx5�#z�LVw�#-�4W��6���� ٴ�Ӝ�z1L�u������^x����K]��+��M@�g���`K*n�� ��
� ��.�e/��史����� ��g� ����ߕ��e[ ����{�Iؙǽ��� ����P���"8�o���~Y��������e��D�t�_ǲ��W���OsːV�Q�lK��^dw��w�F8 �����vw�m|�},vC������`s�1Gfy�8�� ��
0�R���9fyu{/W�,���f�<�ah��>i���ÁF���-���G�;'�WKi��{����M>(���NS{n��q��F�J��&T�C%�>��������[}�,�5�ib�G�   �=odk�����2f7��rbe��@�G�����d�N"8U"x1p,� 	�k` �o��N�`�kf�f�n�v�A��Zf��S��� ���W�)���ߛ�Sўo��G^_嚑iD��z��yR/�E������oES�c�/���#�GA��Vd�-�%@� <Blƥ���6I6��{�Kw9 bгs4�Ð�����J�w��4bխ"iDF`��`0�\������٣#����� ��2���
�W/��.�&1J#��
 �e5��F���?~�����Cӵ�[���
-�x��>%�Vku����y����T�q��D+�Z��� ��O�  ��G�Zu�?���|����e��z|H�$��i}l���=5�,�����1!�nD;U̙Lh1
lvm�h�{M罦����Z��xc �ǻ�5v�T_�	�~@}5'}���%ᭁ���\m��##��#�>�Ǧk���I�l� �@*��Dڮ飏��K���/����{SN��a��j���� ��G����GI�]E�+��4�#�6u{�� ���9 �p `�ͳű����Na�0O
�Q ���I��h���B��9���C?{�1����}t���Q�/�i}� �g%�!M߄���c��'��\}�r����)G�-��:���-�����~��_)�2T��i��35�n�a7�Bo=��H!ұ"����[�b<��l�Rs/(Y��������cr{;��<�@�{0�j]O������i���TE�LՒ#���[g�\k$�:T��$b�����k��b;���-,��|���;�5[M�Ӈ�ۡ?=& �9֚�ݿG}�>�|z�qr�k���g��G�*��-W~㗿s���$��y(�<�tr�ށlΌ�ރ�S��B��e"�Z_��X�Ih�mG�
������	��D����4㤛} �<�����R0W���w�g#������" �?�LKrc������v��]�E�"A� ����,��O.���;�Kw��*	E��E?�ku�;�\1�( �M��ە�s��o�U>�G��~9�?�k��Eu��������K�7 0���T�d�<[� �&#�sE��H=���Иk��T-|�X96�
�2�   Ҍ��r�Ȏo�vU�Y�?�<<���d�&�s���]��}���fm���"�p���C�۵���^���ԡ�r����楿�6/��)�9���t`~���Kq��B�(`�qmJ��iq׵r�+n �����E�OI��T�\���S��G� �` �m��F�Y�s�v��<ct$�� (�i4"}�RW����g���i%����z�ٺ�� ��wP-�yDp�~������2C	 ��.Ǳ�A�~e=��������*�D �o��# �N��ׇ�x=�ܜ(]P�1��M���ڴr���������~�6��J���bXW6z�6�9�ṫ.���J�ͧˉ��	a��<��Ws(A����X⅋ �!�U�+�
ţ[L@:��] Y�����5D:A�=��Y_6�#�/�ɯr.=��jw��؍ �K�͸����Vw��B������#;���GN��� ��3�z���E:G�c�oq1F��W{��2��/�Y{f%0+�R�J� >��VO�8׳/���;��l�{��{.<��7��x�>6 ֕M�4�w�Wu*��Y:^	�_pl�%W�P���U��*�����O�^��3����ۺ켦�0���y'��_N������ΠE���T)Ӎ0��ʥ� ��Qº�����M�� F��X~@4��"���h= `��6�7=�[�*{�#���(��\;&�E:�{���0C�+-�(��F�q�������h)Ǡ��W�o�2/��AP�Ҷ���U��ue��6��xs�3Q�
e�๪��ˆ�Z4W܂;�pM�{X�w��x�T���\���My}=��s�P�����ɾ�C�l�x\	���]O+)�q��e| l�x���o6<�Ҟ��Db�Dm�w=�?	@��i��n�X�z�<�@n��1�CW�����/>�{��ՙ\�����߻ņ�0�+N��c� 1zv��C��Y�υ$BŎד:T�D�Eh{xu���Ӆ��jD� C@�aX���\�阩������A~��{ӫk�|~ѧM�{���rJ��u�U#^�������?��o����2L�J��86�9Sw���<�ݖ������k��&��)�K��=���CHC*��EZVO9������OB�՗�B�z��[^��Y/���Bf�f��r{������G���	�xsI��W���I|:�MU{S՟�&´9�g�6CO�-����m#7�l{���$Z�YI*	��FX��{��zX��!���@
E�h�{[�'㿶�����c�W������k�h��]>�~��e(�P��vr)tr�¶�����<M��Uk�`�&O:ܞ2�� ��ayX�^aaD��D��H��r]��rUC!�M��;��H`�`7Ny�]�ޒj\|�"���rA��)=(>�����l�i��:����Mhȶ[�%F � ꀂ���������ZGk��Q(Id�K�_]V�.�B��x�
����f��f�_L�%k���B� �P_�AQ���r�F���~�;��EnN�}W�e�a�l��2��K���0��"�塥�¨%"�Z�kEj��f�	qa)���Ֆ	�����F�2����.�����9�R o�:^��"M`h�j::�5��:��n���ӄ��i*���B � i�8b��IH���iK*I#��C"I��^���"9V~�v�W�Z�L�$�#���,u��Pݿ��+��=k7N~9u�} 2��-��v�����3�!˕���ǖ�m]�0@6��K/����o~B+���
	��d[��^OKm��"ԛ���l�iC�d�~ƚ`��UYz��]�9l����Q�SÖ�l���^a,J�Л�z�����c��&4��J.`"�x�g煺�ٙhfۏ*�*$m!Ir^w8�o�
4��
4k���M�[�je����qimV��˞݈��&�o]�4��d嫗dv�p��[.9x���O�M?y�;���\ks]��=j��~4HV���l"&O:b,\Hj��.����;��[��M������L���1��T͵�� Mô��'���M����i��;�i����4����� �V�/�m���m�vq��@?`����������w�q���\��TJ%S�J�H��J#2���.{�RH��o����Ƣ��[�t�����:�.�	_9�C�r��8�FiD�ڇ<Po��o��~�?��D�59����j*�|�C; ��V�J��1Ȣ�������Q����Hw+�t���6� �-&Hg�	�H/�"�+���h���Ͽ�M ��@}5Gt47��7�"����o;͞�5�m���
�Pz� �V�B��
�D�N,��#�Сk��G� �\�x�����~�K�[��M h�7��/ /�q�!e�<飽O}rP�E���(��
Qg� ͆����1kb�4�ud�c��Br�lz�81����Z��+niLkL#m�������c"}Q�Jű��rG�0����d9#HV�tG�vۧ�	NrEܧ]������_�gۭ�j��5a�z � ���?BR<LO V�>!��1��\Ȏ'�mSw�^J�Lӊ�˷�����#�qޱ�D�`�O�J������-  ��0�i� �+�3+�%)c�myD�ȋ�!�@̛0�k��<u�
���|�ȧK�pІܮ'�5T}+
��G�I�P��G���tűv��  p6/� ��\E�O�9�|����+P?�vj��;�ԥUx���m�=�6[rBMH��d�'bm��ڿ,�ݘ�ʻr�3M��y��|:0?}��"5D��L�t�*�.�y�ñ��^�mp�k�V�{  `���+�P��������Um��q<��j@ۅ�~� $�����#f:�`n|_������ק��sMhX8e��_��|�T����:P��\"�&�#��ф%M"��*���3���'?�gR�zG-�/MG����MV0�Nz>�q�f�cϯ	�b!�J6�����3�Fzw�jI�tRyH�a=� *@��a����/E���IX�깗�6�^�0y�f_ ��!o�`�� '�-��o�A�,�B+�]�ֽ��C�$E�����<�'M�D�V��G����'�+2�k p%ɛ��H�
P�PY:T��E�Q!��H�D�I�܈�N��%5������Cg��w��#i�n�����|��l�<����vծMKN�M(;/T�	0 �@(�#�ѿ�t�Hz?)xk�7/	d�㦢Y�B   X��|�P�-O���w���O����?��_�6s=ouj�P�a�0�(������bN�u�z���P�"m9X��N�A����_Mؚ�cy[�E�<�GH�Yj�}���_Sa�ODZDJ��W�4� �п�~Nl�"�ي��d��� $��Wv��� f�f2�̶?���$��2��a[�XY� 9���^*{��EzB��H��@�Ѧ�{�`w�]C~�	 jZ V�O�/\�8?����Ão�B!�ί��0��eK'���}����K�5a���O��o�U~����ń��o������&lM$�CS����l�$�q�u�ԁ�*����\�Х�)�Ȩ�%\䋈���q�1��YG�Ѳ&�[`EU��Y��m�?�q ��/G��'��G<�{2u��m�<�9U�u��^��H�j�֒Do^֘օ�D3Q���"ߵ��v���i��1�9�@{#�7o��wY�P�����[^6�+'f<���U��E�O���~A|�;�iv6{+vo�e5ܮG�����sϒ��()��� �@ �"� �Pg�/b�;XdvǪK�Q����-S%M�tJ���}d�=[[�,����4s��@��P�8���9���ក9 �%+M����w��B�O/	o�����jL��fL  i�kT4 �p�İn�7�ͯ_�����}�X��7u|l������k9<H+:�����w��R/�r��3�p��(T�Z��=�}�ɩ��oQ�vM��V�Ѧ�ߛ���m}��=FBa�� �"P��8���.�;���5�W����z�e�	nv��{9\zG��ޤ�<Z�|]��Օ��1 1��q���� ���}\Zr8��iz�'�����Ҝ��Aܡzq�:&�:?�� ��	 
  Jlfa��_����w+�K��O�}��C��?u|l��؅����o+�r�� �	�ve�!z+�:�x��Uǘ͉L�v5j�:�� 0������@�1���� ̫d$�l��S���,y 
z0�ָC�w���U4暆�7 �Hfe�7�0�Ъ�Q[_6k�@��JDnD�>� �� %@��<���h@ɛ��P
/�G�!RY$DDj���#�� ����/l( �)CtD���(|�E�   }�Hf�Q��w��g��⣄Y�dU$� ��]�Wkn�7�w\�ڐ� �����l?k��^kv6��ɥ�wJK�-U��ݺ���h=  @�A�]���ߌ;ԛ�������98
�# |��i�H����e�p��g6-+��4#aO�^^u�����vX��"#��i�
�m}�:�:T��p(B�� #������\���4q"	��  ;��@������(g�i�5�qLk��{t��5�[Sշ��Yt L�u+hw�wL.�����5@6�r�
�:nv��Wjϡ�\Q$k��5�a�1��&��v�O������z��v�n �pin�=���:�ݶ��k����*�jK˳q�
�2 ;x&�!�����u]�8k�k��>b4�\���ֆa�O,����E:�"����� & �ĩc��D��H�b"��=��uf 6���ȕ�5 v�{�ߵ��?�����������gX��9�F|͵��l��g�E�(��(��Ȩ�SV �+�ƽ�Ί�3 נ�K2���6O6 ��� ���xoW�����X�W�j9�P)�Jy�q�e�����/D��ǺSǾ'3��Kוτ!�\K��s�C�$mѭ�]C��H�.�#هDI�&:�_���׶~����72`��&��h�}  `鯏���egE��R�k��ư�1���<?�Mo���4�un*)y�9�	  ZWV�����Rn]4z+�aIՉ��ݘ�%.��VN�q������n�xcmN|sͥ�����P��R�����.��/ ���4�H�,Rf�������̍��5�$�BU�����ݎ{����Id�����0}�H�D�Ǯ�R>*Ү-ƻ�J@>�"�W F   �L��ͪ��M3����i�1Q�aϡ�vL?W���in������8w�~6��"Q�_�l �t�����ş��ʘJ��2UZ�(pSI��ѩ����ݥH�a0�(T��87  � p!E�H�E���.��9�j�1�%�]��J�6�ӿt�$6 ,���}a"�Hn�3����v������_-��a���3:I^��)BJ�	 XtL^u�)��s���+��Bݔ=���5=9���ɯr  ��^׮cb��r�ڢ^h����Bu�[�ng�s(z|�B���  
 �8Dz�H�vrO޶�ܥHV���v^��<��'���JS��?�u������4sN�<�"}H�I`H#*~� @g��z�P(�~�8��sS^W�Tr��,�~�L���1;�i�πlD���o�W��ȮC�h������ְ�1Ќ�=���g@�>�\��$    � ��"J�/Y�Y�vәC_ű�TM&;�ӫ7��@t���f�g��E�O�b 4�����{�#Rx���ᥗ�#�����GC	Xo��I�Ҹׅ�9㦒�W��Q��5�O.�+ �l�"Fv�Хm��Hy_qqI�  z ��3)��X�Z�?f��(ɖ<�[���8�T�� �M}e��<�;�
�=ϵ>�Q;�0��y܌H�"E�;�
��ԇHӒ��$���>}�g�^�����tS��D�M��Ohy4Lz��&��SG���tS��QGM�1��L<?W&��)�5P�l�M����oM%� n*��BN(��D��  �mZ3%D��+Ҝټ�d$z�c�a�a��éP[Qէx�b"�<�:�5e����hum=OYaEx�__�G6��-�Z��]�'%%��+ny���X�~�L4}[ p*�����K�]WG��ܘޗ$��2�G�f�1��O��	޼�/j[�u}=�@��>F�F  �F����pm@����S(W5����B�?��So*;�4e r5�X�s��8V"��������۫t8�:�+;�d{Y��"|�����E|=�|ߟ�nkwm��6o^��JS�oM#���?�ʟacm�ܘ~�L�Pg���:asc��Z�q�I6o�wH�\Sxk@���o��I��V}��	�Q�� y��8Z3%0�J�Pf�zfax�@���z$����>�Տs�P�ԍ�큤?���]������8V�w�h��MƑ��E 8�#��F��m2����� ��)�E���[q6i�7�s��ȟ�öo��3q���xiK�hf�ff]�5|qMb�L��:)~�L��K[xk�e�C�f:d�"�������c��\"ΨGCQAx�   ��gG��vCP"�ɕ��Ǽ��ױ����~ ޠ�^[��O i�P?�v��E�I0���5��ÔW��"PR/�F �p MK
+"r����P(xt�%���~*��~��'Xt��D @B.�M{�!���1ؐ"QPQ�����)(��D ��c�{(&�~�;���}9�D=��5��]RID%���5S'����H��W�[����@�W;�P7�z�+'e����Ө�{S�T�+�Q=��Wo�V;���tx5֩���J(�ײ�nb,�`9=OyR�
�$����щ�A��K՘e�o�;�|͸�!� ��%�fUk5{e�S/4[��h��������ߋ;��U�����}ڗ�X�myr�SEk� @k���D�CP"] �j)����U��m͖������o3\ C���>��W��w�Տ��б� 8�KD���(�)Q��}�<�*�2˫�6$�M�\�(�YQ�{]Vg�q��G�5|]�V}{��]W��i��;���}����G��hO���S�B�EG��')�(�FUP�|���J����q��bW����,׏�]�R I���a�s�د�p1ZYm�U�_��&pSK���ʚ��G�!n��$nA\~)܂p!�,���Tљ*Z2�f���U�!�Ďc�uL�+��P$b�������6 ����C����s���-��?��_S����Lu_�hcA$`u�
tS[Dz�H�E�\�З�x͗�v�L�hC���^�F����t�J�.] �E����kľ����iϑS(�n�Y^���\]]�Z�!q�K�b,�BNA�(���%��h���� `25��������Q�쨛9�^�{v}�?Ctm��2��(�W��+�Ί�ݥlnL�v}�/�yEF����q����5��[�C4{	��j��?�������h*B*҇D�1���EM-���j���[ϲ���� k7��n��8,<�y�5�f:0�i����Ô����k�+��-���=@	�#@}ɫ��!Av � 0���/����Xp�q�QT�-)�,:
  0�����[�P�W�>�\�ZF}�p�9�\��*ҺS p�<�cr���UϏ]�L���h3)4� �Y ϴ��z:#�"��/��[O1�1��OB�M��.�����bK�`a���B7e ( �7åx	�L!�
*{5��Z�[u۾!Ҁ<0�c���E=����8�!Vԣ)"�>o֏�3O���(�vXq�Z�y�r9�r6i��V`5��1ǽ��gq׵���}��IF[i�����*@�Z3� $�Mn�1�)GHE��x�NӀW����m7�"��T1ĦӁٗ&�����Wfח�z���П�rU�X���#�[φb�)P J@�����h�i��B�X�$
e�|>�vL[?d̟��j>�wm���/�����_�~�r��K"b�:6<��%�E�A�P�=fѷ���ޖ��m9B*��F֣y�<e�P�|[MG�g�#6}%�H��U��_\~�k�/N�y�ZYm����'�y������ ���۲�r�)[�J e��rR|=�|9)��ArWu�g�y����G=~��4������>�<cQ"�n:z
U+6}n=
 NM� ��dW�r�/��/�?	i��h��'o�:C �1`��?U�f�/B΋���g���-��h�lz�e��)`-\����b[�ܔ)3��3���WVۍ��=�k:0��F�KL:���{��8�ri����ޑu�][�ģv
�/W5\���yڙC�:-z��]���+� ƀF�1���u3�=��h�XQ���7��y[
���2�BΙ� �����l��Y'��#Iű��B�K�h)�U���k�ɶ[��H���qjߚksۍ��'�T�E	U-��H�G��~)�E�;�E��n�o0$�*]ͼ���9��Ȫ�X�w�.�z{[m�����ν���ڑ�Y����4��W�\[�̋��@_���*i�[��@��e)��ˁ��ҳǾ�;p�ߊt�H%��D��Se�0��䪆B���"�H/{�k4(ű�y�Ƣ�r�g�0�tu�p���m��M����6<ڟY�Ķ��1�8L:��r��2��΍E��������n�G�z"m��/>�m7�i�W�̒�p�C�����1`��I*�B�[ܺ�7�R~Ͽ"җEʉ4$Ҽ�W�c整<-�E�|�j4�/"�b<��T����8��<�#�����}ƆG[����zƖG��3x/d��0��Eh[ԭĢn%2�{Q�ݬ�䭽�,�aDꋴK��E:H�Qx�<��#�e"-[���U�w�H��e@
Ԁ�MZ�w� 4�1`HEz�H?�Y/*�e����!Y���鎪�^���[꾹Jw9okh��W���_�$�;<�M�� ��5�m��E�֚��3��δm*�7�'��_U�����~��H�EZ�!�A�v�t�H���NU�@�G�֋�9��W���+o=cQ��n�"�Z@HR�Rh M����y-L~��)������{�6��Q�)�>oO��]�@s}���[1$�"M��$ҊH�"��;��Nh�~&�<a:���Ń��XPi{��R�l�*g�g�˖G��l�G+{z�)��m�9�!�3�됃��ru3,��?��Y�b������s��2=���"/�gD��HG���Ԁ�!R��B��+�6�ڦ�U���}�3R�EZ#R ���C�Pj �T�>6�:w<��2�}�������*^����01K
���5̾��e��i�Ho)Bb�PƁ��ӯE������h����g���>��޼=U?ζk��6� ƀ������S��f<+���шYoMG�RIx
9
���M�yr�}Z�M�gn|��g�y@��nx�j@R  R��i`�>JDz�H'��H�Gt_�c޳hD�*�kEZ'R�U�>3� ��"PZ���Y�并w�}�z����>�����G�Qgx3l�L��Y�����/y�g�%ϵl�iw�o��o���3��b��R�׈t�H�0�� �0	Ԁ&� m���@� �XW3O{�}l�y�U���g|X�W��������A�zMӒ��DNUcˣ���5��V��!To�����k�q�u�s  �5����4�&P��(0
T�&� ./K�t�H�$���6�ؕ��0�[O�#RI���y��P*@j�.� r*	([-
 �u� E`���mo���Yd!R8%t�@(�@.U��{KW{;oE� �����9���sR������@,�������M���3�}ƦG#�ˆ���x4"����bˣa����P���oQI�H$Kkݣ�QަGò�3��d�c�q���7W�0�h�0M+�H"�ƁA����J��@li�H�D:Z�?��dל=vl(�m�f��_��^�+��c�"�E��_�z"uD��Z�>,ұ:V��l�F��� 9 �
���u�ln$�]�鲭�
]Q/h�Y��n�Զ,����%h��.`-��>�5���g���u��#Ňڟ��r�:
j��
j���]}��ܮn��M��ځ~IMc�O���<��Fd�"֥kᔏ?�8{��&w�<7��=�W���?\�;E�E���Y��Eڤr�� \q�>m���̇  �}�L� ��6��n�m��&���L׷$j�(mB==,��Z\Lԡ�3�ƪ��bs��|�Twì$�|�fw�L��0�f�m���U�7+>cã	�'IxQ�  �3 ��:    .az���%��9�z�ɉ�� S��>R-U� ��=*&��B����Ar+���7��eD�Z\,��y��t��*\M�o��Z\�����t7�~��$�Gi��qy�Xf���-�+���w���{t��9�ʟ�C\��x���&��]���p�
��>����/AB�G⇣���  �����B��   �J�gR!Lҋ+ {��80
\
�
��� �
@
������/g����<�8�G+�i��H8�Q=:�\C����zRYz��ކ�"fa���  ���tտ�H�3����6-©~ �g{��	Uhm3J�sXzI�1@Nwʭ�2��0�-�WE   =OYԣy�Iբ{w������n�,��[m7
9����.�3�f"���X,(.	 ���%r���G ��I���DO¬91[�ML�����N��7vs�4#��  Ϯ��G��V  Kbrcs��&���%����?7[71 �����B尬f!�|��)���T���UpB"��2��׋>���@��J]/�}�5�~�s���:5�� @;3�5a98:�X�uɱ�.��%ԣCXq��`N|	    8�	X�b���!��#U�(EG� �� ��s��0�gb�%&{]O?et��VFhv 0XS�Pȹ�H�7%A5��X�94C�����Ex�s�~�������(PECin@��Ā��Ml�T~g{J�"��&b� L$iZ�̤T���g(���R6���� K{�   ��������DP�#�'z�jz��~�'bA�8Z٩�(D�F�[~��@�0)�C8_C! �c?  �ZpMA   �?Dԣ� �p4���Ǜ�$�&EK��0�` �����	^m �^F�gW޳+�e�c�RB�X,P�Z���3@
)4||��.��h �I1��9  \x+� ��Xo��9˗���X .`  l�/B�]盫$D�47` (�an�n���N����Y ��X�i�����2���܁W��?J���q�CT�%,r��Q,  ���K  �G������3n'��Dr�C�� � ��bR��VSͳL��N��e�v�S� �� � O��� y`�~�k7wK�L����K}@�c#�l�է��b1fvd�j[[�&�Z˫��*[s��d����K   �L�B����o!5V��M�á�S\�ڇ��=e-�+@"�dݣmy4A̽��ԇ�_+4���5�.~��]k� ��e�n����[�j�.)K�)g�iݸ�E!���s7��Z�y�v�떱�V?���V=�ꁧ��{Z�楳�qk��e����|&K��ˏ;���eF� ~^?���r������v�����=�UK$Ǫ8�?/�,����6����L�wW-�k��l��/���,<�{	Ak�����I��a�����`9 �b6>�P���3>�u���&c�d,X����S�;�e)���,{�B 5�����>���lݲ�/�jUC9�CL⣆��~>��=�ޥ�1��sz����sxkd���<;�K�m��U�{s��M��i0L�N���i*��
�Om�;v�E*��$����w�lbfa�+���]d��k�_GO޴������)�Yo'2+JǶ#,�D� �YxZP 5l��uXO�p�9�;�ۉDP�����g���{Ҧ���}�w��O&�^TP!  ��'s�R���P����d�$HV���E?�� ��j�]Oܡ�~��Y�]ו�&�;D�����Ǚz�8em���UJ�8E��Ez�HG�4"R_�G�+(�Y�T� F�/��/D�[nA����ô%��x�����*��a4�.���?������7
Axݣ��tt�q9�2��Y�T �
F둥�T6K��C|�>���#ߪ����%ܮ����i`:0D*���6@\���;��Z��*��+ҩ"���J�u��BY}?U�L3 �>�죝 H�"#څ�����D�	eg�]d�gD�:�=B(���q�g���ŀu]>�K�K   �Y��㶊f�_N��!�
�,�;�:��EF��b(d>�E��7!M߃����[M�Vӡ�Hi��o&� 7](,S�F  ��<{����62.�DR
ӔnbȞd) T!@0���0sa�u�k�gl���G[�U�sTK�
���6�j���c��G8f�E���2۴[AGܡ�*cQ����OB�������2��e:���ah��Eʼhr!�ڪ�V 5�� �n��.{T8����{+�#��4� �#,��&Pv�r?��:�0���^C-.u8�V|�m�uâ�iW����YrY�+@6���Q�ai��e"�|iƢ�:O�4u�*e�^Q�c�+����hv�w.��nD&둣r�ߨ�   �0��6����ے�KІG�:S.Y��c� W� ��kq��
cq���]��,�bˣmy���M��R��z�(����$A�ʳnY*�"�șF�S�ˍ�����E1�+��^!�J:X&��?��W���_��n�T ��� ��Pn�RH�\Kkã�1���F���<����;���ϵȋ�X���>c�gL���[��_�zQ/�C��4}�"�ȝ&���?�;~�掟?ޓ��>w�Oܡ|]��T����|u�S�&ߨl���?���~�(��#�F�Bu�M̚����5����6<ڦ�P��#x
�U�Ŧ=ԣ����}��ϣl�
9�>#��6=ڧ�5w	�W>�fg]�r
� �����!2��U}iOű� e�o.̦��5)��o��8_��)��(�h(g��v&���j����������ŀ����}ƒψ��M�����}��h�!`��<^�l�Mԡ�ߡM��Z\B-.A���r��c#�e�*g/AO��e�����3f/A��]��-��4L�a}���e ����CQD�}�"�)�H�␟��a_氥\}�>z"��� ������7�O_\�D?��7�-�5���3V|Ɗ�X�h�תϠR/���;�b�7Є�Ɲ�|�q��ϟ`��{��l$`=�
ֺ�@���}�L>�=.y�{8f!���(7����m״효({�����i��T�/�<���݅�ד���Bd�$}��]W�u@}5�T�d�RNs�k���2�@
@�l�v����螥��Ү{�u���і}*i�gHe_�`�m��60�mH �l),s�XÙ��Z\�Ξ]y�Cԛ>��x���������2.u�9����8�{]�'�=<:uQ��RS�H�-�HSDz���ȶ�"�Kq,�^;|j�\���/������Ջ,��us�kZ�i�9��vV/Š��~ly4�i�gl�dBӃȭ�X ���P����f�VCY�FX�FX�7�� lV����E��7�!+#nͦG{��������=����r ��6� �^�$�����TW�Byy����<xyX/@j2�ژsm̹���]$�n�Z�a;��ܥ{�$W��\�Q!��������ɿ��A�Փ��Yf�h�axO��3>,4H6<�%�o��(��X��[u�5.��� �vS5mL�J�tĻ{���6}?��}Ɠt�u�Y�1�Y�禢��@C��I�2�wM��O�t�].��Υx@�'@����^�'o+d��jYǚ����z��o�v�{�n��4��(:HV����
р�Kڅ�ل?,���3�<vI���%x-F�'�A�'�"E��؁X�&����h#l^�'�%ϥ�P$k��廌��p���*�e5�*m򤓬J�VQ��ބ���� ������1=�D�P��4���9S��	 h)�+�hѼr����k�:��8�!�.A�X�.AO��%��hH�H  �Kf���b�`�����K��jqa�6�^��=�glX�����l}�C+Fi˵��3�2:���Ig6Q�i]�5QY�i���:u��S��?����,>�Ȯ��]�c�����m_��yԊ~>F�'���J�-�u�fȊ�$ֳ�7}�-��G�K���r$��+��*@RO��E��98�s'_QN��]gd�����r�?�����f<Yu��DLut�f
9���J����Z���*�7V��;b�Ug�U&Ϛ܁��o��E��n�mt�Ջ���i�R���{D0��}���:�L]  ���|F���
����g]������-�ُ�0���&�e�R�ͪ�� 8���З�5�û(*9�\(���X�� 0�� ɉ$<�rW�.Ƴq���GIFi��^d]�i��f\.�?m� ��kq�Gv���$���{��kYmVU�U��m޼ls*@6l��U�^1ϱ"�/R 	0,�4HW�vZ�:"�b��e�i]xk��N���R�r��]��} �=�cL\�(U��mĭ�YLL���~��L�+xu=�~��Sgy�箦g��I�Z�Y01�G��l�@��b�I���ұr�,ɯL/;)0�O?@��ᮒg�����3�u���E��5���dE�����B  �+��C"6��	���B5mnF�;a&����s-.��[af4�������M% ��j�]��Ig�|<+HV��'ѵ���r�g�4�U�������GO��r0p��!?���Xf�),�_C�o�&���@��M��4qJxQfU]�&�3�G��7'5�#���^�m�����r7�.���~��~�\δߛPl_�sMx�h��`�[L ���a�*0������E<��nyv��((�a���k���_�{���ڬ��W�yۢcf:�ݾ�$�{|�"�K�Ze�,�D8T�[�˷$V�F�(1j+HA�Y����/��l�-:��w�k�>�WJ� �0�!&F�nK����͟�q��_^���������A:�2����ϫ��o�͐��[��y�>;$�,�^>�� Y�T�t˾��.暆�7/�jK�{7�x@�P#̂�	�59��I#�~���mu3��ٯ���>�guY �T�b���pC����f9�8�?��T��ig�_��-�M��>L�/�F��o=�j��= ��拠S�1�Eh�7�����Z0��y�Y����:t��M5 �� ܮ��Yg�l:�W��2��Ar?�l�<������+�A���t3��4�(�V�ޞ.m�M���r��{Sxk ǎ�DT�Vr�e�:���Cs��\m��t(ﵨ�lҀ�Zt R��S�����������ꙝ�䒇e�3��s��&��> ܏�s�y�5��E};����0t�=<y�5=�*��bu��P��C6�l+�~ݜn���dzhTI;�B}�,}lɝ0�f�A�f�)u���ˣ�:hM,c��.��w�l�&�2�b�:]��M%SGi�^4�.�Mh�U*$h�1� ǐs,��+h#�������Q�\��%���̘�=C-^������/��w�b���;'�#������
 Z�iT ��8��#�2�� ��c���Ry�}�4���:�h����f��N���f��Ǳ�
gƔ!�9�$������A=u�\�d��{����,u�h�L& XL&¢�Ru�K���,�R��b��eI̒i#;Ĥ!>�HK�v)l��Fd��>������-N_k�_A�s6à�n�\��� @6��ݡ�$�5����|�	ř�{�Un��dr,��4KU0Q~k�
�v�-��n�z��;b�,x�|�#��2i��d" �^h H�D 8���Pt��k�+����nk-�Ս�^��^f�lx	��`I#H���,����)S�u�_�$(��:���G]oԆ`���k՚V��E���<�D��n*��5K�� �4mv����`)��5^@&�s0&��3
76��k�.4���� ��W��}C|�o�Z����W7��IC~� ���[c6a  �a>̢�Wa�����D(hFzj�*D0� �d[��h�'y����y�]��d��8ɪ��e6a3�X�_�����_�x����'��E-.Vw�?�,g����3@�Y�R6��F��굸X�u�M=:�'��5@v�����Hm���sR�dWZ���3=o����Omu� i�&6�h�}���Vx�
 ��wk�1V������U��&)� �t�I���� ���jה�_�4�[ߤ�7էC���$@��PH�"��b����~�_�� ���Ow_����/q�Rc���n�Ņ��:��WI�H�.YM���7���m��>�6�&��XjB�{��	����D��eD�n+C|�ٺ��\��Z�����i�)��u�&�n�S���0y&��aK�Z�P�B�pT�n1�uѺ9.�<C��>� ��l�UΗ���9Y��ٍ�#��C}T��kj���M�/���|����ڟ��HYn8�3�jՍ�:E������i�^�FӌK�_w�����7"��z'��	�tS��sXȧZ\�����K�0�.�bQ�:u	��pl��>l���n���_s��܂�	3���Rr��S~����n�������^�Ӧ�����h= ���jUM5�YN�-�a�v�)�͂D�*�`Afo(g��U����z �0y��[no��֥.�e���.��Lk�T=qˈ�A;5���Kޑ�Q�I��P�t�j�@o��~�n=Jz�)���x����W�V9�u2��t���O��c�{����O��Zڸ�Ec~e~lC���z�������y���Wbz��D9��^���8�:l����Ng7Nb>�v�� �� N���{�l[>��R&J� ��kS��p3ћCP��$�[���T#�?۠�F�~h��ۥ�������1�YN�CKnog�n�@7���Ha�UQ���
d��ʮF-ᭁ���b�x�U��?3[�vaX���F�a��� &����R�^׷/�(�6�n��;��t������X|?���s���A�L�]��3dΦƿ8���WF|͸�5s�M�;1�/����FB��(,�b!����~x�f�f
'Y��g��Q���h�����#�Wb�.N�Q/� `���6�Y�*���3uyAۻ��Qq�^s#�t��p'j	��^Z��m�}͸�%!��&�$q�k:�$���.��H�ve[P��T��x����W��9����9]z��������:�����jc��  @7s�'PR��5ׄ�v��F�2�y���� 8��9�����Z(�?���)H#)U��n6L^ `��|�d��O�S�_0p\��xx`VM�1_,���Yn����o�?���O�R���k���SX�"tS���$x�u�S�k!w���#&"<�SK�|�E�#����ݟh~ 6�.���?pL\<Y��u_n���g���a(!İ�hJ�����s�e�-�C�j�~q�/0���K=:��;���Fy�������w�.��@�*�.��.�f�a=����6F�.�?�d�v�/0
�md��?Ė[��]h��M &�`P|?����K���S`X0vtrI�������5x=H�5�A%H���`���)���n#��)�����<�o��z���{�_��h�f=:Xt'�Mb�����OYx��u
�,�-{��o��ou����2�`��jq����R;�*ԣC�� �<�4#S�D�G�~�Cr۹�
b�Yi���!�A�І�#���'��8�^`�j����KK�}��n؇3�*S�VU@�a
O�UP9N�:�v��j���;X�>�ǾQ�a�؀v�p-mf�* ��@���u}ą��40�?�U�� u}ҵ�H!���E�N�.�$X�j��g#��wF�Z���ԯB _�Q`+�	n��ne��j!����pG��}��ꃲ��W����@Ј�c��Pl�U}��ջ~_e wx��3��`���)�M1�n}D�|���S�>�d��z?���튡
�R�@?��@�]���k���p�J��Gks� V��R��v�S;X��G����A��鿥��G�T��6	�<�:��Ha?t>���E�{� ެU ��Rև[�p����y��c� �u

�md��Ky�'<�D�&fkG�à`���^��?���&:�d���8jxL0[;>ϓ�pn�&}8&����䱥�襼�e� R��"p�O�.e}L ��)�`qo��E}ŭ�<	�U��+���*
`L��6uSA/���� ��?ʀ�u��/-}ֹi|���
L�����]��o��5
t��`m�����3$�
�bq�A?~!�����W`C�>���y�t������>����b��qA�Mg�8�r�oOj�]�@�҇���N���iB�qs\ %q�Z��(l�U}��T#�2tU. 6D�϶��ۥl7O馂�J5
Dp	R��i�N9*������*t�d0� \��Ϟ�햍��o��	��M���V%i��gh�v��7�.�nM�mۥ,7�G�;�CO%�V��l7�9�3S�� �BG}� ^���d��uW�ec��P�S��䒽\yo��Fd
��Հ3%f��"��刅m]" 	��P��p8'����d�9~l{�u]�溩��4)<��� <��׈�L�ZY��Έ6��K��/ɷ�`�N�N�����6-cQLew�r��PqmZ������d�`�`��/�\�������\��%;��R�5Tl�UK[K�)t�5u
�fec�oJE���5���]��x�9|�a�
f�o�v)˞�[�y�˪�����m����H#2Žp���u��p	V�mH�����'�mO��Y�jn�6ƪ�	�]6$}�'ec�YYpBe�0}�f�t�md�v]Xo�2�p��\�ݎ �o�?�3�r{���p��X�>լ.�N훦j�`kF*�� �1�-5�=]�=���0�",Is՟�4B32����v��;������Ұ6ו<�ze5�w�~��P�#:�(���4B��%�.R(�A����� ǡ���X�1�2�({�ʆ �J����{����A"w��"d���M_^��z`�ao�9���ım�����B
MX�%x��`͛�}����m���G��J�P�E�������E��|_��p;�sЈ��І:��<���,Vv�{Fؔ$��:̈���Y��?�!8	q<n�@5X�"��`�z���#,��sp.�Y��
l@bhAH:R���ם��]!�,�8
���	8�P��-}����g�BjP�Sp �7���A��Zm4��Н=���A���)ؗ���c)�`f`<+�	�k���~;���E�>���}f)�ߤ               [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://dha1ylj1o3f0s"
path="res://.godot/imported/pirouette_sketch.png-f8d10a5f1b8fe97eb0b156240e7825cd.ctex"
metadata={
"vram_texture": false
}
    [remap]

path="res://.godot/exported/133200997/export-2ddd04d543d5858e7f20c9299a8b5096-main.scn"
               list=Array[Dictionary]([])
     <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 814 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H446l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z" fill="#478cbf"/><path d="M483 600c0 34 58 34 58 0v-86c0-34-58-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
              ���E�� W   res://Scenes/main.tscn�|��F��I    res://Sprites/bouncer_sketch.pngr{���n   res://Sprites/floor2.png�oL��r   res://Sprites/icon.svg����2j"   res://Sprites/pirouette_sketch.png�oL��r#   res://builds/boogy/Sprites/icon.svg           ECFG      application/config/name         test   application/run/main_scene          res://Scenes/main.tscn     application/config/features(   "         4.2    GL Compatibility       application/config/icon          res://Sprites/icon.svg  "   display/window/size/viewport_width         #   display/window/size/viewport_height         !   editor/movie_writer/mjpeg_quality     �������?   editor/movie_writer/movie_file0      '   C:/Git/Godot2/Test/REcords/Gameplay.avi    input/up�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   W   	   key_label             unicode    w      echo          script      
   input/down�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   S   	   key_label             unicode    s      echo          script      
   input/left�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   A   	   key_label             unicode    a      echo          script         input/right�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   D   	   key_label             unicode    d      echo          script         input/LeftClick�              deadzone      ?      events              InputEventMouseButton         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          button_mask           position              global_position               factor       �?   button_index         canceled          pressed           double_click          script         input/Restart�              events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   R   	   key_label             unicode    r      echo          script            deadzone      ?
   input/Quit�              events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script            deadzone      ?   layer_names/2d_physics/layer_1         Bouncer    layer_names/2d_physics/layer_2         Dancer     layer_names/2d_physics/layer_3         Queen   #   rendering/renderer/rendering_method         gl_compatibility*   rendering/renderer/rendering_method.mobile         gl_compatibility             