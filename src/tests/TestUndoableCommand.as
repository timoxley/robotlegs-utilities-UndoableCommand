package tests
{
	import flash.events.EventDispatcher;
	
	import flexunit.framework.Assert;
	
	import org.robotlegs.utilities.undoablecommand.UndoableCommand;
	
	/**
	 * @private
	 */
	public class TestUndoableCommand
	{
		// Reference declaration for class to test
		private var _undoableCommand:UndoableCommand;
		
		private var testArray:Array;
		private var testObject:Object;
		private var eventBus:EventDispatcher;
		
		private function doStuff():void {
			testArray.push(testObject);
		}
		
		private function undoStuff():void {
			testArray.pop();
		}
		
		[Before]
		public function setupTests():void {
			testArray = new Array();
			eventBus = new EventDispatcher();
			_undoableCommand = new UndoableCommand(doStuff, undoStuff);
			_undoableCommand.eventDispatcher = eventBus;
		}
		
		[After]
		public function reset():void {
			_undoableCommand = null;
			testArray = null;
			eventBus = null;
		}
		
		[Test]
		public function testInitialisation():void {
			Assert.assertNotNull(_undoableCommand);
			Assert.assertNotNull(testArray);
		}
		
		[Test]
		public function testExecute():void {
			_undoableCommand.execute();
			Assert.assertEquals(testArray.length, 1);
		}
		
		[Test]
		public function testUndo():void {
			_undoableCommand.execute();
			Assert.assertEquals(testArray.length, 1);
			_undoableCommand.undo();
			Assert.assertEquals(testArray.length, 0);
		}
		
		[Test]
		public function testExecuteMultiple():void {
			_undoableCommand.execute();	
			_undoableCommand.execute();
			_undoableCommand.execute();
			Assert.assertEquals(testArray.length, 1);	
		}
		
		[Test]
		public function testUndoMultiple():void {
			_undoableCommand.execute();	
			_undoableCommand.undo();
			_undoableCommand.undo();
			_undoableCommand.undo();
			Assert.assertEquals(testArray.length, 0);
		}
		
		[Test]
		public function testUndoNothingToUndo():void {
			_undoableCommand.undo();
			Assert.assertEquals(testArray.length, 0);
		}
		
		[Test]
		public function testDefaultFunctions():void {
			var command:MockUndoableCommand = new MockUndoableCommand();
			MockUndoableCommand.testArray = testArray;	
			command.execute();	
			Assert.assertEquals(testArray.length, 1);
			command.undo();	
			Assert.assertEquals(testArray.length, 0);
		}
		
	}
}