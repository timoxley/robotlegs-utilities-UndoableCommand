package org.robotlegs.utilities.undoablecommand.commands
{
	import org.robotlegs.utilities.undoablecommand.CommandHistory;

	
	/**
	 * Map this command to the HistoryEvent.STEP_BACKWARD event to trigger an undo action.
	 * Provided for convenience.
	 */
	public class StepBackwardCommand
	{
		[Inject]
		public var commandHistory:CommandHistory;
		
		/**
		 * Will undo a single command, if possible. Fails silently if not.
		 */
		public function execute():void {
			commandHistory.stepBackward();
		}
	}
}