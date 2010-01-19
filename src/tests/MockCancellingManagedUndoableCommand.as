package tests
{
	import org.robotlegs.utilities.undoablecommand.ManagedUndoableCommand;
	
	/**
	 * @private
	 */
	public class MockCancellingManagedUndoableCommand extends ManagedUndoableCommand
	{
		
		/**
		 * Reference to some array to be tested on. 
		 */
		public var testArray:Array = new Array();
		public var testObject:Object = new Object();;
		
		/**
		 * Cause change to the array
		 */
		override protected function doExecute():Boolean {
			cancel();
			this.testArray.push(testObject);
			return super.doExecute();
		}
		
		/**
		 * Undo the change on the array
		 */
		override protected function undoExecute():Boolean {

			// pop() isn't the best undo is it?
			// will do for now
			this.testArray.pop();
			
			return super.undoExecute();
		}
	}
}