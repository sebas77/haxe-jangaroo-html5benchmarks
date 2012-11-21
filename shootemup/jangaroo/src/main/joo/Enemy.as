package 
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

import flash.geom.Rectangle;

import mylittleframework.ICollideable;
import mylittleframework.Vector2D;

public  class Enemy extends Sprite implements ICollideable
{
	private var _ship:Bitmap;
		
	private var _acceleration:Vector2D;
	private var _force:Vector2D;
	private var _velocity:Vector2D;
	private var _mass:Number;
	private var _worldPos:Vector2D;
	private var _maxSpeed:Number;
	private var _maxSpeedMult:Number;
	
	private var _target:ISpaceShipInfo;
		
	private var _energy:Number;
	[Embed(source = "../assets/images/enemy.png")]
	static private var bitmap:Class;
	static private var bitmapData:BitmapData = null;
	
	private var _destroyed:Boolean;
		
	public function Enemy(target:ISpaceShipInfo) 
	{
		super ();
		
		bitmapData = ((new bitmap) as Bitmap).bitmapData;
			
		_ship = new Bitmap(bitmapData);
		_ship.x -= (_ship.width / 2);
		_ship.y -= (_ship.height / 2);
		
		this.addChild(_ship);
		
		_force = new Vector2D(1, 0);
		_acceleration = new Vector2D(0,0);
		_velocity = new Vector2D(0, 0);
		_mass = 12;
		_maxSpeed = (0.3 * Math.random()) + 0.3;
		_maxSpeedMult = 1;
		_worldPos = new Vector2D(0,0);
		_energy = 4;
		
		_target = target;
		_destroyed = false;
	}
	
	public function bounds():Rectangle 
	{
		var rectangle:Rectangle = this.getBounds(parent);
		rectangle.inflate( -5, -5);
		return rectangle;
	}
	public function enabled():Boolean { return this.visible;}
	public function destroyed() : Boolean { return _destroyed; }
		
	public function onCollision(item:Class):Boolean
	{
		if (getQualifiedClassName(item) == getQualifiedClassName("Bullet"))
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
	
	public function InitCoords(x:Number, y:Number):void
	{
		_worldPos.x = this.x = x;
		_worldPos.y = this.y = y;
	}
	
	public function cameraUpdate(timeDelta:Number):void
	{	
		this.rotation = calcRotation();
		
		computeVelocity(timeDelta);
		
		x = (_worldPos.x - (Camera.bound.x));
		y = (_worldPos.y - (Camera.bound.y));
	}
	
	private function computeVelocity(timeDelta: Number):void
	{
		var acceleration:Vector2D = _force.mult(1 / _mass).multEquals(timeDelta);
		
		var newVelocity:Vector2D = _velocity.plus(acceleration);
		
		_velocity.multEquals(0.8).plusEquals(newVelocity.multEquals(0.2));
		
		var speed:Number = _velocity.magnitude();
				
		if (speed > _maxSpeed * _maxSpeedMult)
			_velocity.normalizeEquals().multEquals(_maxSpeed);
			
		var space:Vector2D = _velocity.mult(timeDelta);
		
		_worldPos.x += space.x;
		_worldPos.y += space.y;
	}
	
	private function mod(x:Number):Number
	{
		var r:Number = x % 1200;
		
		return r < -_ship.width ? r + 1200 : r;
	}
	
	private function calcRotation():Number 
	{
		_force = new Vector2D(_target.worldPos().x - _worldPos.x, _target.worldPos().y - _worldPos.y);
		
		var distance:Number = _force.magnitude();
		
		_force.multEquals(1 / distance);
		
		if (distance < 800)
			_maxSpeedMult = 1;
		else
			_maxSpeedMult = 5;
		
		if (distance < 400 && _target.isShooting() == true)
		{
			var angle:Number = Math.min(0,_target.shootDirection().dot(_force)) * -1;
			
			if (angle > 0)
				_force.multEquals((1 - angle) * 40).plusEquals(_force.perpendicular().multEquals(angle * 40));
			else
				_force.multEquals(0.1);
		}
		else
		{
			_force.multEquals(0.1);
		}
		
		return _velocity.toAngle();
	}
}}