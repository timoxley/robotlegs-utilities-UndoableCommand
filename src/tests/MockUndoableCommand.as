package tests
{
	import flash.events.EventDispatcher;
	
	import org.robotlegs.utilities.undoablecommand.UndoableCommand;
	import org.robotlegs.utilities.undoablecommand.interfaces.IUndoableCommand;
	
	/**
	 * @private
	 */
	public class MockUndoableCommand extends UndoableCommand implements IUndoableCommand
	{
		static public var testArray:Array;
		
		public function MockUndoableCommand() {
			eventDispatcher = new EventDispatcher();
			super(null, null);
		}
		
		/**
		 * Cause damage to the array
		 */
		override protected function doExecute():void {
			
			trace("Do");
			MockUndoableCommand.testArray.push(new Object());
		}
		
		/**
		 * Undo the damage on the array
		 */
		override protected function undoExecute():void {
			trace("Undo");
			MockUndoableCommand.testArray.pop();
		}
	}
}