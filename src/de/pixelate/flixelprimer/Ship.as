package de.pixelate.flixelprimer
{
	import org.flixel.*;

	public class Ship extends FlxSprite
	{		
		[Embed(source = "../../../../assets/png/Ship.png")] private var ImgShip:Class;
		
		//Magazine Capacity
		private var mag_capacity:uint = 100;
		//Number of bullets remaining
		private var mag: FlxGroup;

		private var velocityModifier:uint;
		
		//bullets in stock
		private var bulletStock:Array; //an array of bullet objects that represent what this ship can fire
		
		private var primaryAmmoIsLoaded:Boolean;
		

		public function Ship():void
		{
			//create the magazine
			// and set capacity of magazine
			this.mag = new FlxGroup();
		

			
			//this.mag_remaining = this.mag_capacity;
			
			velocityModifier = 0;
			
			bulletStock = new Array();
			var p: FlxPoint = this.getBulletSpawnPosition()
			var bullet: Bullet = new Bullet(p.x, p.y);
			bullet.setModel("Normal Bullet");
			bulletStock[0] = bullet; //normal bullet
			bulletStock[1] = cloneBullet(bullet);
			
			//fill up the magazine
			restockMagazine();
			
			super(50, 50, ImgShip);
		}
		
		public function getPrimaryAmmoName():String
		{
			return bulletStock[0].getModel();
		}
		
		public function getSecondaryAmmoName():String
		{
			return bulletStock[1].getModel();
		}
		
/*		public function fillMagazine():void
		{
			while (this.mag.members.length < this.mag_capacity)
			{
				
				var bullet: Bullet = cloneBullet(bulletStock[0]);
				this.mag.add(bullet);
			}
		}*/
		
		public function cloneBullet(modelBullet:Bullet):Bullet
		{
			
			var newBullet:Bullet = new Bullet(modelBullet.x, modelBullet.y, modelBullet.width, modelBullet.height);
			
			//copy features
			newBullet.setModel(modelBullet.getModel());
			newBullet.setDamage(modelBullet.getDamage());
			newBullet.setSpeed(modelBullet.velocity.x);
			newBullet.setCost(modelBullet.getCost());
			
			return newBullet;
		}
		
		//only the primary ammo is fired. this will load the magazine with the bullets that are not active
		public function togglePrimarySecondaryAmmo():void
		{
			//quick fix. if mag is depleted then don't do this
			if (getMagazineRemaining() > 0)
			{	
				var bulletStockIndex:uint;
				var newbulletStockIndex:uint;
				if (primaryAmmoIsLoaded) //if primary ammo is loaded, then the index for that ammo is 0
				{
					bulletStockIndex = 0;
					newbulletStockIndex = 1;
					
					//now the secondary will be loaded
					primaryAmmoIsLoaded = false;
				}
				else //else it's the secondary, which is 1
				{
					bulletStockIndex = 1;
					newbulletStockIndex = 0;
					
					primaryAmmoIsLoaded = true;
				}
				//find out the current number of bulllet points
				trace("cost " + bulletStock[bulletStockIndex].getCost());
				trace("remaining " + getMagazineRemaining());
				var bulletPoints:uint = Math.floor(bulletStock[bulletStockIndex].getCost() * getMagazineRemaining());
				trace("bullet points "+bulletPoints);
				
				//now restock the magazine up to that many bullet points
				restockMagazine(bulletStock[newbulletStockIndex], bulletPoints);
			}
			
		}
		
		public function setPrimaryAmmo(newBullet:Bullet):void
		{
			bulletStock[0] = cloneBullet(newBullet);
		}
		
		public function setSecondaryAmmo(newBullet:Bullet):void
		{
			bulletStock[1] = cloneBullet(newBullet);
		}
		
		public function restockMagazine(newAmmo:Bullet=null, howMany:uint=0):void
		{
			//empty the mag
			this.mag.kill();
			this.mag.destroy();
			//this.mag.clear();
			this.mag = new FlxGroup;
			
			var bullet:Bullet;
			var p: FlxPoint = this.getBulletSpawnPosition();
			if (newAmmo != null && newAmmo is Bullet)
			{
				bullet = newAmmo;
				//bullet.setSpawnPoint(p.x, p.y);
				trace("filling the magazine with " + bullet.getModel());
			}
			else
			{
				bullet = bulletStock[0];
				primaryAmmoIsLoaded = true;
				trace("filling the magazine with " + bullet.getModel());
			}
			
			//find out how many. if null fillt he whole thing
			var fillLevel:uint;
			if (howMany != 0)
			{
				fillLevel = Math.floor(howMany / bullet.getCost());
				trace("howMany is not 0, filling magazine to " + fillLevel);
			}
			else
			{
				//default fill level accoutns for bullet cost
				fillLevel = Math.floor(this.mag_capacity / bullet.getCost());
				trace("howMany is else, filling magazine to " + fillLevel);
			}
			
			//now fill the mag
			while (this.mag.members.length < fillLevel)
			{
				this.mag.add(cloneBullet(bullet));
			}
			
		}
		
		public function setMagazineSize(newSize:uint):void
		{
			mag_capacity = newSize;
		}
		
		//returns the number of bullets left
		public function getMagazineRemaining():int
		{
			return mag.countLiving();
		}
		
		public function setVelocityModifier(newModifier:uint):void
		{
			velocityModifier = newModifier;
		}
		
		public function getVelocityModifier():uint
		{
			return velocityModifier;
		}
		
		public function getShipSpeed():Number
		{
			return 200 + velocityModifier;
		}
		
		
		override public function update():void
		{
			velocity.x = 0;
			velocity.y = 0;
			
			// disable ability to go left or right
			/*
			if(FlxG.keys.LEFT)
			{
				velocity.x = -250;
			}
			else if(FlxG.keys.RIGHT)
			{
				velocity.x = 250;				
			}
			*/
			if(FlxG.keys.UP)
			{
				velocity.y = -200 - velocityModifier;				
			}
			else if(FlxG.keys.DOWN)
			{
				velocity.y = 200 + velocityModifier;
			}
			
			super.update();
			
			if(x > FlxG.width-width-16)
			{
				x = FlxG.width-width-16;
			}
			else if(x < 16)
			{
				x = 16;				
			}

			if(y > FlxG.height-height-16)
			{
				y = FlxG.height-height-16;
			}
			else if(y < 16)
			{
				y = 16;				
			}	
			
		}
		
		public function getBulletSpawnPosition():FlxPoint
		{
			var p: FlxPoint = new FlxPoint(x + 36, y + 12);
			return p;
		}	
			
		//creates and returns a bullet, unless there are no more bullets in which case null is returned
		public function fireBullet():FlxObject
		{
			
			if (this.mag.members.length <= 0) //if there are no bullets in the magazine
			{
				return null;
			}
			else //pop off a bullet and pass to playstate
			{
				var bullet: FlxObject = this.mag.getFirstExtant();
				this.mag.remove(bullet);
				if (bullet is Bullet)
				{
					//get current position of the ship for the bullet
					var p: FlxPoint = this.getBulletSpawnPosition()
					//set the current position of the bullet
					bullet.x = p.x;
					bullet.y = p.y - bullet.height/2;
					return bullet;
				}
				else 
				{
					return null;	
				}
				
			}
			
			//this block when bullets were not a part of the magazine
			/*//fire a bullet if the magazine is not empty
			if (this.mag_remaining <= 0)
			{
				return null;
			}
			else
			{
				//get current position of the ship for the bullet
				var p: FlxPoint = this.getBulletSpawnPosition()
				var bullet: Bullet = new Bullet(p.x, p.y);
				//_bullets.add(bullet);
				
				//remove a bullet from the magazine
				this.mag_remaining--;
				//return the bullet to the playstate
				return bullet;
			}*/
		}
	}
}