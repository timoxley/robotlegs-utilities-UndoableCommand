package org.robotlegs.utilities.undoablecommand
{
	
	/**
	 * This command handles it's own history when provided/injected with a CommandHistory object
	 * All functions assume the CommandHistory dependency (history) has been provided
	 * Command is only pushed to the CommandHistory when Command is executed.
	 */
	public class ManagedUndoableCommand extends UndoableCommand
	{
		/**
		 * @private
		 * Flag true after this Command has been pushed to CommandHistory
		 */
		private var hasRegisteredWithHistory:Boolean;	
		
		/**
		 * Reference to the CommandHistory being used by this Command
		 */
		[Inject]
		public var history:CommandHistory;
		
		/**
		 * @inheritDoc 
		 */
		public function ManagedUndoableCommand(autoExecute:Boolean = true, doFunction:Function = null, undoFunction:Function = null) {
			super(autoExecute, doFunction, undoFunction);
			
		}
		
		/**
		 * @throws Error if this Command is not on the top of the history stack. Prevents calling execute Commands out of CommandHistory order
		 * @inheritDoc
		 */
		override protected function doExecute():void {
			// Only push to history once we actually try to execute this command
			registerIfRequired()
			
			if (history.currentCommand !== this) {
				throw new Error("Cannot execute command unless command is first in command history");
			}
			
			
		}
		
		/**
		 * @throws Error If this Command is not on the top of the history stack. Prevents undoing Commands out of order
		 * @inheritDoc
		 */
		override protected function undoExecute():void {
			if (history.currentCommand != this) {
				throw new Error("Cannot undo command unless command is first in command history");
			}
			history.stepBackward();
		}
		
		/**
		 * @private
		 * Checks if this command has added itself to the command history.
		 * Ensures we don't let this Command push to the CommandHistory more than once.
		 */
		private function registerIfRequired():void {
			if (!hasRegisteredWithHistory) {
				history.push(this);
				hasRegisteredWithHistory = true;
			}
		}
	}
}