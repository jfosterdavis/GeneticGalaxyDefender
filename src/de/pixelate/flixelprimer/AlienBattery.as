package de.pixelate.flixelprimer 
{
	/**
	 * ...
	 * @author J Davis
	 */
	public class AlienBattery 
	{
		private var model:String;

		private var capacity:Number;
		private var mass:Number;
		private var $:Number;
		
		private var chargeLevel:Number;
		
		public function AlienBattery(inst_model:String="", inst_mass: Number=0, inst_capacity:Number=0, inst_$:Number=0) 
		{
			//set model name
			model = inst_model;
			
			mass = inst_mass;
			capacity = inst_capacity;
			$ = inst_$;
			
			chargeLevel = capacity;
				
			
		}
		
		//use the battery and return true if the battery was charged
		public function useBattery(eCost:Number):Boolean
		{
			//the number must be positive or zero
			if (eCost <= 0)
			{
				trace("Trying to charge an eCost to battery of less than 0");
				return false;
			}
			else 
			{
				//subtract the ecost from current charge
				chargeLevel -= eCost;
				//trace("Used the Battery. Used ", eCost, " units of energy... ", chargeLevel, " units remain" );
				
				return true;
			}
		}
		
		public function rechargeBattery():void
		{
			chargeLevel = capacity;
		}
		
		public function getMass():Number 
		{
			return mass;
			//return 1.0;
		}
		
		public function setMass(newMass:Number):void
		{
			mass = newMass;
		}
		
		public function getCapacity():Number 
		{
			return capacity;
		}
		
		public function setCapacity(newCapacity:Number):void
		{
			capacity = newCapacity;
		}
		
		public function getChargeLevel():Number 
		{
			return chargeLevel;
		}
		
		public function setChargeLevel(newLevel:Number):void
		{
			chargeLevel = newLevel;
		}
		
		public function getCost():Number
		{
			return $;
		}
		
		public function setCost(new_$:Number):void
		{
			$ = new_$;
		}
		
		public function getModel():String
		{
			return model;
		}
		
		public function setModel(name:String):void
		{
			model = name;
		}
	}

}