package tests
{
	import flash.display.DisplayObjectContainer;
	
	import flexunit.framework.Assert;
	
	import org.robotlegs.utilities.undoablecommand.CommandHistory;
	import org.swiftsuspenders.Injector;
	
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
		private var injector:Injector;
		private var history:CommandHistory;
		
		[Before]
		public function setupTests():void {
			testArray = new Array();
			history = new CommandHistory();
			_managedUndoableCommand = new MockManagedUndoableCommand();
			_managedUndoableCommand.testArray = testArray;
			_managedUndoableCommand.history = history;
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
			_managedUndoableCommand.execute();
			Assert.assertEquals(testArray.length, 1);
		}
		
		[Test]
		public function testUndo():void {
			_managedUndoableCommand.execute();
			Assert.assertEquals(testArray.length, 1);
			_managedUndoableCommand.undo();
			Assert.assertEquals(testArray.length, 0);
		}
		
		[Test]
		public function testExecuteMultiple():void {
			_managedUndoableCommand.execute();	
			_managedUndoableCommand.execute();
			_managedUndoableCommand.execute();
			Assert.assertEquals(testArray.length, 1);
			
		}
		
		[Test]
		public function testUndoMultiple():void {
			_managedUndoableCommand.execute();	
			_managedUndoableCommand.undo();
			_managedUndoableCommand.undo();
			_managedUndoableCommand.undo();
			Assert.assertEquals(testArray.length, 0);
		}
		
		[Test]
		public function testUndoNothingToUndo():void {
			_managedUndoableCommand.undo();
			Assert.assertEquals(testArray.length, 0);
		}
		
		[Test]
		public function testDefaultFunctions():void {
			var command:MockManagedUndoableCommand = new MockManagedUndoableCommand();//MockManagedUndoableCommand(injector.instantiate(MockManagedUndoableCommand));
			command.testArray = testArray;
			command.history = history;
			command.execute();	
			Assert.assertEquals(testArray.length, 1);
			command.undo();	
			Assert.assertEquals(testArray.length, 0);
		}
	}
}