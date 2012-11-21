package 
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Stage;
import mylittleframework.CollidingItem;
import mylittleframework.CollisionEngine;
import mylittleframework.Vector2D;

public class BulletEngine 
{
	private var _bullets:Vector.<Bullet>;
	private var _slotAvailable:int;
	private var _processBullet:int;
	private var i:int;
	
	private var _MAX_BULLET:int;
	private var _shootTime:Number;
	private var _collisiongEngine:CollisionEngine;
	[Embed(source = "../assets/images/bullet.png")]
	static private var bulletBitmap:Class;
	
	public function BulletEngine(parent:Stage, collisiongEngine:CollisionEngine) 
	{
		_MAX_BULLET = 16;
		_bullets = new Vector.<Bullet>();
		
		for (var i:int = 0; i < _MAX_BULLET; i++)
		{
			var bitmapData:BitmapData = (new bulletBitmap() as Bitmap).bitmapData;
			var bullet:Bullet = new Bullet(bitmapData, parent);
			var collidingItem:CollidingItem = new CollidingItem(bullet);
			collidingItem.collidesWidth(Enemy);
			collisiongEngine.add(collidingItem);
			_bullets.push(bullet);
		}
			
		_slotAvailable = 0;
		i = 0;
		_shootTime = 100;
	}
	
	public function update(deltaTime:Number):void
	{
		do
		{
			_bullets[i].update(deltaTime);
			
			i++;
		} while (i < _MAX_BULLET);
		
		i = 0;
	}
	
	public function shootLikeIfThereIsNoTomorrow(deltaTime:Number, direction:Vector2D, pos:Vector2D):void
	{
		_shootTime += deltaTime;
		
		if (_shootTime > 50)
		{
			_bullets[_slotAvailable].shoot(pos, direction);
			
			_slotAvailable++;
			_slotAvailable &= 15;
			
			_shootTime = 0;
		}
	}
}}