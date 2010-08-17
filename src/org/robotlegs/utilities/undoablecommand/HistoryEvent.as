package org.robotlegs.utilities.undoablecommand
{
	import org.robotlegs.utilities.undoablecommand.interfaces.IUndoableCommand;

	/**
	 * These events fire when operations occur on a CommandHistory object, or to control a CommandHistory object.
	 */
	public class HistoryEvent extends CommandEvent
	{
		/**
		 * You should Map this event to StepBackwardCommand to trigger an undo action.
		 * Provided for convenience. Is not fired internally.
		 * <code>		 
		 *     // In your Robotlegs context:
		 *     commandMap.mapEvent(HistoryEvent.STEP_BACKWARD, StepBackwardCommand, HistoryEvent);
		 * </code>
		 */
		public static const STEP_BACKWARD:String = "stepBackward";
		
		/**
		 * You should map this event to a StepForwardCommand to trigger a redo action.
		 * Provided for convenience. Is not fired internally.
		 * <code>
		 *     // In your Robotlegs context:
		 *     commandMap.mapEvent(HistoryEvent.STEP_FORWARD, StepForwardCommand, HistoryEvent); 
		 * </code>
		 */
		public static const STEP_FORWARD:String = "stepForward";
		
		
		/**
		 * You should map this event to a command to trigger a rewind action.
		 * 
		 * Provided for convenience. Is not fired internally.
		 * TODO: Create a default RewindCommand
		 */
		public static const REWIND:String = "rewind";
		
		/**
		 * You should map this event to a command to trigger a fast-forward action.
		 * 
		 * Provided for convenience. Is not fired internally.
		 * TODO: Create a default FastForwardCommand
		 */
		public static const FAST_FORWARD:String = "fastForward";
		
		/**
		 * HistoryEvent with this type will be fired each time a command is executed/redone. 
		 * HistoryEvent with this type will be fired multiple times if performing a multi-step fast-forward.
		 */
		public static const STEP_FORWARD_COMPLETE:String = "stepForwardComplete";
		
		/**
		 * HistoryEvent with this type will be fired each time a command is undone.
		 * HistoryEvent with this type will be fired multiple times if performing a multi-step rewind.
		 */
		public static const STEP_BACKWARD_COMPLETE:String = "stepBackwardComplete";
		

		
		/**
		 * HistoryEvent with this type will be fired when a rewind completes.
		 */
		public static const REWIND_COMPLETE:String = "rewindComplete";
		
		/**
		 * HistoryEvent with this type will be fired when a fast forward completes.
		 */
		public static const FAST_FORWARD_COMPLETE:String = "fastForwardComplete";
		
		public function HistoryEvent(type:String, command:IUndoableCommand = null) {
			super(type, command);
		}
	}
}