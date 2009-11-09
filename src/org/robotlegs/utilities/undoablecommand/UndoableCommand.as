package org.robotlegs.utilities.undoablecommand
{
	import flash.events.EventDispatcher;
	
	import org.robotlegs.utilities.undoablecommand.interfaces.IUndoableCommand;
		
	public class UndoableCommand extends EventDispatcher implements IUndoableCommand
	{
		/**
		 * Keeps track of whether this command has been executed,
		 * to prevent undoing actions that have not been done.
		 */
		private var hasExecuted:Boolean;
		
		private var doFunction:Function;
		private var undoFunction:Function;
		
		/**
		 * Creates a new UndoableCommand
		 * @param doFunction the function to execute
		 * @param undoFunction execute this function to undo the operations of doFunction
		 * @param autoExecute automatically executes this command on creation. Be careful when setting this false
		 */
		public function UndoableCommand(doFunction:Function = null, undoFunction:Function = null, autoExecute:Boolean = true) {
			// set function defaults
			if (doFunction is Function) {
				this.doFunction = doFunction;
			} else {
				this.doFunction = doExecute;
			}
			
			if (undoFunction is Function) {
				this.undoFunction = undoFunction;
			} else {
				this.undoFunction = undoExecute;
			}
			if (autoExecute) {
				this.execute();
			}
		}
		
		/**
		 * Executes the command.
		 * If we passed in an execute function to the constructor,
		 * execute passed-in function, otherwise execute overriden
		 * doExecute function
		 */
		public final function execute():void {
			if (!hasExecuted) {
				doFunction();
				hasExecuted = true;
			}
		}
		
		/**
		 * Executes the undocommand.
		 * If we passed in an undo function to the constructor,
		 * execute passed-in undo function, otherwise execute overriden
		 * undoExecute function
		 */
		public final function undo():void {
			if (hasExecuted) {
				undoFunction();
				hasExecuted = false;
			}
		}	
		
		/**
		 * Subclasses must override this function.
		 */
		protected function doExecute():void {
			throw new Error("Cannot call doExecute on super. " +
				"Subclasses must override doExecute");
		}
		
		/**
		 * Subclasses must override this function.
		 */
		protected function undoExecute():void {
			throw new Error("Cannot call undoExecute on super. " +
				"Subclasses must override undoExecute");

		}
	}
}