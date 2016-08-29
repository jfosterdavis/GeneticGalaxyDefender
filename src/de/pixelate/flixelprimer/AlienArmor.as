package de.pixelate.flixelprimer 
{
	/**
	 * Alien armor is a design parameter that gives protection to the alien.
	 * @author J Davis
	 */
	public class AlienArmor 
	{
		private var model:String;
		private var area:Number;
		private var mass:Number;
		private var protection:Number;
		private var $:Number;
		
		
		public function AlienArmor(inst_model:String, inst_area: Number, inst_mass: Number, inst_protection:Number, inst_$:Number):void
		{
			//intantiate this armor object with the given values
			model = inst_model;
			area = inst_area;
			mass = inst_mass;
			protection = inst_protection;
			$ = inst_$;
		}
		
		public function getArea():Number
		{
			return area;
		}
		
		public function getMass():Number 
		{
			return mass;
		}
		
		public function getProtection():Number 
		{
			return protection;
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