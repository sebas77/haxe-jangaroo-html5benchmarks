package ;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;

import flash.geom.Rectangle;

import mylittleframework.ICollideable;
import mylittleframework.Vector2D;

class Enemy extends Sprite, implements ICollideable
{
	var _ship:Bitmap;
		
	var _acceleration:Vector2D;
	var _force:Vector2D;
	var _velocity:Vector2D;
	var _mass:Float;
	var _worldPos:Vector2D;
	var _maxSpeed:Float;
	var _maxSpeedMult:Float;
	
	var _target:ISpaceShipInfo;
		
	var _energy:Float;
	var _destroyed:Bool;
	
	var _newVelocity:Vector2D;
	var _space:Vector2D;
	var _newAcceleration:Vector2D;
	
	static var bitmapData:BitmapData = null;
		
	public function new(target:ISpaceShipInfo) 
	{
		_newVelocity = new Vector2D();
		_space = new Vector2D() ;
		_newAcceleration = new Vector2D() ;
		
		super ();
		
		if (bitmapData == null)
			bitmapData = nme.Assets.getBitmapData ("assets/images/enemy.png");
			
		_ship = new Bitmap(bitmapData);
		_ship.x -= (_ship.width / 2);
		_ship.y -= (_ship.height / 2);
		
		this.addChild(_ship);
		
		_target = target;
		
		reset();
	}
	
	public function bounds():Rectangle 
	{
		var rectangle:Rectangle = this.getBounds(parent);
		return rectangle;
	}
	public function enabled():Bool { return this.visible; }
	public function destroyed() : Bool { return _destroyed; }
		
	public function onCollision<T>(item:Class<T>):Bool
	{
		if (Type.getClassName(item) == Type.getClassName(Bullet))
		{
			_energy--;
			
			if (_energy <= 0)
				_destroyed = true;
		}
		else
			_destroyed = true;
			
		if (_destroyed == true && parent != null)
		{
			ShootEmUp.NumberOfEnemiesKilled++;
			
			parent.addChild(new Explosion(_worldPos));
		}
		
		return _destroyed;
	}
	
	public function InitCoords(x:Float, y:Float):Void
	{
		_worldPos.x = this.x = x;
		_worldPos.y = this.y = y;
	}
	
	public function cameraUpdate(timeDelta:Float):Void
	{	
		this.rotation = calcRotation();
		
		computeVelocity(timeDelta);
		
		x = (_worldPos.x - (Camera.bound.x));
		y = (_worldPos.y - (Camera.bound.y));
	}
	
	private function computeVelocity(timeDelta: Float):Void
	{
		_newAcceleration.copy(_force).multEquals(1 / _mass * timeDelta);
		
		_newVelocity.copy(_velocity).plusEquals(_newAcceleration);
		
		_velocity.multEquals(0.8).plusEquals(_newVelocity.multEquals(0.2));
		
		var speed:Float = _velocity.magnitude();
				
		if (speed > _maxSpeed * _maxSpeedMult)
			_velocity.normalizeEquals().multEquals(_maxSpeed);
			
		_space.copy(_velocity).multEquals(timeDelta);
		
		_worldPos.x += _space.x;
		_worldPos.y += _space.y;
	}
	
	private function mod(x:Float):Float
	{
		var r:Float = x % 1200;
		
		return r < -_ship.width ? r + 1200 : r;
	}
	
	static var perp:Vector2D = new Vector2D();
	
	private function calcRotation():Float 
	{
		_force.setTo(_target.worldPos().x - _worldPos.x, _target.worldPos().y - _worldPos.y);
		
		var distance:Float = _force.magnitude();
		
		_force.multEquals(1 / distance);
		
		if (distance < 800)
			_maxSpeedMult = 1;
		else
			_maxSpeedMult = 5;
		
		if (distance < 400 && _target.isShooting() == true)
		{
			var angle:Float = Math.min(0,_target.shootDirection().dot(_force)) * -1;
			
			if (angle > 0)
			{
				perp.copy(_force).perpendicular();
				
				_force.multEquals((1 - angle) * 40).plusEquals(perp.multEquals(angle * 40));
			}
			else
				_force.multEquals(0.1);
		}
		else
			_force.multEquals(0.1);
		
		return _velocity.toAngle();
	}
	
	public function reset():Void 
	{
		_force = new Vector2D(1, 0);
		_acceleration = new Vector2D();
		_velocity = new Vector2D(0, 0);
		_mass = 12;
		_maxSpeed = (0.3 * Math.random()) + 0.3;
		_maxSpeedMult = 1;
		_worldPos = new Vector2D();
		_energy = 4;
		
		_destroyed = false;
	}
}