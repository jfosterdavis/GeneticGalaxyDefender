package de.pixelate.flixelprimer 
{
	/**
	 * ...
	 * @author ...
	 */
	public class SensorTimer 
	{
		
		private var model:String;
		
		private var mass:Number;
		private var eCost:Number;
		private var $:Number;
		
		private var accuracy:Number; //ability to get close to the true reading. smaller number is more accurate
		private var precision:Number; //ability to get the same reading over multiple attempts
		
		private var tuneHigh:Number; //sets the high and low range for the random time.
		private var tuneLow:Number;
		
		private var timer:Number;
	
		
		public function SensorTimer(inst_model:String, inst_mass: Number, inst_eCost:Number, inst_$:Number, inst_accuracy:Number=0.5, inst_precision:Number=0.9) 
		{
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
			
			//initialize the timer high and low
			tuneLow = 0.25;
			tuneHigh = 4;
			
			//initialize the timer value
			resetTimer();
			
			trace("Timer set between ", tuneLow, " and ", tuneHigh, " at ", timer);
		}
		
		
		//resets the random timer for a random time between tunelow and tunehigh
		public function resetTimer():void
		{
			timer = tuneLow + (tuneHigh - tuneLow) * Math.random();
		}
		
		//returns the current value of the timer
		public function getCurrentTime():Number
		{
			return timer;
		}
		
		//checks the timer. if the timer is up, it returns true and resets the timer
		public function isTimeUp():Boolean
		{
			if (timer < 0)
			{
				//the time is up so it must be reset
				trace("Time is up on Random timer!");
				resetTimer();
				return true;
			}
			else {
				return false;
			}
		}
		
		public function tickTheTimer(timeElapsed:Number):void
		{
			var tmp:Number = timer;
			timer -= timeElapsed;
			trace("Timer ticked. Current time left was",tmp , " and is now ", timer, " after elapsing by ", timeElapsed)
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