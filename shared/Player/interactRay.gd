extends RayCast3D

@onready var prompt = $Prompt
@onready var message = $Message
@onready var timer = $Timer

func display_message(text, delay):
	message.text = text
	timer.start(delay)
	
func _physics_process(_delta):
	prompt.text = ""
	if is_colliding():
		var collider = get_collider()
		
		if collider is Interactable:
			prompt.text = collider.get_prompt()
			
			if Input.is_action_just_pressed(collider.prompt_action):
				collider.interact(owner)
				display_message(collider.interacted_message, collider.interacted_message_delay)

func _clear_message():
	message.text = ""
