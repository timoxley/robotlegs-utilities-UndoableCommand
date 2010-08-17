package org.robotlegs.utilities.undoablecommand.interfaces
{
	import flash.events.IEventDispatcher;

	public interface IUndoableCommand {
		function execute():void;
		function undo():void;
		function get eventDispatcher():IEventDispatcher;
		function set eventDispatcher(value:IEventDispatcher):void;
	}
}