package org.robotlegs.utilities.undoablecommand.commands
{
	import org.robotlegs.utilities.undoablecommand.CommandHistory;

	
	/**
	 * Map this command to HistoryEvent.STEP_BACKWARD to trigger an undo action.
	 */
	public class StepBackwardCommand
	{
		[Inject]
		public var commandHistory:CommandHistory;
		
		public function StepBackwardCommand() {
			
		}
		
		public function execute():void {
			commandHistory.stepBackward();
		}
	}
}