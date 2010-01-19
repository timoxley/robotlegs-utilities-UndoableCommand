package tests
{
	import flash.events.EventDispatcher;
	
	import org.robotlegs.utilities.undoablecommand.LinkedUndoableCommand;
	
	public class MockLinkedUndoableCommand extends LinkedUndoableCommand
	{
		public function MockLinkedUndoableCommand(doFunction:Function=null, undoFunction:Function=null)
		{
			eventDispatcher = new EventDispatcher();
			super(null, null);
		}
		
		public var testArray:Array;
		
		/**
		 * Cause damage to the array
		 */
		override protected function doExecute():Boolean {
			testArray.push(new Object());
			return super.doExecute();
		}
		
		/**
		 * Undo the damage on the array
		 */
		override protected function undoExecute():Boolean {
			testArray.pop();
			return super.undoExecute();
		}
	}
}