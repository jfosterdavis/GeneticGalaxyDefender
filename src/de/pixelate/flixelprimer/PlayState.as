package de.pixelate.flixelprimer
{
	import mx.core.FlexTextField;
	import org.flixel.*
	import flash.utils.ByteArray;
	import flash.net.registerClassAlias;


	public class PlayState extends FlxState
	{		
		[Embed(source="../../../../assets/mp3/ExplosionShip.mp3")] private var SoundExplosionShip:Class;
		[Embed(source="../../../../assets/mp3/ExplosionAlien.mp3")] private var SoundExplosionAlien:Class;
		[Embed(source = "../../../../assets/mp3/Bullet.mp3")] private var SoundBullet:Class;
		[Embed(source = "../../../../assets/mp3/PowerDown4.mp3")] private var PowerDown:Class;
		[Embed(source = "../../../../assets/mp3/AlienLaugh1.mp3")] private var AlienLaugh1:Class;
		//[Embed(source = "../../../../assets/mp3/AlienLaugh2.mp3")] private var AlienLaugh2:Class;
		[Embed(source = "../../../../assets/mp3/AlienScream.mp3")] private var AlienScream:Class;
		[Embed(source = "../../../../assets/mp3/AlienScream2.mp3")] private var AlienScream2:Class;
		[Embed(source="../../../../assets/mp3/EvilLaugh.mp3")] private var EvilLaugh:Class;

		private var _ship: Ship;
		private var _aliens: FlxGroup;
		private var _bullets: FlxGroup;		
		private var _spawnTimer: Number;
		private var _spawnInterval: Number = 2.5;
		
		//private var _notificationTimer:Number;
		//_notificationInterval: Number = 1;
		
		//text
		private var _scoreText: FlxText;
		private var _aliensInPlayText: FlxText;
		private var _aliensInGoalText: FlxText;
		private var _budgetProgressText: FlxText;
		private var _gameOverText: FlxText;
		private var _endOfRoundText: FlxText;
		private var _aliensThatDiedFromLowPowerText:FlxText;
		private var _ammoLeftText:FlxText;
		private var _alienBudgetLeftText: FlxText;
		private var _currentRoundText:FlxText;
		private var _legendText:FlxText;
		private var _scoreLabel:FlxText;
		private var _speedLabel:FlxText;
		private var _primaryAmmoLabel:FlxText;
		private var _secondaryAmmoLabel:FlxText;
		private var _notificationText:FlxText;
		private var  upgradesPeek:String;
		private var hasTipBeenDisplayed:Boolean = false;
		//alien labels
/*		private var _alienArmorText:FlxText;
		private var _alienMotorText:FlxText;
		private var _alienCPUText:FlxText;
		private var _alienBatteryText:FlxText;
		private var _alienSensorsText:FlxText;*/
		
		//ammo upgrades
		private var _round2AmmoUpgrades:Array;
		private var _mediumAmmoUpgrades:Array;
		private var _advancedAmmoUpgrades:Array;
		
		private var _isVerboseTextShowing:Boolean;
		
		//aliens that made the goal
		private var _aliensThatMadeGoal: FlxGroup;
		
		//low power death tally
		private var _deathsFromLowPower:uint = 0;
		
		//aliens from the previous round
		private var _spawnCache:FlxGroup;
		
		//equipment locker, holds all equipment possibilities
		private var _PlayStateEquipmentLocker:EquipmentLocker;
		
		//score from this round
		private var _scoreThisRound:int;
		
		//game variables
		private var _budget:uint; //the amount of cost for aliens each round.
		private var _spentThisRound:int;
		private var _round:uint;//the current round of play
		private var _transitionCounter:Number; //holds the current time left to transition after round is over
		private var _roundIsOver:Boolean;
		
		public function PlayState(inst_round:uint = 0, inst_previousSurvivors:FlxGroup = null):void
		{
			if (FlxG.score < 0)
			{
				FlxG.score = 0
			}
			
			_scoreThisRound = 0;
			
			if (inst_previousSurvivors != null)
			{
				if (inst_previousSurvivors.countLiving() < 1) //make sure that if the evolve state passes and empty group that you start from scratch again.
				{
					_spawnCache = new FlxGroup;
				}
				else
				{
					_spawnCache = inst_previousSurvivors;
				}
			}
			else
			{
				_spawnCache = new FlxGroup;
			}
			
			//set up the equipment locker
			_PlayStateEquipmentLocker = new EquipmentLocker;
			
			
			_spentThisRound = 0; //so far spent towards budgetf
			_roundIsOver = false;
			_transitionCounter = 0;
			
			_isVerboseTextShowing = true;
			
			_round = inst_round;
			_round++;
			
			_budget = 1500; //+ _round*50;
			if (_round > 3)
			{
				_budget = 500 + 150 * (_round );  //budget increases as time goes on
			}
			
			bgColor = 0xFFABCC7D;
			
			//set up the ammo upgrades
			//Bullet(x: Number=0, y: Number=0, length:uint=16, height:uint=4, fmodel:String="No name given", fdamage:uint=1, fcost:uint=1, fspeed:Number=500)
			_round2AmmoUpgrades = new Array();
			_round2AmmoUpgrades.push(new Bullet(0, 0, 3, 100, "Flying Wall", 1, 3, 200));
			_round2AmmoUpgrades.push(new Bullet(0, 0, 16, 4, "Bullet 2.0", 2, 2, 550));
			_round2AmmoUpgrades.push(new Bullet(0, 0, 16, 4, "Fast Bullet", 1, 2, 800));
			_round2AmmoUpgrades.push(new Bullet(0, 0, 20, 20, "Space Mine", 25, 10, 30));
			_round2AmmoUpgrades.push(new Bullet(0, 0, 550, 2, "Laser 1.1", 1, 3, 2300));
			
			
			_mediumAmmoUpgrades = new Array();
			_mediumAmmoUpgrades.push(new Bullet(0, 0, 3, 130, "Flying Wall 2.0", 2, 6, 200));
			_mediumAmmoUpgrades.push(new Bullet(0, 0, 16, 4, "Bullet 3.0", 3, 3, 750));
			_mediumAmmoUpgrades.push(new Bullet(0, 0, 16, 4, "Fast Bullet 2.0", 1, 2, 1100));
			_mediumAmmoUpgrades.push(new Bullet(0, 0, 25, 25, "Space Mine 2.0", 35, 15, 25));
			_mediumAmmoUpgrades.push(new Bullet(0, 0, 600, 3, "Laser 1.5", 1, 4, 2500));
			_mediumAmmoUpgrades.push(new Bullet(0, 0, 200, 2, "Slicer 1.0", 3, 12, 50));
			
			_advancedAmmoUpgrades = new Array();
			_advancedAmmoUpgrades.push(new Bullet(0, 0, 3, 150, "Flying Wall 3.0", 4, 15, 200));
			//_advancedAmmoUpgrades.push(new Bullet(0, 0, 16, 4, "Bullet 3.5", 3, 3, 750));
			_advancedAmmoUpgrades.push(new Bullet(0, 0, 12, 3, "Fast Bullet 3.0", 2, 2, 1500));
			_advancedAmmoUpgrades.push(new Bullet(0, 0, 12, 3, "Fast Bullet 3.5", 4, 4, 1500));
			_advancedAmmoUpgrades.push(new Bullet(0, 0, 35, 35, "Space Mine 4.0", 45, 30, 15));
			_advancedAmmoUpgrades.push(new Bullet(0, 0, 700, 4, "Laser 2.0", 2, 6, 3000));
			_advancedAmmoUpgrades.push(new Bullet(0, 0, 700, 6, "Laser 3.0", 5, 8, 3000));
			_advancedAmmoUpgrades.push(new Bullet(0, 0, 300, 2, "Slicer 2.0", 5, 20, 50));
			
			

			
			_ship = new Ship();
			//give ship bullets based on round
			var magsize:uint = 180 + 40 * _round;
			var magsize:uint = 180 + 40 * _round;
			_ship.setMagazineSize(magsize);
			//testing advanced bullets
			//var advBullet:Bullet = new Bullet(0, 0, 3, 100, "Flying Wall", 2, 2, 200);
			//_ship.setPrimaryAmmo(advBullet);
			trace("playstate is filling ammo");
			_ship.restockMagazine();
			
			//give advanced ammo
			if (_round >= 9)
			{
				_ship.setPrimaryAmmo(new Bullet(0, 0, 12, 8, " .45 Magnum", 6, 4, 700));
				_ship.restockMagazine();
				_ship.setSecondaryAmmo(_advancedAmmoUpgrades[Math.floor(Math.random() * (_advancedAmmoUpgrades.length))]);
			}
			else if (_round >=5)
			{
				_ship.setPrimaryAmmo(new Bullet(0, 0, 16, 7, "Bullet 2.1", 1, 2, 600));
				_ship.restockMagazine();
				_ship.setSecondaryAmmo(_mediumAmmoUpgrades[Math.floor(Math.random() * (_mediumAmmoUpgrades.length))]);
			}
			else if (_round >= 2)
			{
				_ship.setSecondaryAmmo(_round2AmmoUpgrades[Math.floor(Math.random() * (_round2AmmoUpgrades.length))]);
			}
			
			//make faster as time goes on
			var velocityModifier:uint 
			//but if this wave is a randomly assorted round (aka no survivors) then keep the velocity modifier low this round
			//also give a bonus for every 10 points
			if (inst_previousSurvivors == null || inst_previousSurvivors.countLiving() < 1)
			{
				velocityModifier = 25 + FlxG.score / 10;
				_budget += 1000 + 300*_round;
			}
			else
			{
				velocityModifier = 25 * _round + FlxG.score/10;;
			}
			_ship.setVelocityModifier(velocityModifier);
			
			add(_ship);
			
			
			
			
			_aliens = new FlxGroup();
			add(_aliens);
			
			_aliensThatMadeGoal = new FlxGroup();
			//commented out the following line. if this group is a part of the state then it will be destroyed upon changing states
			//add(_aliensThatMadeGoal);
			
			_bullets = new FlxGroup();
			add(_bullets);

			//initialize texts		
			_scoreText = new FlxText(10, 30, 200, "0");
			_scoreText.setFormat(null, 32, 0xFF597137, "left");
			_scoreText.text = FlxG.score.toString();
			add(_scoreText);
			
			_aliensInPlayText = new FlxText(400, 8, 400, "0");
			_aliensInPlayText.setFormat(null, 12, 0xFF597137, "left");
			add(_aliensInPlayText);
			
			_aliensInGoalText = new FlxText(550, 8, 400, "0");
			_aliensInGoalText.setFormat(null, 12, 0xFF597137, "left");
			add(_aliensInGoalText);
			
			_aliensThatDiedFromLowPowerText = new FlxText(550, 25, 400, "0");
			_aliensThatDiedFromLowPowerText.setFormat(null, 12, 0xFF597137, "left");
			add(_aliensThatDiedFromLowPowerText);
			
			_budgetProgressText = new FlxText(800, 8, 400, "0");
			_budgetProgressText.text = "Alien budget spent: $0";
			_budgetProgressText.setFormat(null, 12, 0xFF597137, "left");
			add(_budgetProgressText);
			
			_ammoLeftText = new FlxText(_ship.x, _ship.y + 20, _ship.width, "0");
			_ammoLeftText.setFormat(null, 10, 0xFF597137, "center");
			_ammoLeftText.text = _ship.getMagazineRemaining().toString();
			add(_ammoLeftText);
			
			
			_alienBudgetLeftText = new FlxText(800, 25, 400, "0");
			_alienBudgetLeftText.setFormat(null, 12, 0xFF597137, "left");
			_alienBudgetLeftText.text = "Alien budget left:  $"+_budget;
			add(_alienBudgetLeftText);
			
			
			_currentRoundText = new FlxText(100, 10, 200, "0");
			_currentRoundText.setFormat(null, 20, 0xFF597137, "left");
			_currentRoundText.text = "Level "+_round;
			add(_currentRoundText);
			
			
			_legendText = new FlxText(0, FlxG.height-55, FlxG.width, "0");
			_legendText.setFormat(null, 10, 0xFF597137, "center");
			_legendText.text = "Keys: \nspacebar=Fire, up=move up, down=move down, P=Pause, +=volume up, -=volume down, \nT=toggle Alien equipment labels, R=restart current Level, F=toggle primary/secondary ammo  \nKill Alien = 3 points, A higher score makes you faster."
			add(_legendText);
			
			_scoreLabel = new FlxText(10, 15, 75, "0");
			_scoreLabel.setFormat(null, 16, 0xFF597137, "left");
			_scoreLabel.text = "SCORE"
			add(_scoreLabel);
			
			_speedLabel = new FlxText(215, 8, 100, "0");
			_speedLabel.setFormat(null, 10, 0xFF597137, "left");
			_speedLabel.text = "Ship speed: " + _ship.getShipSpeed();
			add(_speedLabel);
			
			_primaryAmmoLabel = new FlxText(215, 35, 180, "0");
			_primaryAmmoLabel.setFormat(null, 8, 0xFF597137, "left");
			_primaryAmmoLabel.text = "Primary: " + _ship.getPrimaryAmmoName();
			add(_primaryAmmoLabel);
			
			_secondaryAmmoLabel = new FlxText(204, 45, 180, "0");
			_secondaryAmmoLabel.setFormat(null, 8, 0xFF597137, "left");
			_secondaryAmmoLabel.text = "Secondary: " + _ship.getSecondaryAmmoName();
			add(_secondaryAmmoLabel);
			
			_notificationText = new FlxText(FlxG.width, FlxG.height, FlxG.width, "0");
			_notificationText.setFormat(null, 32, 0xFF597137, "center");
			
			
			
			
			resetSpawnTimer();
						
			super.create();
		}

		override public function update():void
		{			
			//FlxG.updateTimers();
			
			FlxU.overlap(_aliens, _bullets, overlapAlienBullet);
			FlxU.overlap(_aliens, _ship, overlapAlienShip);
			
									//update bullet text
			//update text position and value
			_ammoLeftText.x = _ship.x;
			_ammoLeftText.y = _ship.y + 19;
			var ammoleft:int = _ship.getMagazineRemaining();
			if (ammoleft > 0)
			{
				_ammoLeftText.text = ammoleft.toString();
			}
			else
			{
				_ammoLeftText.text = "0";
			}
			
/*			//update alien subtexts
			for each (var alien:Alien in _aliens.members)
			{
				alien.refreshPositionOfTexts();
			}*/
			
			//trace("here is _aliens", _aliens, "array: ", _aliens.members);
			//kill any alien out of battery power
			// or if someone makes the goal line
			for (var i:String in _aliens.members)
			{
				//check for goal made
				if(_aliens.members[i].x < 10 )
				{
					//the alien laughs because he made the goal
					FlxG.play(AlienLaugh1);
					
					//change aliens state to 7 (goal made)
					_aliens.members[i].setGoalState(true);
					//update this alien
					_aliens.members[i].update();
					
					//remove this aliens' texts
					_aliens.members[i].killTexts();
					
					//add this alien to the goals group
					_aliensThatMadeGoal.add(_aliens.members[i]);
					
					//remove this alien from the _aliens group
					//this should stop him from moving.
					_aliens.remove(_aliens.members[i], true);
					
					//take points away from player
/*					if (FlxG.score > 0)
					{
						FlxG.score --;
						_scoreThisRound --;
						_scoreText.text = FlxG.score.toString();
					}*/
				}
				
				//trace("i am looking at a ", i);
				else if (! _aliens.members[i].getPowerState())
				{
					FlxG.play(AlienScream2);
					//var emitter:FlxEmitter = createEmitter();
					
					_deathsFromLowPower ++;
					
					var emitter:FlxEmitter = createEmitter();
					emitter.at(_aliens.members[i]);
					//FlxG.play(SoundExplosionAlien);
					_aliens.members[i].kill();
					_aliens.remove(_aliens.members[i], true);
					
				}
			}
			
			if(FlxG.keys.justPressed("R") && _ship.dead == false)
			{
				//reset the round
				FlxG.score -= _scoreThisRound;
				_round --;
				FlxG.state = new PlayState(_round,_spawnCache);
				

			}
			
			if(FlxG.keys.justPressed("SPACE") && _ship.dead == false)
			{
				//spawnBullet(_ship.getBulletSpawnPosition());
				var bullet: FlxObject = _ship.fireBullet();
				if (bullet is Bullet)
				{
					_bullets.add(bullet);
					//play sound
					FlxG.play(SoundBullet);
				}
				

			}
			
			//check to see if the texts were hidden or shown
			if (FlxG.keys.justPressed("T"))
			{
				if (_isVerboseTextShowing) //the shut it off
				{
					for each(var alien:Alien in _aliens.members)
					{
						alien.hideVerboseTexts();
					}
					
					_isVerboseTextShowing = false;
				}
				else 
				{
					for each(var alien:Alien in _aliens.members)
					{
						alien.showVerboseTexts();
					}

					_isVerboseTextShowing = true;
				}
				
			}
			
			if (FlxG.keys.justPressed("F")) //toggle primary and secondary ammo
			{
				_ship.togglePrimarySecondaryAmmo();
				

			}

			if(FlxG.keys.ENTER && _ship.dead)
			{				
				//reset score
				FlxG.score = 0;
				FlxG.state = new PlayState();
			}
			
			_spawnTimer -= FlxG.elapsed;
			//_notificationTimer -= FlxG.elapsed;
			
			if(_spawnTimer < 0)
			{
				
				if (_spentThisRound < _budget)
				{
					spawnAlien();
					
				}
				resetSpawnTimer();
				
				//test point: have each alien with a health sensor check their health
				//_aliens.
			}
			
			//see how many aliens remain
			var displayGoalNumber:int = _aliens.countLiving();
			if (displayGoalNumber < 0)
			{
				_aliensInPlayText.text = "Aliens in Play: 0";
			}
			else
			{
				_aliensInPlayText.text = "Aliens in Play: " + displayGoalNumber.toString();
			}
			
			//see how many aliens are in the goal area
			displayGoalNumber = _aliensThatMadeGoal.countLiving();
			if (displayGoalNumber < 0)
			{
				_aliensInGoalText.text = "Aliens in Goal Area: 0";
			}
			else{
				_aliensInGoalText.text = "Aliens in Goal Area: " + displayGoalNumber.toString();
			}
			
			//update the display of number that have run out of power
			_aliensThatDiedFromLowPowerText.text = "Aliens that ran out of Power: " + _deathsFromLowPower.toString();
			

			
			//check to see if the round is over
			if (_aliens.countLiving() <=0 && _spentThisRound >= _budget && ! _roundIsOver && ! _ship.dead) //if there are no aliens left and the budget has been met or exceeded
			{
				endOfRound();
				_roundIsOver = true;
				_transitionCounter = 6;
				if (_scoreThisRound > 0)
				{
					FlxG.score += _scoreThisRound * _round;//finalize score
				}
			}
			
			if (_roundIsOver)
			{
				_transitionCounter -= FlxG.elapsed;
				
				var madeitthrough:uint;
				if ( _aliensThatMadeGoal.countLiving() < 1)
				{
					madeitthrough = 0;
				}
				else
				{
					madeitthrough = _aliensThatMadeGoal.countLiving();
				}
				
				_scoreText.text = FlxG.score.toString();
				
				var scoretodisplay:int=0;
				if (_scoreThisRound < 0)
				{
					scoretodisplay = 0;
				}
				else
				{
					scoretodisplay = _scoreThisRound;
				}
				
				
				
				if (_round + 1 == 9)
				{
					upgradesPeek = "Advanced Weapons Unlocked!!!";
				}
				else if (_round +1 == 5)
				{
					upgradesPeek = "Medium Weapons Unlocked!!";
				}
				else if (_round + 1 == 2)
				{
					upgradesPeek = "Secondary Weapons Unlocked!";
				}
				else if(hasTipBeenDisplayed==false)
				{
					var tips:Array = new Array();
					tips.push("Medium Weapons are unlocked at Level 5. Advanced Weapons are unlocked at Level 9.");
					tips.push("If you get stuck without ammo and there is an annoyingly long-lived\n Alien still alive, consider pressing 'r' to restart the Level.");
					tips.push("There is at least one spot on the screen where you can never be hit by an Alien...");
					tips.push("Each Level you get more ammo and more speed.");
					tips.push("The Matron Alien grants a budget bonus to her horde \nafter you annihilate an entire Level full of Aliens... and you take a speed penalty!");
					tips.push("Follow your heart. That's what I do.");
					tips.push("Genetic Algorithms do have weaknesses... can you exploit them?");
					tips.push("You take a bonus to your speed proportional to your score.");
					tips.push("You only live once! You have probably already figured that out, though.");
					tips.push("Take time to study the Aliens during the Evolution Status screen.\n It could help you anticipate Alien tactics.");
					tips.push("Aliens evolve their brains and thier equipment during the Evolution phase.");
					tips.push("Aliens NEVER get an upgrade to equipment or brainpower. All equipment and tactics are available for them from the very start.");
					tips.push("You will probably find that it takes the Aliens about 3-4 generations (Levels) of not being annihilated to become very strong.");
					tips.push("This game is also about YOU evolving your strategy... \nwhat worked in Level 3 might not work in Level 10!");
					tips.push("(This game actually never ends. But please imagine\n that there is a fantastic and amazing end where you save the Galaxy.)");
					tips.push("When an Alien is flashing, that means he will \nrun out of battery soon and die.");
					tips.push("The bar below the Alien is his battery indicator.");
					tips.push("The writing about the Alien is his current State.");
					tips.push("You can press 'T' to turn off the \n equipment loadout text next to the Aliens.");
					tips.push("The equipment loadout text displayed next to \nthe Alien will not make you crash if you hit it.");
					tips.push("Your primary and secondary weapons share \nthe same energy amount.  Some weapons take more energy than others.");
					tips.push("Press 'F' to toggle between firing primary and secondary ammo types.");
					tips.push("Aliens have advanced monetary technology that \nallows them to go over budget exactly once...");
					tips.push("Each Level you will get a random secondary weapon.\n This could be what you need to break the Alien's strategy.");
					tips.push("Aliens can asexually reproduce!");
					tips.push("You should play to at least Level 10 one or two times to really understand this game.");
					tips.push("It is more challenging to play with the Alien equipment loadout texts disabled. \n (It makes them harder to predict) - But you can seee them better.");
					tips.push("The Aliens' deathcry is different when you kill them than when they run out of batteries.");
					tips.push("Ever notice that the Aliens sometimes pick a really bad strategy and equipment loadout\nand just go with it? The GA....");
					tips.push("Ever notice that the Aliens sometimes pick a really crazy strategy and equipment loadout...\nand it works? The GA....");
					tips.push("Killing off the weak Aliens will make the next Level stronger...");
					upgradesPeek = " RANDOM TIP: \n" + tips[Math.floor(Math.random() * tips.length)];
					
					hasTipBeenDisplayed = true;
				}
				else
				{
					//nothing. upgradespeek should be set... right?
				}
				
				_endOfRoundText.text =  "End of Level " + _round + "! \n" + madeitthrough +" Aliens made it through! \n\nScore\nPoints this Level: "+scoretodisplay.toString()+" * "+_round+" Level multiplier!\nTotal Score: "+FlxG.score.toString()+"\n\n"+upgradesPeek+" \n\nAliens will evolve in " + Math.floor(_transitionCounter) + "s";	
				
				//check to see if counter is expired
				if (_transitionCounter <= 0)
				{
					//transition to evolution stage
					transitionToEvolveState();
				}
			}
			
			super.update();
		}
		
/*		private function notify(text:String):void
		{
			_notificationText.text = text;
			add(_notificationText);
			
			//start timer
			_notificationTimer = _notificationInterval;
		}*/
		
		//to be run when the round is over but the player is not dead
		private function endOfRound():void
		{
			//show text that the round is over.
			_endOfRoundText = new FlxText(0, FlxG.height / 2-150, FlxG.width, "End of Level. Evolution of Aliens in ");					
			_endOfRoundText.setFormat(null, 16, 0xFF597137, "center");
			add(_endOfRoundText);
			
		}
		
		private function transitionToEvolveState():void
		{
			trace("passing these survivors to the evolve state: " + _aliensThatMadeGoal.members.toString())
			FlxG.state = new EvolveState(_round, _aliensThatMadeGoal, _aliens);
		}
	
		private function spawnAlien():void
		{
			
			
			//all aliens start at random point on right side
			var x: Number = FlxG.width-100;
			var y: Number = Math.random() * (FlxG.height - 200) + 100;
			
			var noobAlien:Alien = new Alien(x, y, _PlayStateEquipmentLocker);
			//2 cases. one is that there are no aliens from the last round so a random one must be created or two there is a batch from last round
			
			//priority goes to batch from last round
			if (_spawnCache.members.length > 0) //if there is at least 1 specimen from the last round
			{
				var specimen:Alien = _spawnCache.members[Math.floor(Math.random() * _spawnCache.members.length)];
				noobAlien = specimen.clone(specimen);
				//noobAlien = specimen;
				
				//specimen.kill();
				
				//give the random position
				noobAlien.x = x;
				noobAlien.y = y;
				
				//recharge this Alien's battery
				noobAlien.rechargeBattery();
				
				//take the alien out of the goal state
				noobAlien.changeState(Math.floor(Math.random() * (6 - 1) + 1));//start at a random state
				
				noobAlien.refreshTextContent();
				
				
			}
			else
			{

				//_aliens.add(new Alien(x, y));
				
				/*
				 *    ISSUE ARMOR
				*/
				
				
				
				//issue a random pair of armor
				
				//trace("About to issue Armor:", armorForIssue.getModel());
				noobAlien.giveArmor(_PlayStateEquipmentLocker.getRandomEquipment("armor"));
				//put the armor back on the rack
				//_armorSets.push(armorForIssue);
				//trace("Closing Armory. Current contents", _armorSets.toString());
				
				/*
				 * 
				 * ISSUE A Battery
				 * 
				 */
				//randIndex = Math.floor(Math.random() * _batterySets.length);
				//issuing a battery with a shallow copy is neccissary because batteries contain a charge that can't be shared
				noobAlien.giveBattery(_PlayStateEquipmentLocker.getRandomEquipment("battery"));
				
				/*
				 * 
				 * ISSUE A Motor
				 * 
				 */
				//randIndex = Math.floor(Math.random() * _motorSets.length);
				noobAlien.giveMotor(_PlayStateEquipmentLocker.getRandomEquipment("motor"));
				
				/*
				 * 
				 * ISSUE A CPU
				 * 
				 */
				//randIndex = Math.floor(Math.random() * _CPUSets.length);
				noobAlien.giveCPU(_PlayStateEquipmentLocker.getRandomEquipment("CPU"));
				
				
				/*
				 *   ISSUE a random Health Sensor
				*/
				//randIndex = Math.floor(Math.random() * _healthSensorSets.length);
				noobAlien.giveHealthSensor(_PlayStateEquipmentLocker.getRandomEquipment("healthSensor"));
				
				/*
				 *   ISSUE a random Battery Sensor
				*/
				//randIndex = Math.floor(Math.random() * _healthSensorSets.length);
				noobAlien.giveBatterySensor(_PlayStateEquipmentLocker.getRandomEquipment("batterySensor"));
				
				/*
				 *   ISSUE a random Timer Sensor
				*/
				//randIndex = Math.floor(Math.random() * _timerSensorSets.length);
				noobAlien.giveTimerSensor(_PlayStateEquipmentLocker.getRandomEquipment("timerSensor"));
				
				/*
				 *   ISSUE a random distance long Sensor
				*/
				//randIndex = Math.floor(Math.random() * _healthSensorSets.length);
				noobAlien.giveDistanceLongSensor(_PlayStateEquipmentLocker.getRandomEquipment("distanceLongSensor"));
				
				/*
				 *   ISSUE a random distance short Sensor
				*/
				//randIndex = Math.floor(Math.random() * _healthSensorSets.length);
				noobAlien.giveDistanceShortSensor(_PlayStateEquipmentLocker.getRandomEquipment("distanceShortSensor"));
			}
			
			//set verbose text to hide if off
			if (!_isVerboseTextShowing)
			{
				noobAlien.hideVerboseTexts();
			}
			
			
			//add to group
			_aliens.add(noobAlien);
			
			//set this aliens ally group
			//noobAlien.setAlliesGroup(_aliens);
			
			_spentThisRound += noobAlien.calculateCost();
			//update budget text
			_budgetProgressText.text = "Alien budget spent: $" + _spentThisRound.toString();
			_alienBudgetLeftText.text= "Alien budget left:  $" + (_budget-_spentThisRound).toString();
			
		}	

		
		private function resetSpawnTimer():void
		{
			_spawnTimer = _spawnInterval;			
			_spawnInterval *= 0.92;
			if(_spawnInterval < 0.1)
			{
				_spawnInterval = 0.1;
			}
		}
		
/*		private function resetNotificationTimer():void
		{
			_notificationTimer = _notificationInterval;			
			//_spawnInterval *= 0.95;
			if(_spawnInterval < 0.1)
			{
				_notificationTimer = 0.1;
			}
		}*/
		
		
		
		private function overlapAlienBullet(alien: Alien, bullet: Bullet):void
		{
			
			//damage the alien
			//trace("Alien is about to be shot");
			FlxG.play(PowerDown);
			alien.beShot(bullet);
			bullet.kill();	//remove the bullet from the space
			//if the alien is dead, kill it
			if (alien.isDead())
			{
				FlxG.play(AlienScream);
				var emitter:FlxEmitter = createEmitter();
				emitter.at(alien);		
				alien.kill(); //remove alien from play
				
				FlxG.play(SoundExplosionAlien);	
				FlxG.score += 3;
				_scoreThisRound += 3;
				_scoreText.text = FlxG.score.toString();
			}
						
		}
		
		private function overlapAlienShip(alien: Alien, ship: Ship):void
		{
			var emitter:FlxEmitter = createEmitter();
			emitter.at(ship);			
			ship.kill();
			_ammoLeftText.kill(); //kill the ammo left text.
			alien.kill();
			FlxG.quake.start(0.02);
			FlxG.play(SoundExplosionShip);	
			FlxG.play(EvilLaugh);
			var leveltenreminder:String;
			if (_round < 10)
			{
				leveltenreminder ="\n\n (You REALLY need to get to Level 10 before you understand how this game works!!";
			}
			else
			{
				leveltenreminder = "";
			}
			
			_gameOverText = new FlxText(0, FlxG.height / 2, FlxG.width, "GAME OVER\n \nYour Score: " + FlxG.score.toString() + "\n\nPRESS ENTER TO PLAY AGAIN!\n\nEvery game is different!"+leveltenreminder);
			FlxG.score = 0;
			_gameOverText.setFormat(null, 16, 0xFF597137, "center");
			add(_gameOverText);
		}
				
		private function createEmitter():FlxEmitter
		{
			var emitter:FlxEmitter = new FlxEmitter();
			emitter.delay = 1;
			emitter.gravity = 0;
			emitter.maxRotation = 0;
			emitter.setXSpeed(-500, 500);
			emitter.setYSpeed(-500, 500);		
			var particles: int = 10;
			for(var i: int = 0; i < particles; i++)
			{
				var particle:FlxSprite = new FlxSprite();
				particle.createGraphic(2, 2, 0xFF597137);
				particle.exists = false;
				emitter.add(particle);
			}
			emitter.start();
			add(emitter);
			return emitter;		
		}
		

	}
}