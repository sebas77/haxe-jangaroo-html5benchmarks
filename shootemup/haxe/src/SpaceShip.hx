package ;
import flash.display.Bitmap;
import flash.display.Sprite;

import flash.events.Event;
import flash.events.MouseEvent;

import flash.geom.Rectangle;

import mylittleframework.ICollideable;
import mylittleframework.ITickable;
import mylittleframework.Vector2D;

class SpaceShip extends Sprite, implements ITickable, implements ISpaceShipInfo, implements ICollideable
{
	var _ship:Bitmap;
	var _turret:Bitmap;
	var _turretParent:Sprite;
	
	var _mouse_x:Float;
	var _mouse_y:Float;
	var _mouseDown:Bool;
	
	var _acceleration:Float;
	var _force:Float;
	var _direction:Vector2D;
	var _velocity:Vector2D;
	var _mass:Float;
	var _speed:Float;
		
	var _bulletEngine:BulletEngine;
	var _worldPos:Vector2D;
	var _startPos:Vector2D;
	var _diffPos:Vector2D;
	var _worldDiffPos:Vector2D;
	var _blinkingTick:Float;
	var _blinkingTime:Float;
	
	var _isShooting:Bool;
	var _shootingDirection:Vector2D;
	var _bounds:Rectangle;
	
	public static var Energy:Int;
			
	public function shootDirection() : Vector2D { return _shootingDirection; }
	public function isShooting() : Bool { return _isShooting; }
	public function worldPos():Vector2D { return _worldDiffPos;  }
	
	public function new(bulletEngine:BulletEngine) 
	{
		super ();
		
		_bounds = new Rectangle(0, 0, 40, 40);
		
		_bulletEngine = bulletEngine;
		
		var bitmapData = nme.Assets.getBitmapData ("assets/images/bship.png");
		
		_ship = new Bitmap(bitmapData);
		
		this.addChild(_ship);
		
		_direction = new Vector2D(1, 0);
		_shootingDirection = new Vector2D(1, 0);
		_acceleration = 0;
		_velocity = new Vector2D(0, 0);
		_worldDiffPos = new Vector2D(0, 0);
				
		_mouseDown = false;
		_mass = 10;
		_force = 0;
				
		bitmapData = nme.Assets.getBitmapData ("assets/images/turret.png");
		
		_turret = new Bitmap(bitmapData);
		_turretParent = new Sprite();
		
		_turretParent.addChild(_turret);
	
		_worldPos = new Vector2D();
		
		Energy = 10;
		_blinkingTick = 0;
		_blinkingTime = 0;
		_turretParent.rotation = 1;
			
		this.addChild(_turretParent);
		
		this.addEventListener(Event.ADDED_TO_STAGE, onStage);	
	}
	
	public function onCollision<T>(item:Class<T>):Bool
	{
		if (Energy > 0)
		{
			Energy--;
			
			ShootEmUp.NumberOfEnemiesKilled = 0;
			
			parent.addChild(new Explosion(_worldPos));
		}
		
		return false;
	}
	
	public function bounds():Rectangle 
	{
		var rectangle:Rectangle = this.getBounds(parent);
		rectangle.inflate( -15, -15);
		return rectangle;
	}
	
	public function enabled():Bool return this.visible
	
	private function onMouseMove(event:MouseEvent)
	{
		_mouse_x = event.stageX;
		_mouse_y = event.stageY;
	}
	
	private function onMouseDown(evt:MouseEvent):Void
	{
		speedUp();
		
		_mouseDown = true;
	}
	
	private function onMouseUp(evt:MouseEvent):Void
	{
		brake();
		
		_mouseDown = false;
	}
	
	private function speedUp():Void
	{
		_force = 0.015;
	}
	
	private function brake():Void
	{
		_force = 0;
	}
	
	private function onStage(evt:Event):Void
	{
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		
		this.removeEventListener(Event.ADDED_TO_STAGE, onStage);//otherwise it is called twice
		
		_ship.x -= (_ship.width / 2);
		_ship.y -= (_ship.height / 2);
		
		_turret.x -= (_turret.width / 3);
		_turret.y -= (_turret.height / 2);
		
		x = (stage.stageWidth / 2);
		y = (stage.stageHeight / 2);
		
		_startPos = new Vector2D(x, y);
		_diffPos = new Vector2D();
		
		_worldPos.setTo(x + _turret.x, y + _turret.y);
		
		_mouse_x = x;
		_mouse_y = y;
	}
	
	static var subVelocity:Vector2D = new Vector2D();
	static var space:Vector2D = new Vector2D();
	static var newForce:Vector2D = new Vector2D();
	
	private function computeVelocity(timeDelta: Float):Void
	{
		_acceleration = _force / _mass;
		
		subVelocity.copy(_direction);
		subVelocity.multEquals(_acceleration * timeDelta);
				
		_velocity.plusEquals(subVelocity);
		_velocity.multEquals(0.99); //this is not physically correct, it is a costant decelleration that will make the velocity tend to 0 in this way I do not need to check maximum speed or 0 speed	
		
		_speed = _velocity.magnitude();

		space.copy(_velocity);
		space.multEquals(timeDelta);
		
		Camera.bound.x += space.x;
		Camera.bound.y += space.y;
		
		_worldPos.x += space.x;
		_worldPos.y += space.y;
		
		newForce.copy(_direction).multEquals( -100 * _force);
		_diffPos.plusEquals(newForce);
		_diffPos.multEquals(0.98);
	
		_worldDiffPos.copy(_worldPos);
		_worldDiffPos.plusEquals(_diffPos);
	}
	
	static var shootDir:Vector2D = new Vector2D();
	
	public function tick(timeDelta:Float):Void
	{	
		if (Energy == 0 && _blinkingTime > 250)
		{
			_blinkingTime = 0; 
			_blinkingTick++;
			this.visible = !this.visible; 
			
			if (_blinkingTick == 15)
			{
				Energy = 10;
				_blinkingTick = 0;
				this.visible = true;
			}
		}
		
		_blinkingTime += timeDelta; 
		
		this.rotation = calcRotation();
		_turretParent.rotation = calcTurretRotation();
		
		computeVelocity(timeDelta);
		_isShooting = false;
		
		if (_mouseDown == false && _speed > .1)
		{
			shootDir.copy(_shootingDirection).multEquals(1.85);
			
			_bulletEngine.shootLikeIfThereIsNoTomorrow(timeDelta, shootDir, _worldDiffPos);
			
			_isShooting = true;
		}
			
		_bulletEngine.update(timeDelta);
			
		x = _worldDiffPos.x - Camera.bound.x;
		y = _worldDiffPos.y - Camera.bound.y;
	}
	
	private function calcTurretRotation():Float 
	{
		_shootingDirection.setTo(_mouse_x - x, _mouse_y - y);
		
		var module:Float = _shootingDirection.magnitude();
		
		if (module > 0)
		{
			module = 1 / module;
			
			_shootingDirection.x *= module;
			_shootingDirection.y *= module;
			
			var degrees:Float = _shootingDirection.toAngle() - rotation;
			
			return degrees;
		}
		
		return 1;
	}
	
	static var new_direction:Vector2D = new Vector2D();
		
	private function calcRotation():Float 
	{
		if (_mouseDown == false) return this.rotation;
		
		new_direction.setTo(_mouse_x - x, _mouse_y - y);
		
		var module:Float = new_direction.magnitude();
		
		if (module > 0)
		{
			module = 1 / module;
			
			new_direction.x *= module;
			new_direction.y *= module;
			
			_direction.multEquals(0.5).plusEquals(new_direction.multEquals(0.5));
			
			return _direction.toAngle();
		}
		
		return 1;
	}
}