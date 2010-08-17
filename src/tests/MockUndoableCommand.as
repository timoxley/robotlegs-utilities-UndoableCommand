package tests
{
	import flash.events.EventDispatcher;
	
	import org.robotlegs.utilities.undoablecommand.UndoableCommandBase;
	import org.robotlegs.utilities.undoablecommand.interfaces.IUndoableCommand;
	
	/**
	 * @private
	 */
	public class MockUndoableCommand extends UndoableCommandBase implements IUndoableCommand
	{
		public static var testArray:Array = new Array();
		
		public function MockUndoableCommand() {
			eventDispatcher = new EventDispatcher();
			super();
		}
		
		/**
		 * Cause damage to the array
		 */
		override protected function doExecute():void {
			
			trace("Do ta:" + testArray);
			testArray.push(new Object());
			super.doExecute();
		}
		
		/**
		 * Undo the damage on the array
		 */
		override protected function undoExecute():void {
			trace("Undo ta:" + testArray);
			testArray.pop();
			super.undoExecute();
		}
	}
}