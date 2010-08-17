package org.robotlegs.utilities.undoablecommand
{
	import flash.events.IEventDispatcher;
	
	import org.robotlegs.utilities.undoablecommand.interfaces.*;
	
	/**
	 * Provides an interface to manage undo/redo history and fires events on the eventDispatcher 
	 * when history events occur. 
	 */
	public class CommandHistory
	{		
		/**
		 * Command history data store.
		 * Vector chosen over array for strong typing & speed
		 */
		private var _historyStack:Vector.<IUndoableCommand>;
		
		/**
		 * Pointer to the current command in the history stack.
		 * First command starts at index 1.
		 * If this is 0, we are pointing to no command (null) at the start of the stack
		 */
		public var currentPosition:uint;
		
		/**
		 * Supplied event bus to fire events upon.
		 */
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		public function CommandHistory() {
			_historyStack = new Vector.<IUndoableCommand>();
			currentPosition = 0;
		}
		
		/** 
		 * True if there's a command to redo.
		 * @return true if there's a command to redo
		 */
		public function get canStepForward():Boolean {
			return (currentPosition < numberOfHistoryItems);
		}
		
		/** 
		 * True if there's a command to undo.
		 * @return true if there's a command to undo
		 */
		public function get canStepBackward():Boolean {
			return (currentPosition > 0);
		}
		
		/** 
		 * 
		 * Redo/execute the next command on the history stack.
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
		 * Undo the previous command on the history stack and set the currentCommand to the previous command.
		 * @return position in history stack after this operation
		 */
		public function stepBackward():uint {
			var storeCurrentPosition:uint = currentPosition;
			if (canStepBackward) {
				// This is a hacky workaround:
				// If the undo was invoked from a CommandHistory object,
				// _historyStack[currentPosition - 1].undo() calls
				// stepBackward() again, in which case we want to prevent it from
				// updating the current position twice. I'm certain thar be a better way.
				// Update 6 months later: I have no idea what I'm talking about here.
				// I recall this whole business produced some fairly retarded program flow, 
				// need to rethink design.
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
		 * Undo all or some number of commands.
		 * @param numTimes number of positions to move backward. The default, 0, rewinds to the start of the history (undoes all commands)
		 * @return position in history stack after the rewind operation completes
		 */
		public function rewind(numTimes:uint = 0):uint {
			var positionToMoveTo:uint;
			
			if (numTimes == 0) {
				positionToMoveTo = 0;
			} else {
				positionToMoveTo = currentPosition - numTimes;
			}
			
			// Move backward while possible
			while(canStepBackward && currentPosition != positionToMoveTo) {
				stepBackward();
			}
			
			this.eventDispatcher.dispatchEvent(new HistoryEvent(HistoryEvent.REWIND_COMPLETE, currentCommand));
			return currentPosition;
		}
		
		/** 
		 * Redo all or some number of commands.
		 * @param numTimes number of positions to move forward. 
		 * The default, 0, fast forwards to the last item in the history (most recent).
		 * @return position in history stack after the fastForward operation completes
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
		 * Total number of items in history, irrespective of their undone/redone state. 
		 * @return total number of items in history
		 */
		public function get numberOfHistoryItems():uint {
			return _historyStack.length;
		}
		
		/** 
		 * Push a new command into the current position on the history stack and execute it.
		 * If there are commands further forward in the history stack,  
		 * those commands are removed and this command becomes the
		 * new top of the command stack.
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
		 * Gets the command at the top of the history stack. This command will have already been executed.
		 * @return command at the current position in the history stack,
		 * or null if we're at position 0, in this case, there may be no commands on the stack at all.
		 * @see currentPosition
		 * @see numberOfHistoryItems
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