extends AudioStreamPlayer

func _ready():
	%DialogueLabel.spoke.connect(play_audio)


func play_audio(letter: String, letter_index: int, speed: float):
	if letter_index %2 == 0:
		play()
