extends Camera2D

var randomStrength: float = 1
var shakeFade: float = 5
var rnd = RandomNumberGenerator.new()
var shake_strength: float = 0.0

var startingOffset

# Called when the node enters the scene tree for the first time.
func _ready():
	startingOffset = offset


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		if shake_strength > 0:
			shake_strength = lerpf(shake_strength,0, shakeFade * delta)
			offset = randomOffset() + startingOffset
			
func applyShake():
	shake_strength = randomStrength
	
func randomOffset()  -> Vector2:
	return Vector2(rnd.randf_range(-shake_strength,shake_strength), rnd.randf_range(-shake_strength,shake_strength))
	

