package org.robotlegs.utilities.undoablecommand
{
	
	
	import org.robotlegs.utilities.undoablecommand.interfaces.*;
	
	public class CommandHistory
	{		
		private var _historyStack:Vector.<IUndoableCommand>;
		
		public var currentPosition:uint;
		public var isReady:Boolean;
		
		public function CommandHistory() {
			_historyStack = new Vector.<IUndoableCommand>();
			currentPosition = 0;
		}
		
		/** 
		 * Test if we can move forward through the history stack
		 * @return true if there's a command to redo
		 */
		public function get canStepForward():Boolean {
			return (currentPosition < numberOfHistoryItems);
			
		}
		
		/** 
		 * Test if we can move backward through the history stack
		 * @return true if there's a command to undo
		 */
		public function get canStepBackward():Boolean {
			return (currentPosition > 0);
		}
		
		/** 
		 * Move forward through the history stack
		 * i.e. redo/execute the next command on the history stack
		 * @return position in history stack after this operation
		 */
		public function stepForward():uint {
			if (canStepForward) {
				_historyStack[currentPosition++].execute();
			}
			return currentPosition;
		}
		
		/** 
		 * Move backward through the history stack
		 * i.e. undo the previous command on the history stack
		 * @return position in history stack after this operation
		 */
		public function stepBackward():uint {
			if (canStepBackward) {
				_historyStack[--currentPosition].undo();
			}
			return currentPosition;
		}
		
		/** 
		 * Undo all/some commands
		 * @param numTimes number of positions to move backward. The default, 0, rewinds to the start of the history
		 * @return position in history stack after this operation
		 */
		public function rewind(numTimes:uint = 0):uint {
			var positionToMoveTo:uint;
			
			if (numTimes == 0) {
				positionToMoveTo = 0;
			} else {
				positionToMoveTo = currentPosition - numTimes;
			}
			
			while(canStepBackward && currentPosition != positionToMoveTo) {
				stepBackward();
			}
			return currentPosition;
		}
		
		/** 
		 * Redo all/some commands
		 * @param numTimes number of positions to move forward. The default, 0, fast forwards to the end of the history
		 * @return position in history stack after this operation
		 */
		public function fastForward(numTimes:uint = 0):uint {
			var positionToMoveTo:uint;
			
			if (numTimes == 0) {
				positionToMoveTo = numberOfHistoryItems;
			} else {
				positionToMoveTo = currentPosition + numTimes;
			}
			
			while(canStepForward && currentPosition != positionToMoveTo) {
				stepForward();
			}
			return currentPosition;
		}
		
		/** 
		 * @return number of items in history, both forward 
		 * and backward from current position
		 */
		public function get numberOfHistoryItems():uint {
			return _historyStack.length;
		}
		
		
		/** 
		 * Push a command onto the history stack
		 * @return position in history stack after this operation
		 */
		public function push(command:IUndoableCommand):uint {
			if (currentPosition != numberOfHistoryItems) {
				_historyStack = _historyStack.slice(0, currentPosition);	
			}
			_historyStack.push(command);
			// Executes the command
			stepForward();
			return currentPosition;
		}
		
		public function get currentCommand():IUndoableCommand {
			return _historyStack[currentPosition - 1];
		}
	}
}