package org.robotlegs.utilities.undoablecommand
{
	import org.robotlegs.utilities.undoablecommand.interfaces.IUndoableCommand;
		
	public class UndoableCommand implements IUndoableCommand
	{
		public function UndoableCommand(autoExecute:Boolean = false) {
			//TODO: implement function
		}
		
		public function execute():void {
			trace("DOING");
		}
		
		public function undo():void {
			trace("UNDO");
		}	
	}
}