package tests {
	import org.robotlegs.utilities.undoablecommand.UndoableCommand;
	
	
	/**
	 * @private
	 */
	public class MockManagedUndoableCommand extends UndoableCommand {
		
		/**
		 * Reference to some array to be tested on.
		 */
		public var testArray:Array;
		public var shouldCancel:Boolean = false;
		/**
		 * Cause change to the array
		 */
		override protected function doExecute():void {
			if (shouldCancel) {
				cancel();
				return;
			}
			this.testArray.push(new Object());
			super.doExecute();
		}
		
		/**
		 * Undo the change on the array
		 */
		override protected function undoExecute():void {
			// pop() isn't the best undo is it
			// will do for now
			this.testArray.pop();
			super.undoExecute();
		}
	}
}