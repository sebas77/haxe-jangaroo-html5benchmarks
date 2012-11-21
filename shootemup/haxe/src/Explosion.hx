package ;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;
import mylittleframework.Vector2D;

class Explosion extends Bitmap
{
	var _stripe:BitmapData;
	var _worldPos:Vector2D;
	var _lastTime:Float;
	var _index:Int;
	
	public function new(worldPos:Vector2D) 
	{
		super ();
		
		_stripe = nme.Assets.getBitmapData ("assets/images/explosion.png");
		bitmapData = new BitmapData(48, 48);
		bitmapData.copyPixels(_stripe, new Rectangle(0, 0, 48, 48), new Point(0, 0));
				
		_worldPos = worldPos;
		
		x = mod(_worldPos.x - (Camera.bound.x)) - 24;
		y = mod(_worldPos.y - (Camera.bound.y)) - 24;
		
		this.addEventListener(Event.ENTER_FRAME, onEnterFrame);	 //I was lazy and I did this ,but it should be avoided to improve the performance
		
		_lastTime = flash.Lib.getTimer();
		_index = 0;
	}
	
	private function mod(x:Float):Float
	{
		var r:Float = Std.int(x) & 4095;
		
		return r < 0 ? r + 4096 : r;
	}
	
	public function onEnterFrame(evt:Event):Void
	{
		var time:Float = flash.Lib.getTimer();
		
		if (time - _lastTime > 125)
		{
			_index++;
			var offset:Int = 48 * _index;
			_lastTime = time;
			if (_index < 7)
				bitmapData.copyPixels(_stripe, new Rectangle(offset, 0, 48, 48), new Point(0, 0));
			else
			{
				this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				this.parent.removeChild(this);
			}
		}
		
		x = (_worldPos.x - (Camera.bound.x)) - 24;
		y = (_worldPos.y - (Camera.bound.y)) - 24;
	}
}