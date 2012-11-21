package 
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.getTimer;
import mylittleframework.Vector2D;

public class Explosion extends Bitmap
{
	[Embed(source = "../assets/images/explosion.png")]
	private static var _stripeBitmap:Class;
	private static var _stripe:BitmapData;
	private var _worldPos:Vector2D;
	private var _lastTime:Number;
	private var _index:int;
	
	public function Explosion(worldPos:Vector2D) 
	{
		super ();
		
		_stripe = ((new _stripeBitmap) as Bitmap).bitmapData;
		bitmapData = new BitmapData(48, 48);
		bitmapData.copyPixels(_stripe, new Rectangle(0, 0, 48, 48), new Point(0, 0));
				
		_worldPos = worldPos;
		
		x = mod(_worldPos.x - (Camera.bound.x)) - 24;
		y = mod(_worldPos.y - (Camera.bound.y)) - 24;
		
		this.addEventListener(Event.ENTER_FRAME, onEnterFrame);	 //I was lazy and I did this ,but it should be avoided to improve the performance
		
		_lastTime = getTimer();
		_index = 0;
	}
	
	private function mod(x:Number):Number
	{
		var r:Number = Math.round(x) & 4095;
		
		return r < 0 ? r + 4096 : r;
	}
	
	public function onEnterFrame(evt:Event):void
	{
		var time:Number = getTimer();
		
		if (time - _lastTime > 125)
		{
			_index++;
			var offset:int = 48 * _index;
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
}}