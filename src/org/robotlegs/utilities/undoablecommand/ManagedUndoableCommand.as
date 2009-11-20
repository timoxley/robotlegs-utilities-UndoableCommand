package org.robotlegs.utilities.undoablecommand
{
	
	/**
	 * This command handles its own history when provided/injected with a CommandHistory object
	 * All functions assume the CommandHistory dependency (history) has been provided
	 * Command is only pushed to the CommandHistory when Command is executed.
	 * 
	 */
	public class ManagedUndoableCommand extends UndoableCommand
	{
		/**
		 * @private
		 * Flag true after this Command has been pushed to CommandHistory
		 */
		private var hasRegisteredWithHistory:Boolean;	
		
		/**
		 * @private
		 * Flag true after this Command has been stepped back by CommandHistory
		 */
		private var hasSteppedBack:Boolean;
		/**
		 * Reference to the CommandHistory being used by this Command
		 */
		[Inject]
		public var history:CommandHistory;
		
		/**
		 * @inheritDoc 
		 */
		public function ManagedUndoableCommand(doFunction:Function = null, undoFunction:Function = null) {
			super(doFunction, undoFunction);
		}
		
		/**
		 * Executes the command.
		 * Override this function in your subclasses to implement your command's actions.
		 * Note command is only automatically pushed to history once we try to execute this command
		 * @inheritDoc
		 * @see undoExecute
		 */
		override protected function doExecute():void {
			// Only push to history once we actually try to execute this command
			if (!hasRegisteredWithHistory) {
				hasRegisteredWithHistory = true;
				hasExecuted = true;
				history.push(this);
			}
		}
		
		/**
		 * Override this function in your subclasses to implement the undo of the actions performed in doExecute().
		 * @inheritDoc
		 * @see doExecute
		 */
		override protected function undoExecute() : void {
			if (hasExecuted) {
				this.hasExecuted = false;
				
				if (!hasSteppedBack) {
					hasSteppedBack = true;
					if (history.currentCommand != this) {
						throw new Error("Cannot undo command unless command is first in command history");
					}
					
					history.stepBackward();
					hasSteppedBack = false;
				}
			}
		}
		
		/**
		 * @private
		 * Checks if this command has added itself to the command history.
		 * Ensures we don't let this Command push to the CommandHistory more than once.
		 */
		private function registerIfRequired():void {
			if (!hasRegisteredWithHistory) {
				hasRegisteredWithHistory = true;
				history.push(this);
			}
		}
	}
}