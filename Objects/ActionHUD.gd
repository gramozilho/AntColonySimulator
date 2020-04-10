extends Control

var party_size = 0 setget update_party_size

func _ready():
	pass

func update_party_size(change_to):
	party_size = change_to
	$VBoxContainer/PartySelect/PartyAnts.text = str(party_size)

func update_party_size_request(amount):
	var target_size = party_size+amount
	if (target_size > 0) and (target_size <= ColonyManager.ants):
		self.party_size += amount

func _on_LessAnts_pressed():
	update_party_size_request(-1)

func _on_MoreAnts_pressed():
	update_party_size_request(1)