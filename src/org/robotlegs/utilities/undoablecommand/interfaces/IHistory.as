package org.robotlegs.utilities.undoablecommand.interfaces
{
	public interface IHistory
	{
		function stepForward():void;
		function stepBackward():void;
	}
}