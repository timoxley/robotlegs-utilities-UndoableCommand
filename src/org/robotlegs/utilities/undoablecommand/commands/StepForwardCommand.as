package org.robotlegs.utilities.undoablecommand.commands
{
	import org.robotlegs.utilities.undoablecommand.CommandHistory;
	
	/**
	 * Map this command to the HistoryEvent.STEP_FORWARD event to trigger a redo action.
	 * Provided for convenience.
	 */
	public class StepForwardCommand
	{
		[Inject]
		public var commandHistory:CommandHistory;
		
		/**
		 * Will redo a single command, if possible. Fails silently if not.
		 */
		public function execute():void {
			commandHistory.stepForward();
		}
	}
}