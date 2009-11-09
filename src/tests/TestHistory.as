package tests
{
	import flexunit.framework.Assert;
	
	import org.robotlegs.utilities.undoablecommand.CommandHistory;
	import org.robotlegs.utilities.undoablecommand.UndoableCommand;
	
	public class TestHistory
	{
		// Reference declaration for class to test
		private var _testHistory : org.robotlegs.utilities.undoablecommand.CommandHistory;
		
		[Before]
		public function setupTests():void {
			_testHistory = new CommandHistory();
			
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
			_testHistory.stepForward();
			Assert.assertEquals(_testHistory.currentPosition, 0);
			Assert.assertFalse(_testHistory.canStepForward);
			Assert.assertFalse(_testHistory.canStepBackward);
			
		}
		[Test]
		public function testStepBackwardNoHistory():void {
			Assert.assertEquals(_testHistory.currentPosition, 0);
			_testHistory.stepBackward();
			Assert.assertEquals(_testHistory.currentPosition, 0);
			Assert.assertFalse(_testHistory.canStepForward);
			Assert.assertFalse(_testHistory.canStepBackward);
			
		}
		
		// Ensure rewind takes us forward to the last command
		// and also KEEPS history items
		[Test]
		public function testFastForward():void {
			_testHistory.push(new UndoableCommand());
			_testHistory.push(new UndoableCommand());
			_testHistory.stepBackward();
			_testHistory.stepBackward();
			Assert.assertEquals(_testHistory.currentPosition, 0);
			_testHistory.fastForward();
			Assert.assertEquals(_testHistory.currentPosition, 2);
			Assert.assertFalse(_testHistory.canStepForward);
			Assert.assertTrue(_testHistory.canStepBackward);
		}
		
		
		[Test]
		// Ensure numberOfHistoryItems equals the number of items in history
		public function testAddItems():void {
			_testHistory.push(new UndoableCommand());
			_testHistory.push(new UndoableCommand());
			_testHistory.push(new UndoableCommand());
			_testHistory.push(new UndoableCommand());
			Assert.assertEquals(_testHistory.numberOfHistoryItems, 4);
			Assert.assertEquals(_testHistory.currentPosition, 4);
			Assert.assertFalse(_testHistory.canStepForward);
			Assert.assertTrue(_testHistory.canStepBackward);
			
		}
		
		[Test]
		// Ensure rewind takes us back to the start
		// but also KEEPS history items
		public function testRewind():void {
			_testHistory.push(new UndoableCommand());
			_testHistory.push(new UndoableCommand());
			_testHistory.push(new UndoableCommand());
			_testHistory.push(new UndoableCommand());
			_testHistory.rewind();
			Assert.assertEquals(_testHistory.numberOfHistoryItems, 4);
			Assert.assertEquals(_testHistory.currentPosition, 0);
			Assert.assertTrue(_testHistory.canStepForward);
			Assert.assertFalse(_testHistory.canStepBackward);
		}
		
		[Test]
		// Test both return values of canStepBackward verifying 
		// multiple calls work
		public function testCanStepBackward():void {
			_testHistory.push(new UndoableCommand());
			Assert.assertTrue(_testHistory.canStepBackward);
			_testHistory.push(new UndoableCommand());
			_testHistory.push(new UndoableCommand());
			_testHistory.push(new UndoableCommand());
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
			_testHistory.push(new UndoableCommand());
			_testHistory.push(new UndoableCommand());
			_testHistory.push(new UndoableCommand());
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
			_testHistory.push(new UndoableCommand());
			_testHistory.push(new UndoableCommand());
			_testHistory.push(new UndoableCommand());
			_testHistory.push(new UndoableCommand());
			_testHistory.push(new UndoableCommand());
			_testHistory.push(new UndoableCommand());
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
			_testHistory.push(new UndoableCommand());
			_testHistory.push(new UndoableCommand());
			_testHistory.push(new UndoableCommand());
			_testHistory.push(new UndoableCommand());
			Assert.assertEquals(_testHistory.currentPosition, 4);
			
			_testHistory.stepBackward();
			_testHistory.stepBackward();
			Assert.assertEquals(_testHistory.currentPosition, 2);
			_testHistory.push(new UndoableCommand());
			// Note it should wipe TWO commands from history, 
            // replacing the first with new
			Assert.assertEquals(_testHistory.currentPosition, 3);
			Assert.assertTrue(_testHistory.canStepBackward);
			Assert.assertFalse(_testHistory.canStepForward);
			_testHistory.rewind();
			Assert.assertFalse(_testHistory.canStepBackward);
			Assert.assertTrue(_testHistory.canStepForward);
			_testHistory.push(new UndoableCommand());
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
			_testHistory.push(new UndoableCommand());
			Assert.assertEquals(_testHistory.currentPosition, 1);
			_testHistory.rewind();
			Assert.assertEquals(_testHistory.currentPosition, 0);
			Assert.assertFalse(_testHistory.canStepBackward);
			Assert.assertTrue(_testHistory.canStepForward);
			_testHistory.stepForward();
			Assert.assertEquals(_testHistory.currentPosition, 1);
			Assert.assertFalse(_testHistory.canStepForward);
			Assert.assertTrue(_testHistory.canStepBackward);
			_testHistory.push(new UndoableCommand());
			Assert.assertEquals(_testHistory.currentPosition, 2);
			Assert.assertFalse(_testHistory.canStepForward);
			Assert.assertTrue(_testHistory.canStepBackward);
		}
	}
}