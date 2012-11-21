package mylittleframework
{
import flash.display.Stage;
import flash.events.Event;
import flash.utils.getTimer;

public class Ticktock
{
	private var _enterFrameFunctions:Vector.<Function> ; //no weak reference :(
	private var _lastTime:Number;
	
	public function Ticktock(context:Stage) 
	{
		_enterFrameFunctions = new Vector.<Function>();
		
		context.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		
		_lastTime = getTimer();
	}
	
	public function tick(obj:ITickable):void
	{
		_enterFrameFunctions.push(obj.tick);
	}
	
	public function untick(obj:ITickable):void
	{
		_enterFrameFunctions.splice(_enterFrameFunctions.indexOf(obj.tick), 1);
	}
		
	private function onEnterFrame(evt:Event):void
	{
		var thisTime:Number = getTimer();
		
		for each (var func:Function in _enterFrameFunctions)
			func(thisTime - _lastTime);
			
		_lastTime = thisTime;
	}
}}