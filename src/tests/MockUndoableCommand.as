package tests
{
	import org.robotlegs.utilities.undoablecommand.UndoableCommand;
	import org.robotlegs.utilities.undoablecommand.interfaces.IUndoableCommand;
	
	public class MockUndoableCommand extends UndoableCommand implements IUndoableCommand
	{
		private var testArray:Array;
		
		public function MockUndoableCommand(testArray:Array = null) {
			super(null, null, false);
			if (testArray) {
				this.testArray = testArray;
			} else {
				this.testArray = new Array();
			}
			this.execute();
			
		}
		
		/**
		 * Cause damage to the array
		 */
		override protected function doExecute():void {
			trace("Do");
			this.testArray.push(new Object());
		}
		
		/**
		 * Undo the damage on the array
		 */
		override protected function undoExecute():void {
			trace("Undo");
			this.testArray.pop();
		}
	}
}