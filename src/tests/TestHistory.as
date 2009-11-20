package tests
{
	import flash.events.EventDispatcher;
	
	import flexunit.framework.Assert;
	
	import org.robotlegs.utilities.undoablecommand.CommandHistory;
	
	/**
	 * @private
	 */
	public class TestHistory
	{
		// Reference declaration for class to test
		private var _testHistory : CommandHistory;
		private var testArray:Array;
		
		[Before]
		public function setupTests():void {
			_testHistory = new CommandHistory();
			_testHistory.eventDispatcher = new EventDispatcher();
			testArray = new Array();
			MockUndoableCommand.testArray = testArray;
			
		}
		
		[After]
		public function reset():void {
			_testHistory = null;
			
		}
		
		public function TestHistory() {
			
			
		}
		
		[Test]
		public function testInitialisation():void {
			Assert.assertNotNull(_testHistory);
		}
		
		[Test]
		public function testStepForwardNoHistory():void {
			Assert.assertEquals(_testHistory.currentPosition, 0);
			var newPosition:uint = _testHistory.stepForward();
			Assert.assertEquals(newPosition, 0);
			Assert.assertEquals(_testHistory.currentPosition, 0);
			Assert.assertFalse(_testHistory.canStepForward);
			Assert.assertFalse(_testHistory.canStepBackward);
			
		}
		[Test]
		public function testStepBackwardNoHistory():void {
			Assert.assertEquals(_testHistory.currentPosition, 0);
			var newPosition:uint = _testHistory.stepBackward();
			Assert.assertEquals(newPosition, 0);
			Assert.assertEquals(_testHistory.currentPosition, 0);
			Assert.assertFalse(_testHistory.canStepForward);
			Assert.assertFalse(_testHistory.canStepBackward);
			
		}
		
		// Ensure rewind takes us forward to the last command
		// and also KEEPS history items
		[Test]
		public function testFastForward():void {
			_testHistory.push(new MockUndoableCommand());
			_testHistory.push(new MockUndoableCommand());
		
			newPosition = _testHistory.stepBackward();
			_testHistory.stepBackward();
			
			Assert.assertEquals(_testHistory.currentPosition, 0);
			var newPosition:uint = _testHistory.fastForward();
			Assert.assertEquals(_testHistory.currentPosition, newPosition);
			Assert.assertEquals(_testHistory.currentPosition, 2);
			Assert.assertFalse(_testHistory.canStepForward);
			Assert.assertTrue(_testHistory.canStepBackward);
		}
		
		
		[Test]
		// Ensure numberOfHistoryItems equals the number of items in history
		public function testAddItems():void {
			
			_testHistory.push(new MockUndoableCommand());
			_testHistory.push(new MockUndoableCommand());
			_testHistory.push(new MockUndoableCommand());
			var newPosition:uint = _testHistory.push(new MockUndoableCommand());
			Assert.assertEquals(newPosition, 4);
			Assert.assertEquals(_testHistory.numberOfHistoryItems, 4);
			Assert.assertEquals(_testHistory.currentPosition, 4);
			Assert.assertFalse(_testHistory.canStepForward);
			Assert.assertTrue(_testHistory.canStepBackward);
			
		}
		
		[Test]
		// Ensure rewind takes us back to the start
		// but also KEEPS history items
		public function testRewind():void {
			// Add 4 Commands
			_testHistory.push(new MockUndoableCommand());
			_testHistory.push(new MockUndoableCommand());
			_testHistory.push(new MockUndoableCommand());
			_testHistory.push(new MockUndoableCommand());
			
			var newPosition:uint = _testHistory.rewind();
			
			Assert.assertEquals(_testHistory.numberOfHistoryItems, 4);
			
			Assert.assertEquals(newPosition, 0);
			Assert.assertEquals(_testHistory.currentPosition, 0);
			Assert.assertTrue(_testHistory.canStepForward);
			Assert.assertFalse(_testHistory.canStepBackward);
		}
		
		[Test]
		// Test both return values of canStepBackward verifying 
		// multiple calls work
		public function testCanStepBackward():void {
			Assert.assertFalse(_testHistory.canStepBackward);
			_testHistory.push(new MockUndoableCommand());
			Assert.assertTrue(_testHistory.canStepBackward);
			_testHistory.push(new MockUndoableCommand());
			_testHistory.push(new MockUndoableCommand());
			_testHistory.push(new MockUndoableCommand());
			Assert.assertTrue(_testHistory.canStepBackward);
			_testHistory.rewind();
			Assert.assertEquals(_testHistory.currentPosition, 0);
			Assert.assertEquals(_testHistory.numberOfHistoryItems, 4);
			Assert.assertFalse(_testHistory.canStepBackward);
			Assert.assertFalse(_testHistory.canStepBackward);
			Assert.assertFalse(_testHistory.canStepBackward);
		}
		
		[Test]
		// Test both return values of canStepForward, verifying 
		// multiple calls work
		public function testCanStepForward():void {
			Assert.assertFalse(_testHistory.canStepForward);
			_testHistory.push(new MockUndoableCommand());
			_testHistory.push(new MockUndoableCommand());
			_testHistory.push(new MockUndoableCommand());
			Assert.assertFalse(_testHistory.canStepForward);
			_testHistory.rewind();
			Assert.assertEquals(_testHistory.currentPosition, 0);
			Assert.assertEquals(_testHistory.numberOfHistoryItems, 3);
			Assert.assertTrue(_testHistory.canStepForward);
			Assert.assertTrue(_testHistory.canStepForward);
			Assert.assertTrue(_testHistory.canStepForward);
		}
		
		
		[Test]
		// Ensure current position tracks correctly
		// after multiple calls to stepForward & stepBackward
		public function testCurrentPosition():void {
			_testHistory.push(new MockUndoableCommand());
			_testHistory.push(new MockUndoableCommand());
			_testHistory.push(new MockUndoableCommand());
			_testHistory.push(new MockUndoableCommand());
			_testHistory.push(new MockUndoableCommand());
			_testHistory.push(new MockUndoableCommand());
			Assert.assertEquals(_testHistory.currentPosition, 6);
			Assert.assertFalse(_testHistory.canStepForward);
			Assert.assertTrue(_testHistory.canStepBackward);
			_testHistory.stepBackward();
			Assert.assertEquals(_testHistory.currentPosition, 5);
			Assert.assertTrue(_testHistory.canStepForward);
			Assert.assertTrue(_testHistory.canStepBackward);
			_testHistory.stepBackward();
			Assert.assertEquals(_testHistory.currentPosition, 4);
			Assert.assertTrue(_testHistory.canStepForward);
			Assert.assertTrue(_testHistory.canStepBackward);
			_testHistory.stepBackward();
			Assert.assertEquals(_testHistory.currentPosition, 3);
			Assert.assertTrue(_testHistory.canStepForward);
			Assert.assertTrue(_testHistory.canStepBackward);
			_testHistory.stepBackward();
			Assert.assertEquals(_testHistory.currentPosition, 2);
			Assert.assertTrue(_testHistory.canStepForward);
			Assert.assertTrue(_testHistory.canStepBackward);
			_testHistory.stepBackward();
			Assert.assertEquals(_testHistory.currentPosition, 1);
			Assert.assertTrue(_testHistory.canStepForward);
			Assert.assertTrue(_testHistory.canStepBackward);
			_testHistory.stepBackward();
			Assert.assertEquals(_testHistory.currentPosition, 0);
			Assert.assertTrue(_testHistory.canStepForward);
			Assert.assertFalse(_testHistory.canStepBackward);
			_testHistory.stepBackward();
			Assert.assertEquals(_testHistory.currentPosition, 0);
			Assert.assertTrue(_testHistory.canStepForward);
			Assert.assertFalse(_testHistory.canStepBackward);
			_testHistory.stepForward();
			Assert.assertEquals(_testHistory.currentPosition, 1);
			Assert.assertTrue(_testHistory.canStepForward);
			Assert.assertTrue(_testHistory.canStepBackward);
			_testHistory.stepForward();
			Assert.assertEquals(_testHistory.currentPosition, 2);
			Assert.assertTrue(_testHistory.canStepForward);
			Assert.assertTrue(_testHistory.canStepBackward);
			_testHistory.stepBackward();
			Assert.assertEquals(_testHistory.currentPosition, 1);
			Assert.assertTrue(_testHistory.canStepForward);
			Assert.assertTrue(_testHistory.canStepBackward);
			_testHistory.stepBackward();
			Assert.assertEquals(_testHistory.currentPosition, 0);
			Assert.assertTrue(_testHistory.canStepForward);
			Assert.assertFalse(_testHistory.canStepBackward);
		}
		
		[Test]
		// Ensure pushing a command to the middle of the
		// history, wipes subsequent history
		public function testPushWhileNotAtEndpoint():void {
			_testHistory.push(new MockUndoableCommand());
			_testHistory.push(new MockUndoableCommand());
			_testHistory.push(new MockUndoableCommand());
			_testHistory.push(new MockUndoableCommand());
			Assert.assertEquals(_testHistory.currentPosition, 4);
			
			_testHistory.stepBackward();
			_testHistory.stepBackward();
			Assert.assertEquals(_testHistory.currentPosition, 2);
			_testHistory.push(new MockUndoableCommand());
			// Note it should wipe TWO commands from history, 
            // replacing the first with new
			Assert.assertEquals(_testHistory.currentPosition, 3);
			Assert.assertTrue(_testHistory.canStepBackward);
			Assert.assertFalse(_testHistory.canStepForward);
			_testHistory.rewind();
			Assert.assertFalse(_testHistory.canStepBackward);
			Assert.assertTrue(_testHistory.canStepForward);
			_testHistory.push(new MockUndoableCommand());
			Assert.assertEquals(_testHistory.currentPosition, 1);
			Assert.assertTrue(_testHistory.canStepBackward);
			Assert.assertFalse(_testHistory.canStepForward);
			
		
		}
		
		
		[Test]
		// Test forward/back/position settings while
		// moving backwards & forwards
		public function testComprehensive():void {
			Assert.assertEquals(_testHistory.currentPosition, 0);
			Assert.assertFalse(_testHistory.canStepBackward);
			Assert.assertFalse(_testHistory.canStepForward);
			_testHistory.push(new MockUndoableCommand());
			Assert.assertEquals(_testHistory.currentPosition, 1);
			_testHistory.rewind();
			Assert.assertEquals(_testHistory.currentPosition, 0);
			Assert.assertFalse(_testHistory.canStepBackward);
			Assert.assertTrue(_testHistory.canStepForward);
			_testHistory.stepForward();
			Assert.assertEquals(_testHistory.currentPosition, 1);
			Assert.assertFalse(_testHistory.canStepForward);
			Assert.assertTrue(_testHistory.canStepBackward);
			_testHistory.push(new MockUndoableCommand());
			Assert.assertEquals(_testHistory.currentPosition, 2);
			Assert.assertFalse(_testHistory.canStepForward);
			Assert.assertTrue(_testHistory.canStepBackward);
		}
		
		[Test]
		// Test forward/back/position settings while
		// moving backwards & forwards
		public function testGetCurrentCommand():void {
			Assert.assertNull(_testHistory.currentCommand);
			Assert.assertEquals(0, _testHistory.currentPosition);
			var appleCommand:MockUndoableCommand = new MockUndoableCommand();
			var bananaCommand:MockUndoableCommand = new MockUndoableCommand();
			var pineappleCommand:MockUndoableCommand = new MockUndoableCommand();
			
			_testHistory.push(appleCommand);
			_testHistory.push(bananaCommand);
			_testHistory.push(pineappleCommand);
			
			
			
			Assert.assertEquals(pineappleCommand, _testHistory.currentCommand);
			_testHistory.stepBackward();
			Assert.assertEquals(bananaCommand, _testHistory.currentCommand);
			_testHistory.stepForward();
			Assert.assertEquals(pineappleCommand, _testHistory.currentCommand);
			_testHistory.stepBackward();
			_testHistory.stepBackward();
			Assert.assertEquals(appleCommand, _testHistory.currentCommand);
		}
		
		
	}
}