class_name CombatSkill extends Skill

# a skill that is used to deal damage in combat. It integrates dodge/block-check for target
# Note: None-Attack skills might derive from Skill with canUseInCombat=true


func canUseInCombat()->bool:
	return true

func doAction(_action:String,_targets):
	var attacks=previewCombatAction(_action,_targets)
	getCost().pay(user)
	for i in range(attacks.size()):
		attacks[i]=calcAttack(attacks[i])
		if(attacks[i].OK):
			for _item in attacks[i].onHit:
				for eff in _item.eff:	#TODO check if Target is still not dead yet?
					_item.target.effects.addItem(eff)
					if(attacks[i].onHitMsg):
						Global.hud.say(attacks[i].onHitMsg.call())
		else: # attack missed
			Global.hud.say(attacks[i].Msg)
		#if(checkDogded(_target).OK):
		#	Global.hud.say(_target.getName()+" avoided "+user.getName()+" attack.")
		#else:
		#	applyAction(_action,_target)
	coolDown=defCoolDown

func previewCombatAction(_action:String,_targets)->Array[AttackData]:
	var attacks:Array[AttackData]=[]
	for _target in _targets:
		attacks.push_back(getAttackForTarget(_target))
	return(attacks)

## override this
func getAttackForTarget(target:Character)->AttackData:
	var attack:=AttackData.create()
	return attack

## calculates the damage of an attack
func calcAttack(attack:AttackData)->AttackData:
	var result = AttackData.create()
	var defender=attack.onHit[0].target
	scaleEffect(attack);
	# check if target can evade
	result = calcEvasion(defender,attack)
	if(result.OK==false):
		return(result)
	var _tmp = result.Msg;
	# check if target can block or parry
	result = calcParry(defender,attack)
	if(result.OK==false):
		return(result)
	_tmp += result.Msg;
	# deal damage
	result = calcAbsorb(defender,attack)
	_tmp += result.Msg;
	result.Msg = _tmp;
	return(result);

# calculates if target can evade the attack 
# requires minimum Poise
# Evasion depends on Agility & Endurance:
# - mallus for heavy armor & weapon
# - mallus for Effects like Prone, Frozen
# - bonus for Skills: Flying, Dancer
# Stunned/Bound Chars can not evade 
# on evasion returns false and a message
func calcEvasion(defender,attack:AttackData)->AttackData:
	var hitRate = attack.hitChance 
	#*(attacker.Stats.get("agility").value + attacker.Stats.get("perception").value);
	#0+lvlDiffBonus*(target.Stats.get("agility").value + target.Stats.get("perception").value);  
	var rnd=randf()*100
	if(attack.isTease):
		if(hitRate<rnd):
			attack.OK = false;
			attack.Msg += defender.getName() +" wasn't affected by teasing."
	else:		
		if(hitRate<rnd):
			attack.OK = false;
			attack.Msg += 'Using agility, '+ defender.getName() +' was able to dodge the attack.</br> '

	return attack


# If evasion-roll fails, their is a chance that parry is rolled:
# - consumes some poise
# - parry only works for weapon of similiar size: a Zweihänder is to slow to parry a saber, a dagger is to light to deflect a club
# - requires minimum weapon-skill (f.e. projectile deflection )
# otherwise continue chain
# parry-result depends on agility+perception
# - bonus for skills
# - bonus for some weapons
# on critical fail- full damage, poise damage
# on fail - full damage
# on success no damage is taken (might consume weapon-stability)
# if a critical is rolled, 50% of the attackers damage is reflected to him
func calcParry(defender,attack:AttackData)->AttackData:
	return attack	#TODO
	
#if all else failed you have to absorb the hit:
#DR = sum of armor (with individual skill-bonus) + magic armor
#attack = weapon damage formula + weakness-bonus
#attack increases on critical
#hp-dmg = attack -DR but min.1
func calcAbsorb(defender,attack:AttackData)->AttackData:
	attack.Msg+= "[br]"+defender.getName() +" got hit by "+user.getName()
	return attack

func scaleEffect(attack):
	var _adapt=func(op):
		var target:Character
		var dmg
		var rst
		var arm=0.0
		for i in range(op.size()):
			target = op[i].target;
			for n in op[i].eff:
				if(n is effDamage): #dmg = (attack-armor)*(100%-resistance) but min. 1pt
					#arm = target.Stats.getItem('arm_'+n.type).value;
					rst = target.getStat('rst_'+n.type).value;
					dmg = max(1,(n.magnitude-arm)*(100-rst)/100);
					n.magnitude=dmg;
					#TODO if rst>=100 "your skill doesnt seem to have an effect"
					#if(target.effects.hasItemID("effMasochist")):
					#	op[i].eff.push(effTeaseDamage.factory(dmg,'slut',{slut:1})); //todo lewd-calc
				
				if(n is effLustDamage):
					#todo no dmg if blinded, stunned,
					#todo vulnerable if inHeat, like/dislike attacker
					#bondage-fetish -> bonus for bond-gear
					#n.amount *= 1+Math.sqrt(n.lewds.slut)/10; //bonus for slutty wear
					rst = target.getStat('rst_'+n.type).value
					dmg = max(0,(n.magnitude-arm)*(100-rst)/100)
					n.magnitude=dmg
					pass
				#if(n instanceof effPoiseDamage):	TODO
				#	#TODO skill RESOLUTE gives invulnerability
				#	arm = target.Stats.getItem('arm_poise').value;
				#	rst = target.Stats.getItem('rst_poise').value;
				#	dmg = Math.max(0,(n.amount-arm)*(100-rst)/100); //might cause 0 dmg
				#	n.amount=dmg;
							
	_adapt.call(attack.onHit);
	_adapt.call(attack.onCrit);


## rolls if the receiver dodged the attack
func checkDogded(_target:Character)->Result:
	var _res=Result.create(true,"")
	#self.user
	# success depends on: receiver-dodgerating, attack-hitchance, 
	# receiver stunned, blinded,
	if(randf()<0.9):
		_res.OK=false
	return _res

#TODO checkParry   checkBlock

#TODO func getAnticipationText(_attacker, _receiver):
