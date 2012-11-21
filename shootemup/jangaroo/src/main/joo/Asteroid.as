package 
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;

public class Asteroid extends Sprite
{
	public var wx:Number;
	public var wy:Number;
	
	private var _index:Number;
	
	[Embed(source = "../assets/images/asteroids.png")]
	private static var bitmap:Class;
	private static var bitmapData:BitmapData = null;
		
	public function Asteroid(index:int) 
	{
		super ();
		
		if (bitmapData == null)
			bitmapData = ((new bitmap) as Bitmap).bitmapData;
			
		var _bmp:Bitmap = new Bitmap();
		_bmp.bitmapData = new BitmapData(32, 32);
		_bmp.bitmapData.copyPixels(bitmapData, new Rectangle(index * 32, 0, (index * 32) + 32, 32), new Point());
		addChild(_bmp);
		_bmp.x -= 16;
		_bmp.y -= 16;
		
		wx *= (index + 1);
		wy *= (index + 1);
		
		_index = 1 / (index + 1);
		
		x = 100;
		y = 100;
		
		visible = false;
	}
	
	private function mod(x:Number):Number
	{
		var r:Number = x % 1200;
		
		return r < -16 ? r + 1200 : r;
	}
	
	public function cameraUpdate():void
	{
		x = mod((wx - (Camera.bound.x * _index)));
		y = mod((wy - (Camera.bound.y * _index)));
	}
}}