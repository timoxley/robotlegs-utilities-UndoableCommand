package org.robotlegs.utilities.undoablecommand
{
	import flash.events.Event;
	
	import org.robotlegs.utilities.undoablecommand.interfaces.IUndoableCommand;
	
	/**
	 * CommandEvents are fired when single commands finish executing, finish undoing or are cancelled.
	 * 
	 */
	public class CommandEvent extends Event
	{
		/**
		 * CommandEvent of this type will be fired when a command has completed executing/redoing.
		 */
		public static const EXECUTE_COMPLETE:String = "executeComplete";
		
		/**
		 * CommandEvent of this type will be fired when a command has completed undoing.
		 */
		public static const UNDO_EXECUTE_COMPLETE:String = "undoExecuteComplete";
		
		/**
		 * CommandEvent of this type will be fired when execution of a command was cancelled.
		 */
		public static const CANCELLED:String = "executeCancelled";
		
		/**
		 * The command associated with the event.
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