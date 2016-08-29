package de.pixelate.flixelprimer 
{
	/**
	 * This class serves as a repository for all Alien equipment and sensors. Interfacing allows you to draw equipment for issue
	 * @author ...
	 */
	public class EquipmentLocker 
	{
		
				//sets
		private var _armorSets:Array = new Array(); //armor sets. holds all sets of armor possible for use by aliens
		private var _distanceLongSensorSets:Array = new Array(); //health sensor sets
		private var _distanceShortSensorSets:Array = new Array(); //health sensor sets
		private var _healthSensorSets:Array = new Array(); //health sensor sets
		private var _batterySensorSets:Array = new Array(); //health sensor sets
		private var _timerSensorSets:Array = new Array(); //timer sensor sets
		private var _batterySets:Array = new Array(); //available batteries
		private var _motorSets:Array = new Array(); //available motors
		private var _CPUSets:Array = new Array(); //available CPUs
		
		public function EquipmentLocker() 
		{
			
			
			//create initial batch of armor
			createInitialArmorSets();
			
			//create a batch of health sensors
			createInitialHealthSensorSets();
			
			//battery sensors
			createInitialBatterySensorSets();
			
			//create a batch of distance long sensors
			createInitialDistanceLongSensorSets();
			
			//create a batch of distance short sensors
			createInitialDistanceShortSensorSets();
			
			//create a batch of timer sensors
			createInitialTimerSensorSets();
			
			//create a batch of batteries
			createInitialBatterySets();
			
			//create a batch of motors
			createInitialMotorSets();
			
			//create a batch of CPUs
			createInitialCPUSets();
		}
		
		private function createInitialHealthSensorSets():void
		{
			//inst_model:String, inst_mass: Number, inst_eCost:Number, inst_$:Number, inst_accuracy:Number=0.5, inst_precision:Number=0.9
			//_healthSensorSets.push(new SensorHealth("No Health Sensor", 0.00 , 0, 0, 10, 0.01));
			_healthSensorSets.push(new SensorHealth("Mk0 Health S.", 0.04 , .1, 0.5, 1, 0.45));
			_healthSensorSets.push(new SensorHealth("Mk1 Health S.", 0.06, .15, 1, 0.7, 0.55));
			_healthSensorSets.push(new SensorHealth("Mk1.5 Health S.", 0.05, .15, 2, 0.7, 0.65));
			_healthSensorSets.push(new SensorHealth("Mk2 Health S.", 0.07, .17, 2.5, 0.5, 0.75));
			_healthSensorSets.push(new SensorHealth("Mk3 Health S.", 0.07, .17, 3, 0.4, 0.85));
			_healthSensorSets.push(new SensorHealth("Mk4 Health S.", 0.08, .20, 3, 0.25, 0.9));
			_healthSensorSets.push(new SensorHealth("Overpriced Health S.",  0.07, .17, 25, 0.5, 0.75));
			_healthSensorSets.push(new SensorHealth("None", 0.1, .01, 1, 0.99, 0.01));
			trace("Created health sensor sets: ", _healthSensorSets.toString());
		}
		
		private function createInitialBatterySensorSets():void
		{
			//inst_model:String, inst_mass: Number, inst_eCost:Number, inst_$:Number, inst_accuracy:Number=0.5, inst_precision:Number=0.9
			//_batterySensorSets.push(new SensorBattery("No Battery Sensor", 0.00 , 0, 0, 10, 0.01));
			_batterySensorSets.push(new SensorBattery("Mk0 Battery S.", 0.5 , 1, 0.5, 1, 0.45));
			_batterySensorSets.push(new SensorBattery("Mk1 Battery  S.", 0.6, 1.5, 1, 0.7, 0.55));
			_batterySensorSets.push(new SensorBattery("Mk1.5 Battery  S.", 0.5, 1.5, 2, 0.7, 0.65));
			_batterySensorSets.push(new SensorBattery("Mk2 Battery  S.", 0.7, 1.7, 2.5, 0.5, 0.75));
			_batterySensorSets.push(new SensorBattery("Mk3 Battery  S.", 0.7, 1.7, 3, 0.4, 0.85));
			_batterySensorSets.push(new SensorBattery("Mk4 Battery  S.", 0.8, 2.0, 3, 0.25, 0.9));
			_batterySensorSets.push(new SensorBattery("None", 0.1, .01, 1, 0.99, 0.01));
			trace("Created battery sensor sets: ", _batterySensorSets.toString());
		}
		
		private function createInitialDistanceLongSensorSets():void
		{
			//inst_model:String, inst_mass: Number, inst_eCost:Number, inst_$:Number, inst_accuracy:Number=0.5, inst_precision:Number=0.9
			//_distanceLongSensorSets.push(new SensorDistanceLong("No Long Distance Sensor", 0.00 , 0, 0, 10, 0.01));
			_distanceLongSensorSets.push(new SensorDistanceLong("Mk0 Long Distance S.", 0.5 , 1, 0.5, 1, 0.45));
			_distanceLongSensorSets.push(new SensorDistanceLong("Mk1 Long Distance S.", 0.6, 1.5, 1, 0.7, 0.55));
			_distanceLongSensorSets.push(new SensorDistanceLong("Mk1.5 Long Distance S.", 0.5, 1.5, 2, 0.7, 0.65));
			_distanceLongSensorSets.push(new SensorDistanceLong("Mk2 Long Distance S.", 0.7, 1.7, 2.5, 0.5, 0.75));
			_distanceLongSensorSets.push(new SensorDistanceLong("Mk3 Long Distance S.", 0.7, 1.7, 3, 0.4, 0.85));
			_distanceLongSensorSets.push(new SensorDistanceLong("Mk4 Long Distance S.", 0.8, 2.0, 3, 0.25, 0.9));
			_distanceLongSensorSets.push(new SensorDistanceLong("None", 0.1, .01, 1, 0.99, 0.01));
			trace("Created long distance sensor sets: ", _distanceLongSensorSets.toString());
		}
		
		private function createInitialDistanceShortSensorSets():void
		{
			//inst_model:String, inst_mass: Number, inst_eCost:Number, inst_$:Number, inst_accuracy:Number=0.5, inst_precision:Number=0.9
			//_distanceShortSensorSets.push(new SensorDistanceShort("No Short Distance Sensor",0.00 , 0, 0, 10, 0.01));
			_distanceShortSensorSets.push(new SensorDistanceShort("Mk0 Short Distance S.", 0.5 , 1, 0.5, 1, 0.45));
			_distanceShortSensorSets.push(new SensorDistanceShort("Mk1 Short Distance S.", 0.6, 1.5, 1, 0.7, 0.55));
			_distanceShortSensorSets.push(new SensorDistanceShort("Mk1.5 Short Distance S.", 0.5, 1.5, 2, 0.7, 0.65));
			_distanceShortSensorSets.push(new SensorDistanceShort("Mk2 Short Distance S.", 0.7, 1.7, 2.5, 0.5, 0.75));
			_distanceShortSensorSets.push(new SensorDistanceShort("Mk3 Short Distance S.", 0.7, 1.7, 3, 0.4, 0.85));
			_distanceShortSensorSets.push(new SensorDistanceShort("Mk4 Short Distance S.", 0.8, 2.0, 3, 0.25, 0.9));
			_distanceShortSensorSets.push(new SensorDistanceShort("None", 0.1, .01, 1, 0.99, 0.01));
			trace("Created short distance sensor sets: ", _distanceShortSensorSets.toString());
		}
		
		private function createInitialTimerSensorSets():void
		{
			//inst_model:String, inst_mass: Number, inst_eCost:Number, inst_$:Number, inst_accuracy:Number=0.5, inst_precision:Number=0.9
			//_timerSensorSets.push(new SensorTimer("No Timer Sensor", 0.0 , 10.0, 0.05));
			_timerSensorSets.push(new SensorTimer("Mk0 Timer", 0.2 , 0.5, 0.5));
			_timerSensorSets.push(new SensorTimer("Mk1 Timer", 0.1, 0.4, 1));
			_timerSensorSets.push(new SensorTimer("Mk1.5 Timer", 0.05, 0.3, 2));
			_timerSensorSets.push(new SensorTimer("Mk2 Timer", 0.15, 0.5, 2));
			_timerSensorSets.push(new SensorTimer("Mk4 Timer", 0.03, 0.1, 5));
			_timerSensorSets.push(new SensorTimer("Really Bad Timer", 0.5, 0.99, 0.01));
			
			trace("Created timer sensor sets: ", _timerSensorSets.toString());
		}
		
		/*
		 * 
		 * Equipment possibility sets
		 * 
		 */
		
		private function createInitialBatterySets():void
		{
			//inst_model:String="", inst_mass: Number=0, inst_capacity:Number=0, inst_$:Number=0
			_batterySets.push(new AlienBattery("Mk0 Batt.", 5, 20, 1));
			_batterySets.push(new AlienBattery("Mk1 Batt.", 6 , 30, 5));
			_batterySets.push(new AlienBattery("Mk1.5 Batt.", 4 , 50, 7));
			_batterySets.push(new AlienBattery("Mk2 Batt.", 6 , 70, 12));
			_batterySets.push(new AlienBattery("Mk3 Batt.", 8 , 110, 17));
			_batterySets.push(new AlienBattery("Mk4 Batt.", 5 , 130, 22));
			_batterySets.push(new AlienBattery("Advanced Hydrogen Batt.", 5 , 230, 100));
			_batterySets.push(new AlienBattery("Overpriced Batt.",  6 , 40, 120));
			
			
			trace("Created battery sensor sets: ", _batterySets.toString());
		}
		
		private function createInitialMotorSets():void
		{
			//AlienMotor(inst_model:String="", inst_mass: Number=0, inst_force:Number=0, inst_$:Number=0, inst_friction:Number = 1.0, inst_ecost:Number = 0)
			_motorSets.push(new AlienMotor("Horse and Buggy", 3 , 1000, 3, 1.5, 0.01));
			_motorSets.push(new AlienMotor("Mk0 Truck", 1 , 20000, 1, 0.6, 0.003));
			_motorSets.push(new AlienMotor("Mk1 Truck", .5 , 30000, 5, 0.6, 0.004));
			_motorSets.push(new AlienMotor("Mk1.5 Truck", .25 , 30000, 7, 0.7, 0.003));
			_motorSets.push(new AlienMotor("Mk2 Truck", .75 , 35000, 10, 0.7, 0.003));
			_motorSets.push(new AlienMotor("Mk1 Airplane", 1.5 , 45000, 40, 0.9, 0.5));
			_motorSets.push(new AlienMotor("Mk2 Airplane", 1.5 , 50000, 60, 1.2, 0.7));
			_motorSets.push(new AlienMotor("Mk1 Super Airplane", 1.8 , 60000, 100, 1.6, .8));
			_motorSets.push(new AlienMotor("Overpriced Truck", .75 , 35000, 100, 0.7, 0.003));
			trace("Created motor sets: ", _motorSets.toString());
		}
		
		private function createInitialCPUSets():void
		{
			//inst_model:String, inst_mass: Number, inst_eCost:Number, inst_$:Number, inst_clockSpeed:Number
			//_CPUSets.push(new AlienCPU("No CPU", 0.0 , 0, 0, 100));
			_CPUSets.push(new AlienCPU("Mk0 CPU", .5 , 1, 1, 3));
			_CPUSets.push(new AlienCPU("Mk1 CPU", .5 , 1.2, 3, 2));
			_CPUSets.push(new AlienCPU("Mk1.5 CPU", .25 , 1, 4, 1));
			//_CPUSets.push(new AlienCPU(inst_model="Mk2 CPU", inst_mass=.25 , inst_eCost=1.2, inst_$=7, inst_clockSpeed=0.70));
			_CPUSets.push(new AlienCPU("Mk2 CPU", 0.25 , 1.2, 7, 0.70));
			_CPUSets.push(new AlienCPU("Mk3 CPU", 0.5 , 1.0, 10, 0.40));
			_CPUSets.push(new AlienCPU("Mk4 CPU", 0.6 , 0.8, 12, 0.35));
			_CPUSets.push(new AlienCPU("Mk5 Super CPU", 0.9 , 0.02, 30, 0.05));
			_CPUSets.push(new AlienCPU("Advanced Super CPU", 0.2 , 0.01, 100, 0.01));
			_CPUSets.push(new AlienCPU("Really Bad CPU", 2 , 40, 10, 1000));
			_CPUSets.push(new AlienCPU("No CPU", .01 , 0.01, 1, 10000000));
			_CPUSets.push(new AlienCPU("Overpriced CPU", 0.25 , 1.2, 70, 0.70));
			trace("Created CPU sets: ", _CPUSets.toString());
		}
		
		private function createInitialArmorSets():void
		{
			//create the inital sets of armor and put each set of armor in the armor array
			
			
			//No Armor
			//var armor:AlienArmor = new AlienArmor("Standard Issue", 1, 1, 1, 1);
			_armorSets.push(new AlienArmor("Clothing",0.5, 0.5, 0, 0));
			
			//Standard Issue
			//var armor:AlienArmor = new AlienArmor("Standard Issue", 1, 1, 1, 1);
			_armorSets.push(new AlienArmor("Standard Issue", 1, 1, 1, 1));
			
			//Two pairs of Standard Issue
			//var armor:AlienArmor = new AlienArmor("Two Pairs of Standard Issue", 2, 2, 2, 2);
			_armorSets.push(new AlienArmor("Two Pairs of Standard Issue", 2, 2, 2, 2));
			
			//inst_model:String, inst_area: Number, inst_mass: Number, inst_protection:Number, inst_$:Number
			//_armorSets.push(new AlienArmor("Naked", -1, -1, -1, 0));
			_armorSets.push(new AlienArmor("Mk2 Armor", 3, 3, 4, 7));
			_armorSets.push(new AlienArmor("Mk1 Tank", 2, 7, 20, 15));
			_armorSets.push(new AlienArmor("Mk2 Tank", 3, 9, 35, 30));
			_armorSets.push(new AlienArmor("Mk1 Light", 1, 1, 1, 5));
			_armorSets.push(new AlienArmor("Mk2 Light", .75, .75, 1, 10));
			_armorSets.push(new AlienArmor("Mk3 Light", .5, .5, 1, 15));
			_armorSets.push(new AlienArmor("Painful Light", .5, .5, -1, 15));
			_armorSets.push(new AlienArmor("Mk3.5 Light", .5, .5, 2, 25));
			_armorSets.push(new AlienArmor("Mk3.5 Light", .4, .4, 3, 35));
			_armorSets.push(new AlienArmor("Mk1 Medium", 1.5, 1.5, 4, 15));
			_armorSets.push(new AlienArmor("Mk2 Medium", 1.5, 1.5, 6, 25));
			_armorSets.push(new AlienArmor("Mk3 Medium", 1.5, 2, 7, 35));
			_armorSets.push(new AlienArmor("Mk1 Heavy", 2, 2.5, 9, 25));
			_armorSets.push(new AlienArmor("Mk2 Heavy", 2.5, 2.5, 11, 35));
			_armorSets.push(new AlienArmor("Mk2 Heavy", 2.5, 2.5, 15, 55));
			_armorSets.push(new AlienArmor("Advanced Composite", 1, 1, 19, 95));
			_armorSets.push(new AlienArmor("Overpriced Mk1 Light", 1, 1, 1, 50));
			
		}
		
		/*Ways to interface with the locker
		 * 
		 * 
		 */
		
		public function getRandomEquipment(equipmentType:String):*
		{
			//possibilities:
			//armor
			//battery
			//motor
			//healthSensor
			//batterySensor
			//timerSensor
			//CPU
			
			trace("Accessing a Random " + equipmentType + " from the locker");
			var equipmentRack:Array = this["_" + equipmentType + "Sets"];
			
			if (equipmentRack == null)
			{
				trace("Trying to access an unknown equipment rack, _" + equipmentType + "Sets");
				return false;
			}
			else //the equipment rack must be real
			{
			
				var randIndex:uint = Math.floor(Math.random() * equipmentRack.length);
				//trace("About to select armor set with index of", randIndex);
				var forIssue:* = equipmentRack[randIndex];
				//trace("About to issue Armor:", armorForIssue.getModel());
				return forIssue;
			}
		}
	
	}

}