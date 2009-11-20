package org.robotlegs.utilities.undoablecommand.commands
{
	import org.robotlegs.utilities.undoablecommand.CommandHistory;
	
	/**
	 * Map this command to HistoryEvent.STEP_FORWARD to trigger a redo action.
	 */
	public class StepForwardCommand
	{
		[Inject]
		public var commandHistory:CommandHistory;
		
		public function StepForwardCommand() {
			
		}
		
		public function execute():void {
			commandHistory.stepForward();
		}
	}
}