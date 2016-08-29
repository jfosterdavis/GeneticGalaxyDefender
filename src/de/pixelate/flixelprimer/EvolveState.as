package de.pixelate.flixelprimer 
{
	/**
	 * this state takes results of a PlayState and evolves the aliens for the next round.
	 * @author ...
	 */
		import mx.core.FlexTextField;
	import org.flixel.*
	 
	public class EvolveState extends FlxState
	{

		private var evolveText: FlxText;	
		private var titleText:FlxText;
		private var getReadyText:FlxText;
		private var nextRoundDetails:FlxText;
		private var GAFactsText:FlxText;
		private var parentsLabelText:FlxText;
		private var childrenLabelText:FlxText;
		
		private var _transitionCounter:Number; //holds the current time left to transition after round is over
		private var _readyToTransition:Boolean = false;
		
		private var _round:uint;
		private var _survivors:FlxGroup;
		private var _dead:FlxGroup;
		private var _selectedToMate:FlxGroup;
		private var _children:FlxGroup;
		private var _newBatchForNextRound:FlxGroup;
		
		private var _totalFitness:Number;
		
		private var _previousScore:uint;
		
		private var pass:uint; //which pass through the update? Each pass will perform a diff fucntion and display diff text
		private var runTransitionOnceAlready:Boolean = false;
		
		public function EvolveState(inst_round:uint, inst_survivors:FlxGroup, inst_dead:FlxGroup):void
		{
			_round = inst_round;
			_survivors = inst_survivors;
			_dead = inst_dead;
			
			_selectedToMate = new FlxGroup;
			_newBatchForNextRound = new FlxGroup;
			_children = new FlxGroup;
			
			//_previousScore = inst_previousScore;
			
			pass = 0;
			_totalFitness = 0;
			
			titleText = new FlxText(0, 10, FlxG.width, "Level " + _round + " is over. There were "+ _survivors.countLiving()+ " Alien survivors" );					
			titleText.setFormat(null, 32, 0xFF597137, "center");
			add(titleText);
			

			
			evolveText = new FlxText(0, FlxG.height / 2, FlxG.width, "Level: " + _round + " Survivors: " + _survivors.countLiving());					
			evolveText.setFormat(null, 16, 0xFF597137, "center");
			add(evolveText);
			
			getReadyText = new FlxText(0, FlxG.height / 2+250, FlxG.width, "Get ready for Level "+(_round+1).toString()+"!");					
			getReadyText.setFormat(null, 32, 0xFF597137, "center");
			
			nextRoundDetails = new FlxText(0, FlxG.height / 2 +290, FlxG.width, "Aliens may be better at getting to the goal. Alien budget may be higher.\n You may be faster and you will have slightly more bullets... ");					
			nextRoundDetails.setFormat(null, 16, 0xFF597137, "center");
			
			GAFactsText = new FlxText( FlxG.width-230, 30, 2000, "");					
			GAFactsText.setFormat(null, 8, 0xFF597137, "left");
			

			
			
			trace("Starting evolution phase post Level " + _round);
		}
		
		override public function update():void
		{
			
			
			
			if ((! _readyToTransition) && pass==0) //if this is the first pass through then start the count down
			{
				_transitionCounter = 3;
				pass = 1;//iterate to next pass
				//trace("Initialized counter and set pass=1");
				//if there were no survivors, skip back to the playstate
				if (_survivors.countLiving() < 1)
				{
					pass = 0;
					_readyToTransition = true;
				}
				
			}
			else if (pass == 1)
			{
				trace("Started Phase 1: Fitness computation");
				trace("Array of survivors is " + _survivors.members.toString()); 
				//on the first pass 
				titleText.text = "Computing fitness of each survivor \n Fitness = (health_remaining/$cost_to_build)";
				trace(titleText.text);
				//each mating yields 2 offspring and you can keep the parents.
				//compute the fitness of each of the survivors
				//keep a running tally of the total fitness amount
				for each (var survivor:Alien in _survivors.members)
				{
					survivor.computeFitness();
					var hisFitness:Number = survivor.getFitness();
					_totalFitness += hisFitness;
					evolveText.text = "Fitness of Alien: " + survivor + " computed to be: " + hisFitness + " \n Sum of all fitness values: " + _totalFitness;
					trace(evolveText.text);
				}
				pass = 2;//iterate to next pass
			}
			else if (pass == 2)
			{
				trace("Started Phase 2: Mate Selection");
				//on the second pass 
				titleText.text = "Selecting mates.";
				trace(titleText.text);
				evolveText.text = "";
				//selecting a random number between 0 and the total fitness, the iterating through each survivor in the same order will allow us to select mates at a rate proportional to thier fitness
				
				//select a mate 6 times
				for (var i:uint = 0; i < 6; i++)
				{
					titleText.text = "Searching for mate " + i +" of 6. "+ _selectedToMate.countLiving()+" of 6 found so far.";
					trace("Searching for mate " + i +" of 6. "+ _selectedToMate.countLiving()+" of 6 found so far.");
					var fitnessIndex:Number = 0; //this will keep track of where we are as we count through each survivor.
					//pick a random number between 0 and 1 and multiply by the total fitness to obtain a number between 0 and total fitness.
					var fitnessTarget:Number = Math.random() *  _totalFitness; //this points to one of our survivors
					
					//find the lucky winner
					var winnerFound:Boolean = false;
					//assumption that is not rejected by ActionScript documentation is that survivors will be drawn from the group in the same order as in pass==1
					for each (var survivor:Alien in _survivors.members)
					{
						if (! winnerFound) //only look for a winner if a winner has not yet been found
						{
							
						
							fitnessIndex += survivor.getFitness();
							//titleText.text = " Target: " + fitnessTarget.toString().substr(0, 5) + " .  Now considering: " + survivor + " whose fitness is: " + survivor.getFitness();
							//trace("Fitness index is "+ fitnessIndex+ titleText.text);
							if (fitnessTarget <= fitnessIndex)//if the current index is less than or equalto the target, then this is the lucky survivor
							{
								evolveText.text = survivor + " selected for the mating party! (Index: "+fitnessIndex+" Target: "+fitnessTarget+")";
								trace(evolveText.text);
								winnerFound = true;
								//add this survivor to the group that will mate
								_selectedToMate.add(survivor);
							}
						}
					}
				}
				evolveText.text = "Selected "+_selectedToMate.countLiving()+" Aliens for mating based on fitness";
				trace(titleText.text);
				
				pass = 3;//iterate to next pass
				
			}
			//this pass take those who will mate and actually mate them to yield a set of 6 children
			//next round the possible aliens for spawning are the initial survivors plus the 6 children
			else if (pass == 3)
			{
				trace("Started Phase 3: Mating");
				//on the second pass 
				titleText.text = "Mating with crossover and selection";
				trace(titleText.text);
				evolveText.text = "";
				
				//var offspring:Array = new Array();// this will hold all of the created offspring and then added to the FlxGroup
				
				//each of the 6 mates will mate once. each mating produces 2 offspring
				for (var i:uint=0; i < _selectedToMate.members.length; i+=2)
				{
					trace("this will loop " +_selectedToMate.members.length+" i: "+i); 
					//each loop requires working with the i alien and the i+1 alien. the loop skips by 2 each time.
					var firstMate:Alien = _selectedToMate.members[i];
					var secondMate:Alien = _selectedToMate.members[i + 1];
					//check to make sure the secondMate is not null. If there is an odd number of mates something has gone wrong
					//just let it throw an error
					
					var children:Array = firstMate.mate(secondMate);
					evolveText.text = firstMate+" and " +secondMate+ " mated and the following offspring were created: " + children.toString();
					trace(evolveText.text);
					
					//add the children to the offspring array
					//offspring.push(children[0]);
					//offspring.push(children[1]);
					_children.add(children[0]);
					_children.add(children[1]);
					
					evolveText.text = "The _children group now holds: " + _children.members.toString();
					trace(evolveText.text);
				}
				
				pass = 4;
				
			}
			else if (pass == 4)
			{
				trace("Started Phase 4: Create a group of possible Aliens for next Level from the children and survivors");
				
				titleText.text = "Finalizing group of Aliens for next Level";
				trace(titleText.text);
				evolveText.text = "";
				
				//add each member of the original survivors
				for each (var survivor:Alien in _survivors.members)
				{
					_newBatchForNextRound.add(survivor);
					evolveText.text = "Added " + survivor + " group now contains: " + _newBatchForNextRound.members.toString();
					trace(evolveText.text);
				}
				
				//add children
				for each (var child:Alien in _children.members)
				{
					_newBatchForNextRound.add(child);
					evolveText.text = "Added " + child + " group now contains: " + _newBatchForNextRound.members.toString();
					trace(evolveText.text);
				}
				
				pass = 5;
				_readyToTransition = true;
			}
			else if(_readyToTransition) //if evolution is all done
			{
				_transitionCounter -= FlxG.elapsed;
				
				//if (!runTransitionOnceAlready) //only do the following once
				//{	
					evolveText.y = (FlxG.height / 2)-275;
					
					if (_survivors.countLiving() < 1)
					{
						titleText.text = "You annihilated all of the Aliens in the last Level!";
						evolveText.text = "Now they must repopulate! The next Level will contain a randomly generated set of Aliens! You will be slower for this Level. (Because you are amazed (stunned) that they keep coming)";
					}
					else
					{
						titleText.text = "Evolving of Aliens complete.";
						evolveText.text = _selectedToMate.countLiving() + " lucky Parents were selected and produced " + _children.countLiving() + " Children \n\n Below, the parents are on the first group and the children on the second. \nCheck out their attributes and see where crossover and mutation has happened!\nAll survivors from the last Level, Parents, and Children are elligible for the next Level.\nPress p for more reading time.";
						getReadyText.text = "Get ready for Level " + (_round + 1).toString() + "!";//\n" + (10 - (10-_transitionCounter)).toString().substr(0,1);
						GAFactsText.text = "Fun Facts:\n Mutation Rate: "+_survivors.members[0].getMutationRate()+"%\n Crossovers: "+_survivors.members[0].getNumCrossovers()+"\n Fitness Function: Health/$Cost\n Parents can be selected more than once.\n Aliens Brains are also evolved, but not shown.";
					
					
						
						meetTheSurvivors();
						meetTheChildren();
					}
					add(getReadyText);
					add(nextRoundDetails);
					add(GAFactsText);
					
					runTransitionOnceAlready = true;
				//}
				//check to see if counter is expired
				if (_transitionCounter <= 0)
				{
					//transition to next round stage
					FlxG.state = new PlayState(_round,_survivors);
				}
				
			}
			else {
				trace("Error.... no condiiton met. May not have evolved");
			}
		}
		
		public function meetTheSurvivors():void
		{
			//displays the parents to the screen
			parentsLabelText = new FlxText( 0, FlxG.height / 2 - 150, FlxG.width, "Parents:");					
			parentsLabelText.setFormat(null, 12, 0xFF597137, "center");
			add(parentsLabelText);
			
			var xpos:uint = 15;
			var ypos:uint = FlxG.height / 2 - 15;
			var count:uint = 0; //only count up to 8 of them
			for each (var survivor:Alien in _selectedToMate.members)
			{

				survivor.x = xpos;
				survivor.y = ypos;
				add(survivor);
				
				//survivor.visible = true;
				
				survivor.killTexts();
				survivor.resetTexts();
				survivor.refreshTextContent(true);
				survivor.refreshPositionOfTexts();
				survivor.visible = true;
				
				//trace("survivor displayed");
				
				xpos += 250;
				
				//wrap the punks
				if (xpos > FlxG.width - 250)
				{
					ypos -= 90;
					xpos = 20+250;
				}
				
				count ++;

			}
		}
		
		public function meetTheChildren():void
		{
			//displays the kids to the screen

			
			childrenLabelText = new FlxText( 0, FlxG.height / 2+50, FlxG.width, "Children:");					
			childrenLabelText.setFormat(null, 12, 0xFF597137, "center");
			add(childrenLabelText);
			
			var xpos:uint = 15;
			var ypos:uint = FlxG.height / 2+90;
			for each (var survivor:Alien in _children.members)
			{
				survivor.x = xpos;
				survivor.y = ypos;
				add(survivor);

				
				survivor.killTexts();
				survivor.resetTexts();
				survivor.refreshTextContent(true);
				survivor.refreshPositionOfTexts();
				
				//trace("survivor displayed");
				
				xpos += 250;
				
				//wrap the children
				if (xpos > FlxG.width - 250)
				{
					ypos += 90;
					xpos = 15+250;
				}
			}
		}

	}
}