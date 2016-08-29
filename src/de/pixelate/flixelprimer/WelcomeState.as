package de.pixelate.flixelprimer 
{
	/**
	 * ...
	 * @author J F Davis
	 */
	import flash.display.ShaderInput;
	import mx.core.FlexTextField;
	import org.flixel.*
	 
	public class WelcomeState  extends FlxState
	{
		//[Embed(source = "../../../../assets/png/Alien.png")] private var ImgAlien:Class;
		
		private var _titleText:FlxText;
		private var _subTitleText:FlxText;
		private var _GAText:FlxText;
		private var _startGameText:FlxText;
		private var _revText:FlxText;
		
		private var _alien:Alien;
		private var _ship:Ship;
		
		public function WelcomeState() 
		{
			
			super.create();
			
			//display welcome
			_titleText = new FlxText(10, 10, FlxG.width-20, "Genetic Galaxy Defender!");
			_titleText.setFormat(null, 72, 0xFF597137, "center");
			
			_subTitleText = new FlxText(30, 200, FlxG.width-60, "Using your Starship, you must prevent the Aliens from reaching the left side of the screen. You must also survive to tell the tale! \n\n The Aliens may seem dumb and like mindless bugs at first - be beware! Each Level they apply a Genetic Algorithm to become stronger! They will become very good at beating YOU.\n\nBy playing this game you should learn an appreciation for the Genetic Algorithm - and save the Galaxy!");
			_subTitleText.setFormat(null, 18, 0xFF597137, "center");
			
			_GAText = new FlxText(150, 450, 700, "What is a Genetic Algorithm? What is an Evolutionary Algorithm?\n\n A Genetic Algorithm (GA) is an Evolutionary Algorithm (EA) that mimics DNA or other natural selection processes to adapt its ability to adapt and evolve. Here are the basic steps: \n- Start with a population (Aliens)\n- Have the population undergo a fitness test (reaching the left side alive)\n- Take the most fit of the survivors and have them 'mate' (trade equipment and strategies)\n- Produce offspring to create a new population, using: \n   - Crossover (trading of genes)\n   - Mutation (trying out random equipment and strategies) ");
			_GAText.setFormat(null, 12, 0xFF597137, "left");
			
			_startGameText = new FlxText(30, FlxG.height-50, FlxG.width-60, "PRESS ENTER TO START!");
			_startGameText.setFormat(null, 34, 0xFF597137, "center");
			
			_revText = new FlxText(FlxG.width-120, FlxG.height-70, 120, "(v0.9 rev Jul2013)\nJ.F.Davis");
			_revText.setFormat(null, 10, 0xFF597137, "left");
			
			add(_titleText);
			add(_subTitleText);
			add(_GAText);
			add(_startGameText);
			add(_revText);
			
			//_alien = new Alien(30,30);
			_ship = new Ship;
			
			//add(_alien);
			add(_ship);
			
		}
		
		override public function update():void
		{
			if(FlxG.keys.justPressed("ENTER"))
			{
				FlxG.state = new PlayState();
			}
			
			//super.update();
		}
		
	}

}