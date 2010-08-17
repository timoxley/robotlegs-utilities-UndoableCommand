package tests
{
	import flash.events.EventDispatcher;
	
	import flexunit.framework.Assert;
	
	import org.flexunit.async.Async;
	import org.robotlegs.utilities.undoablecommand.CommandHistory;
	import org.robotlegs.utilities.undoablecommand.HistoryEvent;
	
	public class TestHistoryEvents
	{
		// Reference declaration for class to test
		private var history:CommandHistory;
		private var eventBus:EventDispatcher;
		private var bananaCommand:MockUndoableCommand;
		private var appleCommand:MockUndoableCommand;
		private var pineappleCommand:MockUndoableCommand;
		
		public function TestHistoryEvents()
		{
		}
		
		[Before]
		public function setupTests():void {
			history = new CommandHistory();
			eventBus = new EventDispatcher()	
			history.eventDispatcher = eventBus;
			MockUndoableCommand.testArray = new Array()
			bananaCommand = new MockUndoableCommand();
			bananaCommand.eventDispatcher = eventBus;
			appleCommand = new MockUndoableCommand();
			appleCommand.eventDispatcher = eventBus;
			pineappleCommand = new MockUndoableCommand();
			pineappleCommand.eventDispatcher = eventBus;
		}
		
		[After]
		public function reset():void {
			history = null;
			eventBus = null;
			MockUndoableCommand.testArray = null;
		}
		
		
		[Test(async)]
		public function testFastForwardEvents():void {		
			Async.handleEvent(this, history.eventDispatcher, HistoryEvent.FAST_FORWARD_COMPLETE, function(event:HistoryEvent, passThrough:Object):void {
				Assert.assertStrictlyEquals(pineappleCommand, event.command)
			});
		
			history.push(bananaCommand);
			history.push(appleCommand);
			history.push(pineappleCommand);
			history.rewind();
			history.fastForward();
		}
		
		[Test(async)]
		public function testRewindEvents():void {
			Async.handleEvent(this, history.eventDispatcher, HistoryEvent.REWIND_COMPLETE, function(event:HistoryEvent, passThrough:Object):void {
				Assert.assertNull(event.command);
				
			});
			
			history.push(bananaCommand);
			history.push(appleCommand);
			history.push(pineappleCommand);
			history.rewind();
		}
		
		[Test(async)]
		public function testStepBackwardEvents():void {
			Async.handleEvent(this, history.eventDispatcher, HistoryEvent.STEP_BACKWARD_COMPLETE, function(event:HistoryEvent, passThrough:Object):void {
				Assert.assertStrictlyEquals(pineappleCommand, event.command);
			});
			
			history.push(bananaCommand);
			history.push(appleCommand);
			history.push(pineappleCommand);
			history.stepBackward();
		}
		
		[Test(async)]
		public function testStepForwardEvents():void
		{
			Async.handleEvent(this, history.eventDispatcher, HistoryEvent.STEP_FORWARD_COMPLETE, function(event:HistoryEvent, passThrough:Object):void {
				Assert.assertStrictlyEquals(bananaCommand, event.command);
				
			});
			
			history.push(bananaCommand);
		}
	}
}