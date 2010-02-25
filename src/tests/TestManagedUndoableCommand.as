package tests
{
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	
	import flexunit.framework.Assert;
	
	import org.robotlegs.utilities.undoablecommand.CommandHistory;

	
	/**
	 * @private
	 */
	public class TestManagedUndoableCommand
	{
		// Reference declaration for class to test
		private var _managedUndoableCommand:MockManagedUndoableCommand;
		
		public function TestManagedUndoableCommand()
		{
		}
		
		private var testArray:Array;
		private var contextView:DisplayObjectContainer;
		
		private var history:CommandHistory;
		private var eventBus:EventDispatcher;
		
		[Before]
		public function setupTests():void {
			eventBus = new EventDispatcher();
			testArray = new Array();
			history = new CommandHistory();
			history.eventDispatcher = eventBus;
			_managedUndoableCommand = createCommand();
		}
		
		private function createCommand():MockManagedUndoableCommand {
			var newCommand:MockManagedUndoableCommand = new MockManagedUndoableCommand();
			newCommand.testArray = testArray;
			newCommand.history = history;
			newCommand.eventDispatcher = eventBus;
			
			return newCommand;
		}
		
		[After]
		public function reset():void {
			testArray = null;
			_managedUndoableCommand = null;
			history = null;
		}
		
		[Test]
		public function testInitialisation():void {
			Assert.assertNotNull(_managedUndoableCommand);
			Assert.assertNotNull(testArray);
		}
		
		[Test]
		public function testExecute():void {
			Assert.assertEquals(0, testArray.length);
			_managedUndoableCommand.execute();
			Assert.assertEquals(1, testArray.length);
		}
		
		[Test]
		public function testUndo():void {
			_managedUndoableCommand.execute();
			Assert.assertEquals(1, testArray.length);
			_managedUndoableCommand.undo();
			Assert.assertEquals(0, testArray.length);
		}
		
		[Test]
		public function testExecuteMultiple():void {
			_managedUndoableCommand.execute();	
			_managedUndoableCommand.execute();
			_managedUndoableCommand.execute();
			Assert.assertEquals(1, testArray.length);
			
		}
		
		[Test]
		public function testUndoMultiple():void {
			_managedUndoableCommand.execute();	
			Assert.assertEquals(1, testArray.length);
			_managedUndoableCommand.undo();
			_managedUndoableCommand.undo();
			_managedUndoableCommand.undo();
			Assert.assertEquals(0, testArray.length);
		}
		
		[Test]
		public function testUndoNothingToUndo():void {
			_managedUndoableCommand.undo();
			Assert.assertEquals(0, testArray.length);
		}
		
		[Test]
		public function testDefaultFunctions():void {
			var command:MockManagedUndoableCommand = createCommand();/// = new MockManagedUndoableCommand();
			
			command.testArray = testArray;
			command.history = history;
			command.execute();	
			Assert.assertEquals(1, testArray.length);
			command.undo();	
			Assert.assertEquals(0, testArray.length);
		}
		
		[Test]
		// Test forward/back/position settings while
		// moving backwards & forwards
		public function testGetCurrentCommand():void {
			Assert.assertNull(history.currentCommand);
			Assert.assertEquals(0, history.currentPosition);
			
			var appleCommand:MockManagedUndoableCommand = createCommand();
			
			var bananaCommand:MockManagedUndoableCommand = createCommand();
			
			var pineappleCommand:MockManagedUndoableCommand = createCommand();
			
			/*_testHistory.push(appleCommand);
			_testHistory.push(bananaCommand);
			_testHistory.push(pineappleCommand);*/
			
			appleCommand.execute();
			bananaCommand.execute();
			pineappleCommand.execute();
			
			Assert.assertEquals(pineappleCommand, history.currentCommand);
			history.stepBackward();
			Assert.assertEquals(bananaCommand, history.currentCommand);
			history.stepForward();
			Assert.assertEquals(pineappleCommand, history.currentCommand);
			history.stepBackward();
			history.stepBackward();
			Assert.assertEquals(appleCommand, history.currentCommand);
		}
		
		[Test]
		// Test forward/back/position settings while
		// moving backwards & forwards
		public function testAddToHistory():void {
			var appleCommand:MockManagedUndoableCommand = createCommand();
			Assert.assertNull(history.currentCommand);
			appleCommand.execute();
			Assert.assertEquals(appleCommand, history.currentCommand);
			Assert.assertEquals(1, testArray.length);
		}
		
		[Test]
		// Test forward/back/position settings while
		// moving backwards & forwards
		public function testCommandUndo():void {
			var appleCommand:MockManagedUndoableCommand = createCommand();
			Assert.assertNull(history.currentCommand);
			appleCommand.execute();
			
			Assert.assertEquals(appleCommand, history.currentCommand);
			Assert.assertEquals(1, testArray.length);
			appleCommand.undo();
			Assert.assertNull(history.currentCommand);
			Assert.assertEquals(0, testArray.length);
			
		}
		
		[Test]
		// Test forward/back/position settings while
		// moving backwards & forwards
		public function testHistoryUndo():void {
			var appleCommand:MockManagedUndoableCommand = createCommand();
			Assert.assertNull(history.currentCommand);
			appleCommand.execute();
			Assert.assertEquals(1, testArray.length);
			Assert.assertEquals(appleCommand, history.currentCommand);
			Assert.assertEquals(1, history.currentPosition);
			history.stepBackward();
			Assert.assertEquals(0, history.currentPosition);
			Assert.assertNull(history.currentCommand);
			Assert.assertEquals(0, testArray.length);
			history.stepForward();
			Assert.assertEquals(1, testArray.length);
			Assert.assertEquals(appleCommand, history.currentCommand);
			Assert.assertEquals(1, history.currentPosition);
		}
		
		[Test]
		// Test cancelling the command
		public function testCancellingDoesNothing():void {
			var appleCommand:MockManagedUndoableCommand = createCommand();
			appleCommand.shouldCancel = true;
			appleCommand.execute();
			//Make sure nothing actually happened
			Assert.assertEquals(0, history.currentPosition);
			Assert.assertNull(history.currentCommand);
			Assert.assertEquals(0, testArray.length);
		
		}
		
		[Test(expects="Error")]
		// Test trying to undo a cancelled command throws an error
		public function testUndoingACancelledCommandErrors():void {
			var appleCommand:MockManagedUndoableCommand = createCommand();
			appleCommand.shouldCancel = true;
			appleCommand.execute();
			appleCommand.undo();
		}
	}
}