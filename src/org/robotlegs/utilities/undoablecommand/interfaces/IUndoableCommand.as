package org.robotlegs.utilities.undoablecommand.interfaces
{

	public interface IUndoableCommand {
		function execute():void;
		function undo():void;
	}
}