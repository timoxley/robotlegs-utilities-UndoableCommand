package org.robotlegs.utilities.undoablecommand
{
	import org.robotlegs.utilities.undoablecommand.interfaces.IUndoableCommand;

	public class HistoryEvent extends CommandEvent
	{
		/**
		 * Defines the value of the type property of a stepBackward event object.
		 * Map this event to StepBackwardCommand to trigger an undo action.
		 */
		public static const STEP_BACKWARD:String = "stepBackward";
		/**
		 * Defines the value of the type property of a stepforward event object.
		 * Map this event to StepForwardCommand to trigger a redo action.
		 */
		public static const STEP_FORWARD:String = "stepForward";
		
		/**
		 * Defines the value of the type property of a stepForwardComplete event object.
		 */
		public static const STEP_FORWARD_COMPLETE:String = "stepForwardComplete";
		
		/**
		 * Defines the value of the type property of a stepBackwardComplete event object.
		 */
		public static const STEP_BACKWARD_COMPLETE:String = "stepBackwardComplete";
		
		/**
		 * Defines the value of the type property of a rewind event object.
		 */
		public static const REWIND:String = "rewind";
		/**
		 * Defines the value of the type property of a fastForward event object.
		 */
		public static const FAST_FORWARD:String = "fastForwardHistory";
		
		/**
		 * Defines the value of the type property of a rewindComplete event object.
		 */
		public static const REWIND_COMPLETE:String = "rewindComplete";
		/**
		 * Defines the value of the type property of an fastForwardComplete event object.
		 */
		public static const FAST_FORWARD_COMPLETE:String = "fastForwardComplete";
		
		public function HistoryEvent(type:String, command:IUndoableCommand = null) {
			super(type, command);
		}
	}
}