function dutils_damage_all_enemies(arg0)
{
	var damage = arg0;

	var nb_enemies = array_length(global.monstertype);
	for (var i = 0; i < nb_enemies; i++) {
		if (global.monstertype[i] == 0)
			break;

		scr_damage_enemy(i, damage);
	}
}

function dutils_damage_enemy(arg0, arg1, arg2=global.dfight_opt_target_all)
{
	var enemy_id = arg0;
	var damage = arg1;
	var target_all = arg2;

	if (target_all) {
		dutils_damage_all_enemies(damage);
	}
	else {
		scr_damage_enemy(enemy_id, damage);
	}
}
