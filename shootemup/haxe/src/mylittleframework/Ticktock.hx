package mylittleframework;

import flash.display.Stage;
import flash.events.Event;

class Ticktock
{
	private var _enterFrameFunctions:Array< Float->Void > ; //no weak reference :(
	private var _lastTime:Float;
	
	public function new(context:Stage) 
	{
		_enterFrameFunctions = new Array<Float -> Void>();
		
		context.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		
		_lastTime = flash.Lib.getTimer();
	}
	
	public function tick(obj:ITickable):Void
	{
		_enterFrameFunctions.push(obj.tick);
	}
	
	public function untick(obj:ITickable):Void
	{
		_enterFrameFunctions.remove(obj.tick);
	}
		
	private function onEnterFrame(evt:Event):Void
	{
		var thisTime:Float = flash.Lib.getTimer();
		
		for (func in _enterFrameFunctions)
			func(thisTime - _lastTime);
			
		_lastTime = thisTime;
	}
}