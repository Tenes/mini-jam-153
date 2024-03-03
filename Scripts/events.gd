extends Node

signal bar_clicked(successState);
signal on_interactable_collided(start, length);
signal update_score(value);
signal update_multiplier(isSuccess);
signal update_durability(value);
signal reset_bar();
signal player_death(finalScore, bestMultiplier);
signal touched_prey();
