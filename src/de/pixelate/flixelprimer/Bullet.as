package de.pixelate.flixelprimer
{
	import org.flixel.*;

	public class Bullet extends FlxSprite
	{
		private var damage:Number;
		private var model:String;
		private var cost:Number;//how many ammo points this bullet costs
		
		public function Bullet(x: Number=0, y: Number=0, length:uint=16, height:uint=4, fmodel:String="No name given", fdamage:uint=1, fcost:uint=1, fspeed:Number=500):void
		{
			super(x, y);
			createGraphic(length, height, 0xFF597137);
			velocity.x = fspeed;
			
			
			damage = fdamage;
			cost = fcost;
			model = fmodel;
		}
		
		public function getCost():Number
		{
			return cost;
		}
		
		public function setCost(newCost:Number):void
		{
			cost = newCost;
		}
		
		public function setModel(name:String):void
		{
			model = name;
		}
		
		public function getModel():String
		{
			return model;
		}
		
		public function getDamage():Number
		{
			return damage;
		}
		
		public function setDamage(newdamage:Number):void
		{
			damage = newdamage;
		}
		
		public function setSpeed(newspeed:Number):void
		{
			velocity.x = newspeed;
		}
		
		public function setSpawnPoint(newx:Number, newy:Number):void
		{
			x = newx;
			y = newy;
		}
	}
}