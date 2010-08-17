package org.robotlegs.utilities.undoablecommand
{
	import flash.events.Event;
	
	import org.robotlegs.utilities.undoablecommand.interfaces.IUndoableCommand;
	
	/**
	 * CommandEvents occur when commands finish executing or undoing
	 * 
	 */
	public class CommandEvent extends Event
	{
		/**
		 * Defines the value of the type property of an executeComplete event object.
		 */
		public static const EXECUTE_COMPLETE:String = "executeComplete";
		/**
		 * Defines the value of the type property of an undoExecuteComplete event object.
		 */
		public static const UNDO_EXECUTE_COMPLETE:String = "undoExecuteComplete";
		
		public static const CANCELLED:String = "executeCancelled";
		/**
		 * The command associated with the event
		 */
		public var command:IUndoableCommand;
		
		/**
		 * @param type The type of event
		 * @param command The command associated with the event
		 */
		public function CommandEvent(type:String, command:IUndoableCommand) {
			super(type, false, false);
			this.command = command;
		}
	}
}