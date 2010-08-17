package org.robotlegs.utilities.undoablecommand
{
	import mx.messaging.messages.ErrorMessage;
	
	/**
	 * This command handles adding itself to the provided/injected CommandHistory.
	 * 
	 * UndoableCommands are pushed to the CommandHistory only once the Command has been executed, 
	 * and are removed once the Command has been undone. Undoable commands can be cancelled by calling cancel() from within
	 * their doExecute() function, and they will not be added to the history.
	 * 
	 * All functions assume the CommandHistory dependency has been provided as the public property 'history'.
	 */
	public class UndoableCommand extends UndoableCommandBase
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
		
		protected var isCancelled:Boolean = false;
		
		/**
		 * Reference to the CommandHistory being used by this Command
		 */
		[Inject]
		public var history:CommandHistory;
		
		/**
		 * @inheritDoc 
		 */
		public function UndoableCommand(doFunction:Function = null, undoFunction:Function = null) {
			super(doFunction, undoFunction);
		}
		
		/**
		 * Call this function in your doExecute method to prevent this item from being added to the history stack.
		 * TODO: Throw an error if cancelling within a redo. Currently assumes if the cancel condition did not fire
		 * on the first run, they will pass on subsequent executions. This is faulty.
		 */
		public function cancel():void {
			isCancelled = true;
		}
		
		/**
		 * Executes the command.
		 * Override this function in your subclasses to implement your command's actions.
		 * You may call cancel() at any point in this function to prevent it from being added 
		 * to the history stack, but remember that execution does not stop when you call cancel and
		 * you will need to ensure the doExecute method did not actually make any changes.
		 * 
		 * Ensure you call super.doExecute() at the end of your subclassed method.
		 * Note command is only automatically pushed to history once we try to execute this command
		 * @inheritDoc
		 * @see undoExecute
		 */
		override protected function doExecute():void {
			// Only push to history once we actually try to execute this command
			if (!hasRegisteredWithHistory && !isCancelled) {
				hasRegisteredWithHistory = true;
				hasExecuted = true;
				history.push(this);
			}
			super.doExecute();
		}
		
		/**
		 * Override this function in your subclasses to implement the undo of the actions performed in doExecute(). Ensure you call super.undoExecute() at the end of your subclassed method.
		 * @inheritDoc
		 * @see doExecute
		 * @throws Error Prevents history corruption by throwing error if trying to undo this command and it's not at the top of the history (i.e. next to be undone). 
		 */
		override protected function undoExecute():void {
			if (hasExecuted) {
				this.hasExecuted = false;
				
				if (!hasSteppedBack) {
					hasSteppedBack = true;
					if (history.currentCommand != this) {
						throw new Error("Cannot undo command unless this command is first in command history!");
					}
					
					history.stepBackward();
					hasSteppedBack = false;
				}
				
			}
			if (isCancelled) {
				throw new Error("Trying to undo a cancelled command!");
			}
			super.undoExecute();
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