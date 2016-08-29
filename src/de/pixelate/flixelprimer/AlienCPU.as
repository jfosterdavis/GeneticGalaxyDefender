package de.pixelate.flixelprimer 
{
	/**
	 * ...
	 * @author J Davis
	 */
	public class AlienCPU 
	{
		private var model:String;

		private var eCost:Number;
		private var mass:Number;
		private var clockSpeed:Number;// lower numbers are better
		private var $:Number;
		
		public function AlienCPU(inst_model:String, inst_mass: Number, inst_eCost:Number, inst_$:Number, inst_clockSpeed:Number) 
		{
			//set model name
			model = inst_model;
			
			mass = inst_mass;
			eCost = inst_eCost;
			$ = inst_$;
			
			//set clock speed
			// lower numbers are better. lowest number is 0
			if (! setClockSpeed(inst_clockSpeed))
			{
				trace("PRECISION SET TO DEFAULT FOR BAD INPUT");
				clockSpeed = 200;
			}
		
			
		}
		
		public function getMass():Number 
		{
			return mass;
		}
		
		public function getECost():Number 
		{
			return eCost;
		}
		
		public function getClockSpeed():Number 
		{
			return clockSpeed;
		}
		
		//sets the clock speed and returns true if successful
		public function setClockSpeed(newClockSpeed:Number):Boolean 
		{
			if (newClockSpeed > 0.00)
			{
				clockSpeed = newClockSpeed;
				return true;
			}
			else 
			{
				trace("Bad clock speed request: ", newClockSpeed, ". Not changing clock speed.");
				return false;
			}
		}
		
		public function getCost():Number
		{
			return $;
		}
		
		public function getModel():String
		{
			return model;
		}
		
	}

}