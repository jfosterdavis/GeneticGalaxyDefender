package de.pixelate.flixelprimer 
{
	/**
	 * this object is contained in an alien and tells the alien what state to transit to given a sensor trigger
	 * @author JF Davis
	 */
	import flash.utils.ByteArray; 
	 
	public class AlienStateTransitionTable 
	{
		private var allPossibleStatesArray:Array;
		private var transitionTable:Object;

		
		public function AlienStateTransitionTable() 
		{
			//define all of the possible strategies, identified by a uint.
			allPossibleStatesArray = new Array();
			//strategies 1-6 are possible for choosing
			for (var i:uint = 1; i <= 6; i++)
			{
				allPossibleStatesArray.push(i);
				
			}
			//trace("created possible strategies array: ", allPossibleStrategiesArray);
			
			//build the transition table by stepping through the possible states and creating a random transition state.
			//multidimensional array. Key is the currents state
			transitionTable = new Object();
			randomizeTransitionTable();
	/*		//trace("made a new random transition table. checking keys");
			for (var key:String in transitionTable)
			{
				trace(key);
			}*/

		}

		private function randomizeTransitionTable():void
		{
			for (var i:uint = 0; i < allPossibleStatesArray.length; i++)
			{
				var index:String = allPossibleStatesArray[i];
				
				//pick a random value from the possible strategies array
				var randIndex:uint = Math.floor(Math.random() * allPossibleStatesArray.length);
				
				transitionTable[index] = clone(allPossibleStatesArray[randIndex]);
				//trace("using random index of ", randIndex, "and an index of ", index, "transitionTable is now ", transitionTable[index]);
			}
		}
		
		//allows you to query the transition table with the current state and it returns the transition state
		public function getStateChange(currentState:uint):uint
		{
			return transitionTable[currentState];
		}
		
		//allows you to ask the table for its index values
		public function getIndexList():Array
		{
			var values:Array = new Array();
			for (var i:String in transitionTable)
			{
				values.push(i);
			}
			
			return values;
		}
		
		//this function allows a deep copy of an array/object
		private function clone(source:Object):* 
		{ 
			var myBA:ByteArray = new ByteArray(); 
			myBA.writeObject(source); 
			myBA.position = 0; 
			return(myBA.readObject()); 
		}
		
		public function getLength():uint
		{
			return allPossibleStatesArray.length;
		}
		
		public function getTransitionTable():Object
		{
			return transitionTable;
		}
		
		public function setTransitionTable(newTable:Object):void
		{
			transitionTable = newTable;
		}
		
		public function setTransitionTableValue(index:String, value:uint):void
		{
			transitionTable[index] = value;
		}
	}

}