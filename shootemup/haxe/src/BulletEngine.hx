package ;
import flash.display.BitmapData;
import flash.display.Stage;

import mylittleframework.CollidingItem;
import mylittleframework.CollisionEngine;
import mylittleframework.Vector2D;

class BulletEngine 
{
	var _bullets:Array<Bullet>;
	var _slotAvailable:Int;
	var _processBullet:Int;
	var i:Int;
	
	var _MAX_BULLET:Int;
	var _shootTime:Float;
	var _collisiongEngine:CollisionEngine;
	
	public function new(parent:Stage, collisiongEngine:CollisionEngine) 
	{
		_MAX_BULLET = 16;
		_bullets = new Array<Bullet>();
		
		var bitmapData:BitmapData = nme.Assets.getBitmapData ("assets/images/bullet.png");
		
		for (i in 0..._MAX_BULLET)
		{
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
	
	public function update(deltaTime:Float):Void
	{
		do
		{
			_bullets[i].update(deltaTime);
			
			i++;
		} while (i < _MAX_BULLET);
		
		i = 0;
	}
	
	public function shootLikeIfThereIsNoTomorrow(deltaTime:Float, direction:Vector2D, pos:Vector2D):Void
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
}