package de.pixelate.flixelprimer
{
	import adobe.utils.CustomActions;
	import adobe.utils.ProductManager;
	import flash.globalization.NumberParseResult;
	import flash.net.registerClassAlias;
	import flash.sensors.Accelerometer;
	import mx.core.FlexTextField;
	import org.flixel.*;
	import flash.utils.getQualifiedClassName;
	
	import flash.utils.ByteArray; 


	public class Alien extends FlxSprite
	{		
		[Embed(source = "../../../../assets/png/Alien.png")] private var ImgAlien:Class;
		
		registerClassAlias("de.pixelate.flixelprimer.Alien", Alien);
		
		//equipment locker reference
		private var _equipmentLocker:EquipmentLocker;
		
		//equipment
		private var armor:AlienArmor;
		private var cpu:AlienCPU;
		private var battery:AlienBattery;
		private var motor:AlienMotor;
		
		//group of allies
		private var allies:FlxGroup;
		
		//sensors
		private var sensorsArray:Array;
		private var healthSensor:SensorHealth;
		private var batterySensor:SensorBattery;
		private var timerSensor:SensorTimer;
		private var distanceLongSensor:SensorDistanceLong;
		private var distanceShortSensor:SensorDistanceShort;
		
		//attributes
		private var innate_health:Number;
		private var current_health:Number; //this is a running status of the health. <=0 is dead
		private var base_cost:Number; //how much an unaltered alien costs
		private var fitness:Number; //used to store the relative fitness of an individual
		private var survival_time:Number; //used to keep a record of how long this was alive
		
		//states
		private var currentState:uint; //the behavior state
		private var possibleStates:Array = new Array(); //holds a list of possible states
		private var doIHavePower:Boolean = false;
		private var amIInGoal:Boolean = false;
		
		//time alive
		private var myTimer: Number = 2;
		private var myInterval: Number = 15;
		
		//environmental variables that affect movement
		private var _p:Number = 1.204 // density of fluid
		private var _Csubd:Number = 0.47 //drag coeffecient of a sphere (aka of the robot)
		
		//decision tables
		private var stateTransitionTables:Object;
		//private var stateTransitionTable:AlienStateTransitionTable;
		
		//genetic parameters
		private var _numCrossovers:uint = 3; //defines the times to crossover when mating
		private var _mutationRate:uint = 10; //number between 0 and 100 that defines how probably a mutation is at each allele
		
		//text
		private var _textGroup:FlxGroup;
		private var _armorText:FlxText;
		private var _motorText:FlxText;
		private var _batteryText:FlxText;
		private var _cpuText:FlxText;
		private var _healthSensorText:FlxText;
		private var _batterySensorText:FlxText;
		private var _distanceLongSensorText:FlxText;
		private var _distanceShortSensorText:FlxText;
		private var _timerSensorText:FlxText;
		private var _stateText:FlxText;
		private var _alienHUDGroup:FlxGroup;
		
		private var _isVerboseTextShowing:Boolean;
		
		//battery status indicator
		private var _batteryStatusText:FlxText;

		public function Alien(x: Number=0, y: Number=0, locker:EquipmentLocker=null):void
		{
			super(x, y, ImgAlien);
			velocity.x = -200;
			
			_isVerboseTextShowing = true;
			
			
			//give standard health amount
			innate_health = 1;
			current_health = innate_health;
			
			//set the equipment locker if one was passsed
			setEquipmentLocker(locker);
			
			//initialize allies
			allies = new FlxGroup;
			
			//set base cost
			base_cost = 1;
			
			//initialize fitness and suvival time
			fitness = 0;
			survival_time = 0;
			
			//give the standard list of states
			//these are the only valid states
			possibleStates.push(1, 2, 3, 4, 5, 6, 7);
			
			//make a list of possible start states
			var possibleStartStates:Array = new Array(1, 2,3, 5, 4,6);
			//make the current state a random one
			var randIndex:uint = Math.floor(Math.random() * possibleStartStates.length);
			changeState(possibleStartStates[randIndex]);
			
			//initialize sensors array, which will hold all sensors
			sensorsArray = new Array();
			
			//the stateTransitionTables array holds a table for each sensor
			//stateTransitionTable = new AlienStateTransitionTable;
			stateTransitionTables = new Object(); //this will be a multidimensional array where the index is the name of the sensor (object name, not user created string)
			
			//set up text
			this.resetTexts();
		}
		
		public function resetTexts():void
		{
				
			//add the text
			_armorText = new FlxText(this.x, this.y, 200, "");
			_armorText.setFormat(null, 8, 0xFF597137, "left");
			
			_motorText = new FlxText(this.x, this.y, 200, "");
			_motorText.setFormat(null, 8, 0xFF597137, "left");
			
			_batteryText = new FlxText(this.x, this.y, 200, "");
			_batteryText.setFormat(null, 8, 0xFF597137, "left");
			
			_cpuText = new FlxText(this.x, this.y, 200, "");
			_cpuText.setFormat(null, 8, 0xFF597137, "left");
			
			_healthSensorText = new FlxText(this.x, this.y, 200, "");
			_healthSensorText.setFormat(null, 8, 0xFF597137, "left");
			
			_batterySensorText = new FlxText(this.x, this.y, 200, "");
			_batterySensorText.setFormat(null, 8, 0xFF597137, "left");
			
			_distanceLongSensorText = new FlxText(this.x, this.y, 250, "");
			_distanceLongSensorText.setFormat(null, 8, 0xFF597137, "left");
			
			_distanceShortSensorText = new FlxText(this.x, this.y, 250, "");
			_distanceShortSensorText.setFormat(null, 8, 0xFF597137, "left");
			
			_timerSensorText = new FlxText(this.x, this.y, 200, "");
			_timerSensorText.setFormat(null, 8, 0xFF597137, "left");
			
			_batteryStatusText = new FlxText(this.x-15, this.y+25, 150, "");
			_batteryStatusText.setFormat(null, 10, 0xFF597137, "left");
			
			_stateText = new FlxText(this.x-5, this.y-50, 50, "");
			_stateText.setFormat(null, 8, 0xFF597137, "center");
			
			

			
			//add all texts to the text group
			_textGroup = new FlxGroup();
			_textGroup.add(_motorText);
			_textGroup.add(_armorText);
			_textGroup.add(_cpuText);
			_textGroup.add(_batteryText);
			_textGroup.add(_healthSensorText);
			_textGroup.add(_batterySensorText);
			_textGroup.add(_distanceLongSensorText);
			_textGroup.add(_distanceShortSensorText);
			_textGroup.add(_timerSensorText);

			//_textGroup.add(_batteryStatusText);
			//_textGroup.add(_stateText);
			
			//add the text
			FlxG.state.add(_textGroup);
			
			_alienHUDGroup = new FlxGroup();
			_alienHUDGroup.add(_batteryStatusText);
			_alienHUDGroup.add(_stateText);
			FlxG.state.add(_alienHUDGroup);

			
		}
		
		public function killTexts():void
		{
			_textGroup.kill();
			_alienHUDGroup.kill();
		}
		
		public function hideVerboseTexts():void
		{
			_textGroup.visible = false;
			_alienHUDGroup.visible = false;
			_isVerboseTextShowing = false;
			//but keep battery and state visible
		}
		
		public function showVerboseTexts():void
		{
			_textGroup.visible = true;
			_alienHUDGroup.visible = true;
			_isVerboseTextShowing = true;
		}
		
		public function toggleVerboseTexts():void
		{
			if (_isVerboseTextShowing)
			{
				hideVerboseTexts();
			}
			else
			{
				showVerboseTexts();
			}
		}
		
		public function reviveTexts():void
		{
			
			for each (var text:FlxText in _textGroup.members)
			{
				//text.alive = true;
				text.exists = true;
			}
			
			for each (text in _alienHUDGroup.members)
			{
				//text.alive = true;
				text.exists = true;
			}
			
		}
		
		public function refreshTextContent(full:Boolean=false):void
		{
		
			if (full)
			{
				_armorText.text = "Armor: " + armor.getModel();
				_motorText.text = "Motor: " + motor.getModel();
				_batteryText.text = "Battery: " + battery.getModel();
				_cpuText.text = "CPU: " + cpu.getModel();
				_healthSensorText.text = "Health Sensor: " + healthSensor.getModel();
				_batterySensorText.text = "Battery Sensor: " + batterySensor.getModel();
				_distanceLongSensorText.text = "L. Dist Sensor: " + distanceLongSensor.getModel();
				_distanceShortSensorText.text = "S. Dist Sensor: " + distanceShortSensor.getModel();
				_timerSensorText.text = "Timer Sensor: " + timerSensor.getModel();
				//_stateText.text = "State: " + this.currentState.toString();
			}
			else
			{
				_armorText.text = armor.getModel();
				_motorText.text = motor.getModel();
				_batteryText.text = battery.getModel();
				_cpuText.text =  cpu.getModel();
				_healthSensorText.text = healthSensor.getModel();
				_batterySensorText.text = batterySensor.getModel();
				_distanceLongSensorText.text =  distanceLongSensor.getModel();
				_distanceShortSensorText.text = distanceShortSensor.getModel();
				_timerSensorText.text =  timerSensor.getModel();
				//_stateText.text =  this.currentState.toString();
			}
			FlxG.state.add(_textGroup);
			FlxG.state.add(_alienHUDGroup);
						
		}
		
		override public function kill():void
		{
			killTexts();
			super.kill();
			
		}
		
		public function refreshPositionOfTexts():void
		{
			//trace("textgroup contains" + _textGroup.members.toString());
			var offset:int = -25;
			for each(var text:FlxText in _textGroup.members)
			{
				//trace("setting x to " + this.x + "and y to " + this.y);
				text.x = this.x + 38;
				text.y = this.y+offset;
				
				offset += 9;
			}
			
			//update health bar
			_batteryStatusText.x = this.x -2;
			_batteryStatusText.y = this.y + 32;
			
			//update state
			_stateText.x = this.x - 12;
			_stateText.y = this.y - 15;
		}
		
		public function setEquipmentLocker(locker:EquipmentLocker):void
		{
			_equipmentLocker = locker;
		}
		
		public function getMotor():AlienMotor
		{
			return motor;
		}
		
		public function getBattery():AlienBattery
		{
			return battery;
		}
		
		public function getCPU():AlienCPU
		{
			return cpu;
		}
		
		public function getArmor():AlienArmor
		{
			return armor;
		}
		
		//reduces the current_health by indicated amount and returns current_health value
		public function reduceCurrentHealth(pain:Number):Number
		{
			current_health -= pain;
			return current_health;
		}
		
		public function increaseCurrentHealth(aid:Number):void
		{
			current_health += aid;
		}
		
		public function getMutationRate():uint
		{
			return _mutationRate;
		}
		
		public function getNumCrossovers():uint
		{
			return _numCrossovers;
		}
		
		//function for mating. takes the given alien, uses own crossover and mutation rates and returns an array of 2 children Aliens
		public function mate(otherAlien:Alien):Array
		{
			//first create a deep copy of each alien
			//this method will make it so that this alien and the otherAlien are the children so will have to pass back the parents.
			var cloneOfMe:Alien = clone(this);
			var cloneOfYou:Alien = clone(otherAlien);
			
			trace("clone of me: " + cloneOfMe + " clone of you: " + cloneOfYou);
			
			var children:Array = [cloneOfMe, cloneOfYou];
			var parents:Array = [this, otherAlien];
			
			//create an array of each allele
			//this hsould be done funcitonally but i don't have time
			var alleles:Array = ["battery", "motor", "armor", "CPU", "healthSensor", "timerSensor", "distanceLongSensor", "distanceShortSensor", "batterySensor"];
			
			//there are two major swaps/mutations: equipment and sensors
			//hard-coded: assume that there are only 4 equpiment pieces: battery, motor, armor, cpu, in that order.
			//here are the crossover points:
			//[0] battery [1] motor [2] armor [3] cpu [4] healthSensor [5] timerSensor [6] distanceLongSensor [7] distanceShortSensor [8] batterySensor [9]
			// a crossover point @ 6 would yield a total crossover, a crossover pointi @ 0 will denote a no crossover
			//so first thing is to select a number between 0 and 4 for each crossover point
			//this will work with mutliple crossovers. setting at least 3 crossovers will allow you to isolate certain alleles, so that the only time you send the 
			//  all crossovers is not the only way to swap the timer sensor
			for (var i:uint = 0; i < getNumCrossovers(); i++)
			{
				//select random number bt 0 and 9
				var crossOverPoint:uint = Math.floor(Math.random() * 9);
				
				switch (crossOverPoint)
				{
					case 0: //no crossover
						break;
						
					case 1: //swap only batteries
						swapEquipment(cloneOfMe, cloneOfYou, "battery");
						break;
					
					case 2: //swap batteries and motors
						swapEquipment(cloneOfMe, cloneOfYou, "battery");
						swapEquipment(cloneOfMe, cloneOfYou, "motor");
						break;
						
					case 3: //swap batteries and motors and armor
						swapEquipment(cloneOfMe, cloneOfYou, "battery");
						swapEquipment(cloneOfMe, cloneOfYou, "motor");
						swapEquipment(cloneOfMe, cloneOfYou, "armor");
						break;
						
					case 4: //swap
						swapEquipment(cloneOfMe, cloneOfYou, "battery");
						swapEquipment(cloneOfMe, cloneOfYou, "motor");
						swapEquipment(cloneOfMe, cloneOfYou, "armor");
						swapEquipment(cloneOfMe, cloneOfYou, "cpu");
						break;
						
					case 5: //swap
						swapEquipment(cloneOfMe, cloneOfYou, "battery");
						swapEquipment(cloneOfMe, cloneOfYou, "motor");
						swapEquipment(cloneOfMe, cloneOfYou, "armor");
						swapEquipment(cloneOfMe, cloneOfYou, "cpu");
						swapEquipment(cloneOfMe, cloneOfYou, "healthSensor");
						break;
						
					case 6: //swap all
						swapEquipment(cloneOfMe, cloneOfYou, "battery");
						swapEquipment(cloneOfMe, cloneOfYou, "motor");
						swapEquipment(cloneOfMe, cloneOfYou, "armor");
						swapEquipment(cloneOfMe, cloneOfYou, "cpu");
						swapEquipment(cloneOfMe, cloneOfYou, "healthSensor");
						swapEquipment(cloneOfMe, cloneOfYou, "timerSensor");
						break;
						
					case 7: //swap all
						swapEquipment(cloneOfMe, cloneOfYou, "battery");
						swapEquipment(cloneOfMe, cloneOfYou, "motor");
						swapEquipment(cloneOfMe, cloneOfYou, "armor");
						swapEquipment(cloneOfMe, cloneOfYou, "cpu");
						swapEquipment(cloneOfMe, cloneOfYou, "healthSensor");
						swapEquipment(cloneOfMe, cloneOfYou, "timerSensor");
						swapEquipment(cloneOfMe, cloneOfYou, "distanceLongSensor");
						break;
						
					case 8: //swap all
						swapEquipment(cloneOfMe, cloneOfYou, "battery");
						swapEquipment(cloneOfMe, cloneOfYou, "motor");
						swapEquipment(cloneOfMe, cloneOfYou, "armor");
						swapEquipment(cloneOfMe, cloneOfYou, "cpu");
						swapEquipment(cloneOfMe, cloneOfYou, "healthSensor");
						swapEquipment(cloneOfMe, cloneOfYou, "timerSensor");
						swapEquipment(cloneOfMe, cloneOfYou, "distanceLongSensor");
						swapEquipment(cloneOfMe, cloneOfYou, "distanceShortSensor");
						break;
						
					case 8: //swap all
						swapEquipment(cloneOfMe, cloneOfYou, "battery");
						swapEquipment(cloneOfMe, cloneOfYou, "motor");
						swapEquipment(cloneOfMe, cloneOfYou, "armor");
						swapEquipment(cloneOfMe, cloneOfYou, "cpu");
						swapEquipment(cloneOfMe, cloneOfYou, "healthSensor");
						swapEquipment(cloneOfMe, cloneOfYou, "timerSensor");
						swapEquipment(cloneOfMe, cloneOfYou, "distanceLongSensor");
						swapEquipment(cloneOfMe, cloneOfYou, "distanceShortSensor");
						swapEquipment(cloneOfMe, cloneOfYou, "batteryShortSensor");
						break;
					
					default:
						trace("no crossover situations were met");
						
				}
					
			}
			
			//crossover transition tables (decision tables)
			//there should be one table for each sensor
			//all sensors are held in the sensorsArray

			for each (var sensor:* in sensorsArray)
			{
				//trace("looking at sensor: " + sensor);
				//the transition tables are indexed by the class name of the table
				//this table will hold the table for the current sensor
				trace("accessing transition tables " + cloneOfMe.getStateTransitionTables() + " at " + [getQualifiedClassName(sensor)]);
				var cloneOfMetable:AlienStateTransitionTable = cloneOfMe.getStateTransitionTables()[getQualifiedClassName(sensor)];
				var cloneOfYoutable:AlienStateTransitionTable = cloneOfYou.getStateTransitionTables()[getQualifiedClassName(sensor)];
				
				//each sensor has a transition table that has 6 records, 1 for each possible state of an Alien
				//indexs are: splice points denoted by []
				//[0] "1" [1] "2" [2] "3" [3] "4" [4] "5" [5] "6" [6]
				//
				for (var i:uint = 0; i < getNumCrossovers(); i++)
				{
					//select random number bt 1 and the length of the table
					var crossOverPoint:uint = Math.floor(Math.random() * (cloneOfMetable.getLength() - 1) +1);
					trace("sensor crossover point: " + crossOverPoint);
					
					for (var index:uint = 1; index <= crossOverPoint; index++)
					{
						swapTransitionTableRecord(cloneOfMe, cloneOfYou, getQualifiedClassName(sensor), index.toString());
					}
					
				}
			}
			
			
			//   MUTATION
			
			//the prbability that a mutation will occur at each allele is defined by the aliens mutation varaible, a number between 0 and 100 representing the percent chance of mutation
			//[0] battery [1] motor [2] armor [3] cpu [4] healthSensor [5] timerSensor [6] distanceLongSensor
			for each (var child:Alien in children)
			{
				//check each allele and termine if needing to mutate
				for each (var allele:String in alleles)
				{
					//generate random number
					//trace("assessing allele: " + allele + " for mutation");
					var mutationLuckyNumber:uint = Math.floor(Math.random() * 100); //generates a random integer between 0 and 100
					//trace("mutation lucky number is " +mutationLuckyNumber+ " mutation rate is "+child.getMutationRate());
					//if the lucky number is less than or equal to the mutation rate, then a mutation should occur
					if (mutationLuckyNumber <= child.getMutationRate())
					{
						//mutate
						//mutation is done by replacing the current equipment with a random set from the locker
						
						//the name of the allele needs to be modified for the giveArmor, etc function
						var titleCaseEquipmentName:String = allele.valueOf(); //copy allele value
						var firstLetter:String = titleCaseEquipmentName.charAt(0).toUpperCase(); //get the first letter and make uppercase
						var restWord:String = titleCaseEquipmentName.substr (1, titleCaseEquipmentName.length); //get the rest of the string
						titleCaseEquipmentName = firstLetter + restWord; //paste them together
						
						//trace("equipment locker: " + _equipmentLocker);
						var randomEquipment:*= _equipmentLocker.getRandomEquipment(allele);
						
						trace("About to give " + child + " this equipment: " + randomEquipment + " by reference: " + allele + " using the function: give" + titleCaseEquipmentName);
						
						child["give" + titleCaseEquipmentName](randomEquipment);
						trace("mutation occurred on allele " + allele);
					}

				}
				
				//check each sensor transition table position and determine if mutation is needed
				
				for each (sensor in sensorsArray)
				{
					//step through the sensor's transition table record
					for each (var record:String in child.getStateTransitionTables()[getQualifiedClassName(sensor)].getTransitionTable())
					{
						mutationLuckyNumber = Math.floor(Math.random() * 100); //find number between 0 and 10
						//trace("mutation lucky number (transition table) is " +mutationLuckyNumber+ " mutation rate is "+child.getMutationRate());
						if (mutationLuckyNumber <= child.getMutationRate())
						{
							var oldRecordValue:uint = child.getStateTransitionTables()[getQualifiedClassName(sensor)].getTransitionTable()[record];
							
							//change this to a random integer between 1 and 6 (hard coded number of states)
							var newRecordValue:uint = Math.floor(Math.random() * (6 - 1) + 1);
							
							//set the new record value
							child.getStateTransitionTables()[getQualifiedClassName(sensor)].setTransitionTableValue(newRecordValue, record);
							
							trace("just mutated a transition table value from " + oldRecordValue + " to " + newRecordValue);
						}
					}
				}
			}
			
			//return the parents since the children have been modified in place and are already handled
			return children;
			
		}
		
		//takes the aliens and swaps the indicated transition table records
		private function swapTransitionTableRecord(Alien1:Alien, Alien2:Alien, sensorName:String, transitionTableRecordIndex:String):void
		{
			trace("Swapping transition records for sensor: " + sensorName + " at index " +transitionTableRecordIndex);
			
			/*trace("checking keys in " + Alien1.getStateTransitionTables()[sensorName]);
			for (var key:String in Alien1.getStateTransitionTables()[sensorName].getTransitionTable())
			{
				trace(key);
			}
			trace("Check before: " + Alien1.getStateTransitionTables()[sensorName].getTransitionTable()[transitionTableRecordIndex] + " " +Alien2.getStateTransitionTables()[sensorName].getTransitionTable()[transitionTableRecordIndex] );
			*/
			var mine:uint;
			var yours:uint;
			
			mine = Alien1.getStateTransitionTables()[sensorName].getTransitionTable()[transitionTableRecordIndex];
			yours = Alien2.getStateTransitionTables()[sensorName].getTransitionTable()[transitionTableRecordIndex];
			
			Alien1.getStateTransitionTables()[sensorName].setTransitionTableValue([transitionTableRecordIndex], yours);
			Alien2.getStateTransitionTables()[sensorName].setTransitionTableValue([transitionTableRecordIndex], mine);
			
			//trace("Check after : " + Alien1.getStateTransitionTables()[sensorName].getTransitionTable()[transitionTableRecordIndex] + " " +Alien2.getStateTransitionTables()[sensorName].getTransitionTable()[transitionTableRecordIndex] );
			
		}
		
		//takes the given alien and swaps given equipment
		private function swapEquipment(Alien1:Alien, Alien2:Alien, whichEquipment:String):Boolean
		{
			//string key
			//"battery"
			//"motor"
			//"armor"
			//"cpu"
			
			//healthSensor
			//timerSensor
			//distanceLongSensor
			//distanceShortSensor
			//batterySensor
			
			var mine:*;
			var yours:*;
			
			trace("swapping equipment: " + whichEquipment + ".");
			//trace("Before swap: "+Alien1[whichEquipment]
			
			switch(whichEquipment)
			{
				case "battery":
					//switch batteries
					mine = Alien1.getBattery();
					yours = Alien2.getBattery();
					Alien1.giveBattery(yours);
					Alien2.giveBattery(mine);
					return true;
					break;
					
				case "motor":
					//switch motors
					mine = Alien1.getMotor();
					yours = Alien2.getMotor();
					Alien1.giveMotor(yours);
					Alien2.giveMotor(mine);
					return true;
					break;
		
				case "armor":
					//switch armor
					mine = Alien1.getArmor();
					yours = Alien2.getArmor();
					Alien1.giveArmor(yours);
					Alien2.giveArmor(mine);
					return true;
					break;
				
				case "cpu":
					//
					mine = Alien1.getCPU();
					yours = Alien2.getCPU();
					Alien1.giveCPU(yours);
					Alien2.giveCPU(mine);
					return true;
					break;
					
				case "healthSensor":
					//
					mine = Alien1.getHealthSensor();
					yours = Alien2.getHealthSensor();
					Alien1.giveHealthSensor(yours);
					Alien2.giveHealthSensor(mine);
					return true;
					break;
					
					
				case "distanceLongSensor":
					//
					mine = Alien1.getDistanceLongSensor();
					yours = Alien2.getDistanceLongSensor();
					Alien1.giveDistanceLongSensor(yours);
					Alien2.giveDistanceLongSensor(mine);
					return true;
					break;
					
				case "distanceShortSensor":
					//
					mine = Alien1.getDistanceShortSensor();
					yours = Alien2.getDistanceShortSensor();
					Alien1.giveDistanceShortSensor(yours);
					Alien2.giveDistanceShortSensor(mine);
					return true;
					break;
					
				case "timerSensor":
					//
					mine = Alien1.getTimerSensor();
					yours = Alien2.getTimerSensor();
					Alien1.giveTimerSensor(yours);
					Alien2.giveTimerSensor(mine);
					return true;
					break;
					
				case "batterySensor":
					//
					mine = Alien1.getBatterySensor();
					yours = Alien2.getBatterySensor();
					Alien1.giveBatterySensor(yours);
					Alien2.giveBatterySensor(mine);
					return true;
					break;
				
				default:
					trace("no equipment swap conditions were met");
					return false;
			}
		}
		
		//takes a bullet, applies damage, returns current health
		public function beShot(bullet:Bullet):Number
		{
			//simple: bullets do amount of damage based on their damage amount
			//trace("Alien about to be shot. Current health:", getCurrentHealth());
			var newhealth:Number = reduceCurrentHealth(bullet.getDamage());
			//trace("Alien was shot. Current health:", getCurrentHealth());
			return newhealth;
		}
				
		public function isDead():Boolean
		{
			if (getCurrentHealth() <= 0)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function getCurrentHealth():Number
		{
			//calcuate 
			return current_health;
		}
		
		private function addTransitionTable(newObj:Object):void
		{
			trace("about to issue transition table on " + getQualifiedClassName(newObj));
			stateTransitionTables[getQualifiedClassName(newObj)] = new AlienStateTransitionTable();
			
/*			trace("just added a transition table. checking keys:");
			for (var key:String in this.getStateTransitionTables())
			{
				trace(key + this.getStateTransitionTables()[key] );
				for (var key2:String in this.getStateTransitionTables()[key])
				{
					trace(key2);
				}
			}*/
			
			//var tabletest:AlienStateTransitionTable = new AlienStateTransitionTable();
			//trace ("table test ", tabletest, "2:: ", tabletest.getIndexList(), "value at 2: ", tabletest.getStateChange(2));
			//trace("state transition table modified. Added ", newObj, "value is ", stateTransitionTables[newObj], "whole table ", stateTransitionTables.toString());
		}
		
		public function setStateTransitionTables(newTable:Object):void
		{
			stateTransitionTables = newTable;
		}
		
		public function getStateTransitionTables():Object
		{
			return stateTransitionTables;
		}
		
		//used to issue this alien a new health sensor
		public function giveHealthSensor(newHealthSensor:SensorHealth):void
		{
			//make an easy reference.
			healthSensor = newHealthSensor;
			
			//add sensor to sensors array
			sensorsArray.push(newHealthSensor);
			
			//any time you adda  sensor you should add a transition table to the alien so he knows how to react when he gets readings from sensors
			addTransitionTable(newHealthSensor);
			
			//trace("Added transition table for Health Sensor. Testing table at state 2: ", stateTransitionTables[getQualifiedClassName(newHealthSensor)].getStateChange(2));
			
			//trace("Health Sensor Issued:", healthSensor.getModel() , "Actual Current Health", getCurrentHealth(), "Measured Current Health", healthSensor.detectHealthLevel(getCurrentHealth()));
		
			_healthSensorText.text = "" + healthSensor.getModel();
				
			
		}
		
		public function giveBatterySensor(newBatterySensor:SensorBattery):void
		{
			//make an easy reference.
			batterySensor = newBatterySensor;
			
			//add sensor to sensors array
			sensorsArray.push(newBatterySensor);
			
			//any time you adda  sensor you should add a transition table to the alien so he knows how to react when he gets readings from sensors
			addTransitionTable(newBatterySensor);
			
			_batterySensorText.text = "" + batterySensor.getModel();
				
			
		}
		
				//used to issue this alien a new health sensor
		public function giveDistanceLongSensor(newDistanceLongSensor:SensorDistanceLong):void
		{
			//make an easy reference.
			distanceLongSensor = newDistanceLongSensor;
			
			//add sensor to sensors array
			sensorsArray.push(newDistanceLongSensor);
			
			//any time you adda  sensor you should add a transition table to the alien so he knows how to react when he gets readings from sensors
			addTransitionTable(newDistanceLongSensor);
			
			//trace("Added transition table for Health Sensor. Testing table at state 2: ", stateTransitionTables[getQualifiedClassName(newHealthSensor)].getStateChange(2));
			
			//trace("Health Sensor Issued:", healthSensor.getModel() , "Actual Current Health", getCurrentHealth(), "Measured Current Health", healthSensor.detectHealthLevel(getCurrentHealth()));
		
			_distanceLongSensorText.text = "" + distanceLongSensor.getModel();
			
			
			}
		
		public function giveDistanceShortSensor(newDistanceShortSensor:SensorDistanceShort):void
		{
			//make an easy reference.
			distanceShortSensor = newDistanceShortSensor;
			
			//add sensor to sensors array
			sensorsArray.push(newDistanceShortSensor);
			
			//any time you adda  sensor you should add a transition table to the alien so he knows how to react when he gets readings from sensors
			addTransitionTable(newDistanceShortSensor);
			
			//trace("Added transition table for Health Sensor. Testing table at state 2: ", stateTransitionTables[getQualifiedClassName(newHealthSensor)].getStateChange(2));
			
			//trace("Health Sensor Issued:", healthSensor.getModel() , "Actual Current Health", getCurrentHealth(), "Measured Current Health", healthSensor.detectHealthLevel(getCurrentHealth()));

			_distanceShortSensorText.text = "" + distanceShortSensor.getModel();
			
			}
		
		//used to issue this alien a new random timer sensor
		public function giveTimerSensor(newTimerSensor:SensorTimer):void
		{
			//make an easy reference.
			timerSensor = newTimerSensor;
			
			//add sensor to sensors array
			sensorsArray.push(timerSensor);
			
			//any time you adda  sensor you should add a transition table to the alien so he knows how to react when he gets readings from sensors
			addTransitionTable(timerSensor);
			
			//trace("Added transition table for Timer Sensor. Testing table at state 2: ", stateTransitionTables[getQualifiedClassName(timerSensor)].getStateChange(2));
			
			//trace("Timer Sensor Issued: ", timerSensor.getModel() , " Time left: ", timerSensor.getCurrentTime());

			_timerSensorText.text = "" + timerSensor.getModel();
			
		}
		
		/*
		 * 
		 * Give Equipment
		 * 
		 */
		
		//used to issue this alien a new battery
		public function giveBattery(newBattery:AlienBattery):void
		{
			battery = shallowCopyBattery(newBattery);
			//trace("Battery Issued:", battery.getModel() , "Actual Current Battery charge: ", battery.getChargeLevel());
			//if the battery has a charge left, update my battery state
			if (battery.getChargeLevel() > 0)
			{
				setPowerState(true);
			}
			else
			{
				setPowerState(false);
			}
			_batteryText.text = "" + battery.getModel();
		}
		
		//used to issue this alien a new CPU
		public function giveCPU(newCPU:AlienCPU):void
		{
			cpu = newCPU;
			myInterval = cpu.getClockSpeed();//set the increment to equal the cpu clock speed
			//trace("CPU Issued:", cpu.getModel(), "Current clock speed ", cpu.getClockSpeed(), "Current Interval ", myInterval);
			
			_cpuText.text = "" + cpu.getModel();
		}
		
		//used to issue this alien a new set of armor
		public function giveArmor(newArmor:AlienArmor):void
		{
			armor = newArmor;
			increaseCurrentHealth(armor.getProtection()); //add amount of protection to health
			//trace("Armor Issued:", armor.getModel(), "Current Health", getCurrentHealth());
			_armorText.text = "" + armor.getModel();
			
		}
		
		//used to issue this alien a new motor
		public function giveMotor(newMotor:AlienMotor):void
		{
			motor = newMotor;
			//trace("Motor Issued:", motor.getModel(), "Current Motor Force", motor.getForce());
			_motorText.text = "" + motor.getModel();
			
		}
		
		
		//used to calculate top speed
		public function calculateTopSpeed():Number
		{
			//
			//      Determine the velocity based on the motor and other factors.
			//
			//speed = friction * sqrt((2*robotmass*(force/mass))/(p*Area*Csubd))
			// since we won't simulate acceleration, we will remove the "robotmass" variable, leaving the "mass" variable. Otherwise they would cancel.  This allows mass to affect
			//     top speed since it can't affect acceleration.
			// new speed:
			//speed = friction * sqrt((2*force)/(mass*p*Area*Csubd))
			// friction is a property of a motor object because friction will be a function of the type of motor. This allows motors to simulate traveling by air, wheels, treds, etc
			// force is the output of the motor
			// mass is the total mass of the robot/alien
			// p is the density of the fluid. air is density=1.204 @ 20deg C
			// Csubd is the drag coeff. for a sphere, this is 0.47. All robots are spherical for this sim.
			// Area is the projected area of the robot. This is a factor of armor (bulk)
			
			//trace("calculating top speed with these values: ", "friction ", motor.getFriction()  , "force ",  motor.getForce() , "mass ",  this.getMass() , "p ", _p  , "csub " , _Csubd, "area ");//, this.getArea());
			return motor.getFriction() * Math.sqrt((2 * motor.getForce()) / (this.getMass() * _p * this.getArea() * _Csubd));
			//return motor.getFriction() * Math.sqrt((2 * motor.getForce()) / (3.0 * _p * this.getArea() * _Csubd));
		}
		
		//calculates total mass of the robot/Alien
		public function getMass():Number
		{
			//return battery.getMass() + motor.getMass() + armor.getMass() + cpu.getMass() + healthSensor.getMass();
			
			// for some reason battery.getMass() returns some error so we will negate battery mass for now
			//also need to add cpu mass.
			var returnthis:Number = motor.getMass() + armor.getMass() + healthSensor.getMass() + cpu.getMass() + distanceLongSensor.getMass() + distanceShortSensor.getMass() + batterySensor.getMass();//
			//trace("returning Mass: ", returnthis);
			return returnthis;
		}
		
		//calculates the area of the robot/Alien
		public function getArea():Number
		{
			return armor.getArea();
		}
		
		//count the cost of all parts of the robot
		public function calculateCost():Number
		{
			return base_cost + battery.getCost() + motor.getCost() + armor.getCost() +cpu.getCost();
		}
		
		//changes the state. returns true if successful
		public function changeState(newState:uint):Boolean
		{
			//check to see if the new state is a possible state.
			if (possibleStates.indexOf(newState) != -1)
			{
				currentState = newState;
				//trace("Change state success. Changed to state ", newState);
				return true;
			}
			else
			{
				//trace("Change state failed. Tried to change to state ", newState);
				return false;
			}
			 
		}
		
		private function runState():void
		{
			//trace("Running state: ", currentState);
			var topspeed:Number = this.calculateTopSpeed();
			//trace("Top speed calculated: ", topspeed);
			//assign this top speed to the robot. check for direction.
			if (velocity.x < 0)
			{
				velocity.x = -1 * topspeed;
			}
			else
			{
				velocity.x = topspeed;
			}
			
			//check same for y value
			if (velocity.y < 0)
			{
				velocity.y = -1 * topspeed;
			}
			else
			{
				velocity.y = topspeed;
			}
			
			//run state causes energy usage if the state is not stopped
			//also, goal state does not cause energy usage
/*			if (currentState != 1 && currentState != 7)
			{
				//all states other than 1 take same battery amount
				//use some battery power
				battery.useBattery(motor.getECost());
			}*/
			
			//for simplicity, both x and y values will be assigned with the magnitude determined by topspeed
			switch (currentState)
			{
				case 1: //stop
					_stateText.text = "Stop";
					velocity.y = 0;
					velocity.x = 0;
					break;
					
				case 2: //straight line towards goal
					_stateText.text = "Straight";
					velocity.y = 0;
					if (velocity.x > 0)
					{
						velocity.x = -1 * velocity.x;
					}
					battery.useBattery(motor.getECost());
					break;
					
				case 3: //Dodge
					_stateText.text = "Dodge";
					//give an up component
					if (velocity.y > 0)
					{
						velocity.y = -1 * velocity.y;
					}
					else if (velocity.y == 0)
					{
						velocity.y = -1 * topspeed;
					}
					battery.useBattery(motor.getECost());
					break;
					
				case 4: //retreat
					_stateText.text = "Retreat";
					if (velocity.x < 0)
					{
						velocity.x = -1*velocity.x;
					}
					battery.useBattery(motor.getECost());
					break;
					
				case 5: //sprint to goal
					_stateText.text = "Sprint";
					
					//sprint goes 1.75x as fast but uess 3x energy
					if (velocity.y == 0 && velocity.x == 0)
					{
						velocity.x = -1* topspeed * 1.5;
					}
					else
					{
						//just add to current x direction
						velocity.x = -1 * 1.5 * topspeed;
						//velocity.y = 1.5 * velocity.y;
					}
					
					
					
					//old code from trying to follow
					/*var nearest:Alien = findNearestAlly();
					if (nearest != null) //if there was actually an ally close and further to the left
					{
						trace("starting to follow ally with x " + nearest.x + " my x " + this.x);
						//find out the side lengths and angle
						var Adjacent:Number =  nearest.x - this.x;
						var Opposite:Number =  nearest.y - this.y;
						var theta:Number = Math.atan(Opposite / Adjacent);
						
						//find out your own speed 
						var Hypotenuse:Number = this.calculateTopSpeed();
						
						//set your new speeds
						this.velocity.y = Math.floor(Hypotenuse * Math.cos(theta)); //new x speed
						this.velocity.x = Math.floor(Hypotenuse * Math.sin(theta)); //new y speed
						trace("my new speeds are y" + this.velocity.y +" and x: " + this.velocity.x);
					}
					else //there are no options to follow
					{
						_stateText.text = "Can't follow";
						trace("can't follow");
						//just go left.
						velocity.y = 0;
						if (velocity.x > 0)
						{
							velocity.x = -1 * velocity.x;
						}
					}*/
					battery.useBattery(motor.getECost()*3); //sprint uses 3x as much energy
					break;
					
				case 6: //juke
					_stateText.text = "Juke";
					velocity.y = Math.cos(this.x / 50) * 150;
					//if (velocity.x > 0)
					//{
						velocity.x = -1 * topspeed;
					//}
					battery.useBattery(motor.getECost());
					break;
					
				case 7: //in goal zone
					_stateText.text = "";
					setGoalState(true);
					velocity.y = 0;
					velocity.x = 0;
					break;
					
				default: //straight line
					_stateText.text = "?";
					trace("found no state algorithm for state ", currentState);
					velocity.y;
			}
		}

		public function setAlliesGroup(group:FlxGroup):void
		{
			allies = group;
		}
		
		//returns the nearest Alien
		public function findNearestAlly():Alien
		{
			var closestDistance:Number = 10000000000; //some huge and impossible number
			var closestAlly:Alien;
			trace("looking for closest ally...");
			for each(var ally:Alien in allies.members)
			{
				trace("is this ally dead? " + ally.isDead());
				//don't assess yourself or dead aliens
				if (ally != this && !ally.isDead())
				{
					//find distance by triangle hypotenuse
					var distance:Number = Math.sqrt(ally.x * ally.x + ally.y * ally.y);
					
					if (distance < closestDistance) //this is the closest one so far and it is more to the left (not behind him)
					{
						trace("found a closer ally that is this far "+distance+" ally x "+ally.x+" my x "+this.x);
						closestDistance = distance;
						closestAlly = ally;
					}
					else
					{
						trace("not closest: ally x " + ally.x + " my x " + this.x+ " distance is "+distance + " and closest distance is "+closestDistance);
					}
				}
				else
				{
					trace("Skipping me or a dead ally...");
				}
				
			}
			if (closestAlly != null)
			{
				trace("I am going to follow this ally " + closestAlly.x + " my x " + this.x);
			}
			else
			{
				trace("no ally found, returning null");
			}
			return closestAlly;
		}
		
		//set the power state and return the state of the power state
		private function setPowerState(state:Boolean):Boolean
		{
			doIHavePower = state;
			return doIHavePower;
		}
		
		public function getPowerState():Boolean
		{
			return doIHavePower;
		}
		
		public function getBatteryLevel():Number
		{
			return battery.getChargeLevel();
		}
		
		//set the goal state
		public function setGoalState(state:Boolean):Boolean
		{
			amIInGoal = state;
			return amIInGoal;
		}
		
		public function getGoalState():Boolean
		{
			return amIInGoal;
		}
		
		override public function update():void
		{			
	    	//velocity.y = Math.cos(x / 50) * 50;
			//increment my cpu timer
			myTimer -= FlxG.elapsed;
			
			//increment my survival timer
			//survival_time += FlxG.elapsed;
			//update text position
			
			if (x < 5)
			{
				trace("ERROR! I am to the left of the goal area! state: "+currentState);
			}
			
			
			//if the battery is low, start to flicker
			//we say battery is 20% or less
			if (battery.getChargeLevel() <= 0.20*battery.getCapacity())
			{
				this.flicker(0.2); //flicker for 0.2 second.
			}
				
				
			//top priority is the goal state.
			if (this.getGoalState())
			{
				this.changeState(7);
			}
			else
				{
				//if the battery is dead, he must stop
				if (battery.getChargeLevel() <= 0)
				{
					trace("my battery is dead! Charge level is "+battery.getChargeLevel());
					changeState(1);
					//change attribute to out of power
					setPowerState(false);
					
				}
				else
				{
					//the random timer sensor requires energy each update
					
					if(myTimer < 0) //if the timer is up then it is time to run a CPU cycle
					{
						trace("Running a CPU Cycle...");
						updateState();
						resetMyTimer();
						
						//test point: have each alien with a health sensor check their health
						//_aliens.
					}
				}
			}
			
			//add text
			//update battery status
			_batteryStatusText.text = "";
			//trace("there should be " + Math.ceil(this.battery.getCapacity() / 5) + " battery bars for a charge level of "+this.getBatteryLevel());
			var batteryIncrement:Number = Math.ceil(this.battery.getCapacity() / 6);
			for (var i:Number = batteryIncrement; i < this.getBatteryLevel(); i+=batteryIncrement)
			{
				//trace("adding bar " + i);
				_batteryStatusText.text += "-";
			}
			

			//FlxG.state.add(_textGroup);
			refreshPositionOfTexts();
			//FlxG.state.add(_textGroup);
			
			
			runState();
			super.update();		
			
			//keep from going off screen by reversing their current up down speed
			if(y > FlxG.height-height-55)
			{
				y = FlxG.height-height-55;
				velocity.y = -1 * velocity.y;
			}
			else if(y < 55)
			{
				y = 55;		
				velocity.y = -1 * velocity.y;
			}	
			
			//keep from running away
			if(x > FlxG.width-width-16)
			{
				x = FlxG.width-width-16;
			}
			
			//keep from going so far into the goal
			if (x < 6 )
			{
				velocity.x = 0;
				velocity.y = 0;
				x = 6;
				trace("ERROR! I am to the left of the goal area! state: "+currentState+"location update: " + x + " " + y);
				
			}
			
/*			if (isNaN(y)|| isNaN(x))
			{
				velocity.x = 0;
				velocity.y = 0;
				y = 65;
				x = 10;
				trace("ERROR! I am to the above somewhere of the goal area! state: " + currentState + "location update: " + x + " " + y);
				this.kill();
			}*/
			
			
			//trace("location update: " + x + " " + y+ " state: "+currentState);
			
			refreshPositionOfTexts();

		}	
		
		//runs sensor scans and compares sensor data to state table to determine if state change is required. returns new state
		private function updateState():uint
		{
			var stateTrigger:Boolean = false;// will keep track if a sensor is tripped
			var nextState:uint = 0;
			//trace("crated nextstate. value is ", nextState);
			
			//inputs / sensor data
			/*var isHealthLow:Boolean = false;
			var isBulletInbound:Boolean = false;
			var isGoalFarAway:Boolean = false;
			var isGoalClose:Boolean = false;
			var isRandomTimerExpired:Boolean = false;
			var isBatteryLow:Boolean = false;*/
			
			//update random timer
			useTimerSensor(myInterval);
			
			// check timer
			if (timerSensor.isTimeUp())
			{
				//isRandomTimerExpired = true;
				
				//query the decision table for new state
				nextState = getNextState(timerSensor, currentState);
				stateTrigger = true;
			}
			
			//check long distance. see if we are far away
			if (useDistanceLongSensor())// if currently percieved health is less that 2
			{
				//isHealthLow = true;

				trace("distance percieved to be long. I am changing my state. ");
				
				//query the decision table for new state
				nextState = getNextState(distanceLongSensor, currentState); // stateTransitionTables[getQualifiedClassName(healthSensor)].getStateChange(currentState);
				trace("based on a current state of ", currentState, " I will attempt to change to state ", nextState);
				//nextState = 4; //retreat
				stateTrigger = true;
			}
			
			//check battery
			if (useBatterySensor() < 0.20*battery.getCapacity())// if currently percieved battery is less than 20% of capacity
			{
				//isHealthLow = true;

				trace("battery is low. I am changing my state. (actual battery: ", getBatteryLevel(), ")");
				
				//query the decision table for new state
				nextState = getNextState(batterySensor, currentState); // stateTransitionTables[getQualifiedClassName(healthSensor)].getStateChange(currentState);
				trace("based on a current state of ", currentState, " I will attempt to change to state ", nextState);
				//nextState = 4; //retreat
				stateTrigger = true;
			}
			
			//check long distance. see if we are far away
			if (useDistanceShortSensor())// if currently percieved health is less that 2
			{
				//isHealthLow = true;

				trace("distance percieved to be long. I am changing my state. ");
				
				//query the decision table for new state
				nextState = getNextState(distanceShortSensor, currentState); // stateTransitionTables[getQualifiedClassName(healthSensor)].getStateChange(currentState);
				trace("based on a current state of ", currentState, " I will attempt to change to state ", nextState);
				//nextState = 4; //retreat
				stateTrigger = true;
			}
			
			//check health
			if (useHealthSensor() < 2)// if currently percieved health is less that 2
			{
				//isHealthLow = true;

				trace("health is low. I am changing my state. (actual health: ", getCurrentHealth(), ")");
				
				//query the decision table for new state
				nextState = getNextState(healthSensor, currentState); // stateTransitionTables[getQualifiedClassName(healthSensor)].getStateChange(currentState);
				trace("based on a current state of ", currentState, " I will attempt to change to state ", nextState);
				//nextState = 4; //retreat
				stateTrigger = true;
			}
			
			if (stateTrigger)//if there is a reason to possibly change states
			{
				//trace("rogue change state. about to attempt state of ", nextState);
				changeState(nextState);
			}

			return nextState;
		}
		
		//used to interface with the transition table. given a sensor and a state, it will tell you what the decision for that sensor at that state is
		private function getNextState(sensorObject:Object, state:uint):uint
		{
			return stateTransitionTables[getQualifiedClassName(sensorObject)].getStateChange(state);
		}

		
		private function useHealthSensor():Number
		{
			//check for battery power
			if (battery.getChargeLevel() <= 0)
			{
				return NaN; //return false if no battery left
			}
			else
			{
				//use some battery power
				battery.useBattery(healthSensor.getECost());
				//return the health sensor data
				return healthSensor.detectHealthLevel(getCurrentHealth());
			}
		}
		
		private function useBatterySensor():Number
		{
			//check for battery power
			if (battery.getChargeLevel() <= 0)
			{
				return NaN; //return false if no battery left
			}
			else
			{
				//use some battery power
				battery.useBattery(batterySensor.getECost());
				//return the health sensor data
				return batterySensor.detectBatteryLevel(battery.getChargeLevel());
			}
		}		
		
		private function useDistanceLongSensor():Boolean
		{
			//check for battery power
			if (battery.getChargeLevel() <= 0)
			{
				return false; //return false if no battery left
			}
			else
			{
				//use some battery power
				battery.useBattery(distanceLongSensor.getECost());
				//return the health sensor data
				return distanceLongSensor.detectDistanceLong(getCurrentDistanceToGoal(), FlxG.width);
			}
		}
		
		private function useDistanceShortSensor():Boolean
		{
			//check for battery power
			if (battery.getChargeLevel() <= 0)
			{
				return false; //return false if no battery left
			}
			else
			{
				//use some battery power
				battery.useBattery(distanceShortSensor.getECost());
				//return the health sensor data
				return distanceShortSensor.detectDistanceShort(getCurrentDistanceToGoal(), FlxG.width);
			}
		}
		
		public function getCurrentDistanceToGoal():Number
		{
			return this.x; //distance to goal is just the x value of our position.
		}
		
		//the timer sensor is designed to be called every updateState. it takes constant energy to track the time, but no energy to call
		//the function that checks for time expired
		private function useTimerSensor(elapsed:Number):void
		{
			//check for battery power
			if (battery.getChargeLevel() > 0)
			{
				trace("Using my b sensor");
				
				//use some battery power
				battery.useBattery(timerSensor.getECost());
				
				//update the time elapsed on the sensor, which will be the CPU clock speed as hard coded in this
				timerSensor.tickTheTimer(elapsed);
			}
		}
		
		private function resetMyTimer():void
		{
			myTimer = myInterval;			
		}
		
		public function getHealthSensor():SensorHealth
		{
			return healthSensor;
		}
		
		public function getBatterySensor():SensorBattery
		{
			return batterySensor;
		}
		
		public function getDistanceLongSensor():SensorDistanceLong
		{
			return distanceLongSensor;
		}
		
		public function getDistanceShortSensor():SensorDistanceShort
		{
			return distanceShortSensor;
		}
		
		public function getTimerSensor():SensorTimer
		{
			return timerSensor;
		}
		
		public function getEquipmentLocker():EquipmentLocker
		{
			return _equipmentLocker;
		}
		
		//this function allows a deep copy of an array/object
		public function clone(source:Alien):Alien
		{ 
			var newAlien:Alien = new Alien();
			
			//give equipment
			newAlien.giveArmor(source.getArmor());
			newAlien.giveCPU(source.getCPU());
			newAlien.giveMotor(source.getMotor());
			newAlien.giveBattery(source.getBattery());
			
			//give sensors
			newAlien.giveHealthSensor(source.getHealthSensor());
			newAlien.giveBatterySensor(source.getBatterySensor());
			newAlien.giveTimerSensor(source.getTimerSensor());
			newAlien.giveDistanceLongSensor(source.getDistanceLongSensor());
			newAlien.giveDistanceShortSensor(source.getDistanceShortSensor());
			
			//give equipment locker
			newAlien.setEquipmentLocker(source.getEquipmentLocker());
			
			//give transition tables
			newAlien.setStateTransitionTables(source.getStateTransitionTables());
			
			//reset text
			newAlien.resetTexts();
			
			return(newAlien); 
		}
		
		//calculates fitness and updates fitness value
		public function computeFitness():void
		{
			//fitness = (health_remaining/$cost) = (alien.current_health/aline.calculateCost())
			if (calculateCost() > 0)
			{
				fitness = current_health / calculateCost();
			}
			else
			{
				fitness = current_health;
			}
		}
		
		public function getFitness():Number
		{
			return fitness;
		}
		
		private function shallowCopyBattery(sourceObj:AlienBattery):AlienBattery
		{
		  var copyObj:AlienBattery = new AlienBattery();
/*		  for (var i in sourceObj) {
			 trace(i + " is " + sourceObj[i]);
			copyObj[i] = sourceObj[i];
		  }*/
		  
		  copyObj.setModel(sourceObj.getModel());
		  copyObj.setMass(sourceObj.getMass());
		  copyObj.setCapacity(sourceObj.getCapacity());
		  copyObj.rechargeBattery();
		  copyObj.setCost(sourceObj.getCost());
		  
/*		  trace("just made a copy of a battery. checking each parameter");
		  for (var a:String in copyObj)
		  {
			  trace(a + " is " + copyObj[a]);
		  }*/
		  
		  return copyObj;
		}
		
		public function rechargeBattery():void
		{
			battery.rechargeBattery();
			trace("battery recharged. battery level now at " + battery.getChargeLevel());
		}
	}
}