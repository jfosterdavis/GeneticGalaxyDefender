package de.pixelate.flixelprimer 
{
	/**
	 * ...
	 * @author ...
	 */
	public class SensorDistanceLong 
	{
		private var model:String;
		
		private var mass:Number;
		private var eCost:Number;
		private var $:Number;
		
		private var accuracy:Number; //ability to get close to the true reading. smaller number is more accurate
		private var precision:Number; //ability to get the same reading over multiple attempts. higher number is better
		
		public function SensorDistanceLong(inst_model:String, inst_mass: Number, inst_eCost:Number, inst_$:Number, inst_accuracy:Number=0.5, inst_precision:Number=0.9)
		{
			super();
			
			//set model name
			model = inst_model;
			
			mass = inst_mass;
			eCost = inst_eCost;
			$ = inst_$;
			
			//set how accurate this is
				accuracy = inst_accuracy;

			//set precision
			if (inst_precision > 0 && inst_precision <= 1)
			{
				precision = inst_precision;
			}
			else
			{
				trace("PRECISION SET TO DEFAULT FOR BAD INPUT");
				precision = 0.01;
			}
		}
		
		//function that returns true if it perceives to be further than 75% of reaching the goal space
		public function detectDistanceLong(actualDistance:Number, overallWidth:Number):Boolean
		{
			//determine precision factor
			var diceRoll:Number = Math.random();
			//randomly determine if precision offset will be positive or negative
			var signRoll:Number = Math.random();
			var sign:int=0;
			if (signRoll >= 0.5)
			{
				sign = -1;
			}
			else
			{
				sign = 1;
			}
			//give a random offset based on random roll and precision where high precision makes the overall number low
			var precisionOffset:Number = diceRoll / precision * sign;
			
			var detectedDistance:Number = actualDistance + accuracy + precisionOffset;
			
			trace("Detecting distance long ... ", detectedDistance, "Actual distance was ", actualDistance, " Precision offset was ", precisionOffset, "Accuracy was ", accuracy);
			
			//if the detected distance 75% or greater of the total width then return true
			var targetDistance:Number = 0.75 * overallWidth;
			if (detectedDistance >= targetDistance)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function getPrecision():Number
		{
			return precision;
		}
		
		public function getMass():Number 
		{
			return mass;
		}
		
		public function getECost():Number 
		{
			return eCost;
		}
		
		public function getAccuracy():Number 
		{
			return accuracy;
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