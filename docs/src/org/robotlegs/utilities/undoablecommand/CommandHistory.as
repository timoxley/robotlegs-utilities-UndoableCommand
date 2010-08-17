package org.robotlegs.utilities.undoablecommand
{
	import flash.events.IEventDispatcher;
	
	import org.robotlegs.utilities.undoablecommand.interfaces.*;
	
	public class CommandHistory
	{		
		/**
		 * Command history data store.
		 * Vector chosen over array for strongtyping & speed
		 */
		private var _historyStack:Vector.<IUndoableCommand>;
		
		/**
		 * Pointer to the current command in the history stack
		 * Index starts at 1.
		 * If this is 0, we are pointing to null at the start of the stack
		 */
		public var currentPosition:uint;
		
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
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
				_historyStack[currentPosition].execute();
				currentPosition++;
			}
			this.eventDispatcher.dispatchEvent(new HistoryEvent(HistoryEvent.STEP_FORWARD_COMPLETE, currentCommand));

			return currentPosition;
		}
		
		/** 
		 * Move backward through the history stack
		 * i.e. undo the previous command on the history stack
		 * @return position in history stack after this operation
		 */
		public function stepBackward():uint {
			var storeCurrentPosition:uint = currentPosition;
			if (canStepBackward) {
				// Hacky workaround:
				// if undo was invoked from a commandHistory object,
				// _historyStack[currentPosition - 1].undo() calls
				// stepBackward() again (), in which case we want to prevent it from
				// updating the current position twice. I'm certain thar be a better way.
				_historyStack[currentPosition - 1].undo();
				currentPosition = storeCurrentPosition - 1;
			}
			
			// If there's no undone command, 
			// dispatch null as the historyevent command
			var undoneCommand:IUndoableCommand;
			if (_historyStack.length > 0 && currentPosition != 0) {
				//the undone command
				undoneCommand = _historyStack[currentPosition];
			} else {
				undoneCommand = null;
			}

			this.eventDispatcher.dispatchEvent(new HistoryEvent(HistoryEvent.STEP_BACKWARD_COMPLETE, undoneCommand));

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
			
			// Move backward
			while(canStepBackward && currentPosition != positionToMoveTo) {
				stepBackward();
			}
			
			this.eventDispatcher.dispatchEvent(new HistoryEvent(HistoryEvent.REWIND_COMPLETE, currentCommand));
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
			
			// Move forward
			while(canStepForward && currentPosition != positionToMoveTo) {
				stepForward();
			}
			
			this.eventDispatcher.dispatchEvent(new HistoryEvent(HistoryEvent.FAST_FORWARD_COMPLETE, currentCommand));
			
			return currentPosition;
		}
		
		/** 
		 * @return total number of items in history, 
		 * irrespective of whether they have been undone
		 */
		public function get numberOfHistoryItems():uint {
			return _historyStack.length;
		}
		
		/** 
		 * Push a command onto the history stack
		 * If there are commands that are yet to be redone,  
		 * those commands are lost and this command becomes
		 * the top of the command stack.
		 * 
		 * @return position in history stack after this operation
		 */
		public function push(command:IUndoableCommand):uint {
			
			if (currentPosition != numberOfHistoryItems) {
				_historyStack = _historyStack.slice(0, currentPosition);	
			}
			_historyStack.push(command);
			
			// Execute the command & move pointer forward
			stepForward();
			return currentPosition;
		}
		
		/**
		 * @return command at the current position in the history stack,
		 * or null if we're at position 0, or there are simply no commands
		 * @see currentPosition
		 */
		public function get currentCommand():IUndoableCommand {
			if (_historyStack.length == 0 || currentPosition == 0) {
				return null;
			}
			return _historyStack[currentPosition - 1];
		}
		
		/**
		 * @private
		 */
		public function toString():String {
			var output:String = "";
			var count:uint = 0;
			for each(var command:IUndoableCommand in _historyStack) {
				output += String(count) + String(command) + "\n";
				count++;
			}
			return output;
		}
	}
}