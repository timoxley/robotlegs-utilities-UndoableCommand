package org.robotlegs.utilities.undoablecommand
{
	
	
	import org.robotlegs.utilities.undoablecommand.interfaces.*;
	
	public class CommandHistory implements IHistory
	{
		static public const NUM_HISTORY_STATES:uint = 999;
		
		private var _historyStack:Vector.<IUndoableCommand>;
		
		public var currentPosition:uint;
		public var isReady:Boolean;
		
		public function CommandHistory() {
			_historyStack = new Vector.<IUndoableCommand>();
			currentPosition = 0;
		}
		
		public function get canStepForward():Boolean {
			// numberOfHistoryItems > 0
			// currentPosition < numberOfHistoryItems
			return (currentPosition < numberOfHistoryItems);
			
		}
		
		public function get canStepBackward():Boolean {
			return (currentPosition > 0);
		}
		
		public function stepForward():void {
			if (canStepForward) {
				_historyStack[currentPosition].execute();
			}
			currentPosition++;
		}
		
		public function stepBackward():void {
			if (canStepBackward) {
				_historyStack[currentPosition - 1].undo();
			}
			currentPosition--;
		}
		
		public function rewind():void {
			var count:uint = 0;
			while(canStepBackward) {
				stepBackward();
				count++;
				if (count > NUM_HISTORY_STATES) {
					throw new Error("Possible infinite loop.");
				}
			}
		}
		
		public function fastForward():void {
			var count:uint = 0;
			while(canStepForward) {
				stepForward();
				count++;
				if (count > NUM_HISTORY_STATES) {
					throw new Error("Possible infinite loop.");
				}
			}
		}
		
		public function get numberOfHistoryItems():uint {
			return _historyStack.length;
		}
		
		public function push(command:IUndoableCommand):void {
			
			if (currentPosition != numberOfHistoryItems) {
				_historyStack = _historyStack.slice(0, currentPosition);	
			}
			_historyStack.push(command);
			currentPosition = numberOfHistoryItems;
		}
	}
}