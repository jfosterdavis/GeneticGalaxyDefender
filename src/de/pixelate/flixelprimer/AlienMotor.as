package de.pixelate.flixelprimer 
{
	/**
	 * Motors are an object given to an alien that has the attributes that determine movement speed
	 * @author J. Davis
	 */
	public class AlienMotor 
	{
		private var model:String;

		private var force:Number;
		private var mass:Number;
		private var $:Number;
		private var friction:Number;
		private var ecost:Number;
		
		
		public function AlienMotor(inst_model:String="", inst_mass: Number=0, inst_force:Number=0, inst_$:Number=0, inst_friction:Number = 1.0, inst_ecost:Number = 0) 
		{
			
			//set model name
			model = inst_model;
			
			mass = inst_mass;
			force = inst_force;
			$ = inst_$;
			friction = inst_friction;
			ecost = inst_ecost
			
		}
		
		
		
		public function getMass():Number 
		{
			return mass;
		}
		
		public function getECost():Number 
		{
			return ecost;
		}
		
		public function getForce():Number 
		{
			return force;
		}
		
		public function getFriction():Number 
		{
			return friction;
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