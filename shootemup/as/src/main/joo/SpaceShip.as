package 
{
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import mylittleframework.ICollideable;
import mylittleframework.ITickable;
import mylittleframework.Vector2D;

public class SpaceShip extends Sprite implements ITickable, ISpaceShipInfo, ICollideable
{
	[Embed(source = "../assets/images/bship.png")]
	private var _shipBitmap:Class;
	private var _ship:Bitmap;
	[Embed(source = "../assets/images/turret.png")]
	private var _turretBitmap:Class;
	private var _turret:Bitmap;
	private var _turretParent:Sprite;
	
	private var _mouse_x:Number;
	private var _mouse_y:Number;
	private var _mouseDown:Boolean;
	
	private var _acceleration:Number;
	private var _force:Number;
	private var _direction:Vector2D;
	private var _velocity:Vector2D;
	private var _mass:Number;
	private var _speed:Number;
		
	private var _bulletEngine:BulletEngine;
	private var _worldPos:Vector2D;
	private var _startPos:Vector2D;
	private var _diffPos:Vector2D;
	private var _worldDiffPos:Vector2D;
	private var _blinkingTick:Number;
	private var _blinkingTime:Number;
	
	private var _shootDirection:Vector2D;
	private var _isShooting:Boolean;
	
	public static var Energy:int;
				
	public function worldPos():Vector2D { return _worldDiffPos;  }
	public function shootDirection():Vector2D { return _shootDirection; }
	public function isShooting():Boolean { return _isShooting; }
	
	public function SpaceShip(bulletEngine:BulletEngine) 
	{
		super ();
		
		_bulletEngine = bulletEngine;
		
		_ship = ((new _shipBitmap) as Bitmap);
		
		this.addChild(_ship);
		
		_direction = new Vector2D(1, 0);
		_shootDirection = new Vector2D(1, 0);
		_acceleration = 0;
		_velocity = new Vector2D(0, 0);
		_worldDiffPos = new Vector2D(0, 0);
		this.rotation = 1;
		
		_mouseDown = false;
		_mass = 10;
		_force = 0;
				
		_turret = ((new _turretBitmap) as Bitmap);
		_turretParent = new Sprite();
		
		_turretParent.addChild(_turret);
		
		_worldPos = new Vector2D(0,0);
		
		Energy = 10;
		_blinkingTick = 0;
		_blinkingTime = 0;
				
		this.addChild(_turretParent);
		
		this.addEventListener(Event.ADDED_TO_STAGE, onStage);	
	}
	
	public function onCollision(item:Class):Boolean
	{
		if (Energy > 0)
		{
			Energy--;
			
			ShootEmUp.NumberOfEnemiesKilled = 0;
			parent.addChild(new Explosion(_worldPos));
		}
		
		return false;
	}
	
	public function bounds():Rectangle { return this.getBounds(this.parent); }
	public function enabled():Boolean { return this.visible; }
	
	private function onMouseMove(event:MouseEvent):void
	{
		_mouse_x = event.stageX;
		_mouse_y = event.stageY;
	}
	
	private function onMouseDown(evt:MouseEvent):void
	{
		speedUp();
		
		_mouseDown = true;
	}
	
	private function onMouseUp(evt:MouseEvent):void
	{
		brake();
		
		_mouseDown = false;
	}
	
	private function speedUp():void
	{
		_force = 0.015;
	}
	
	private function brake():void
	{
		_force = 0;
	}
	
	private function onStage(evt:Event):void
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
		_diffPos = new Vector2D(0,0);
		
		_worldPos.setTo(x + _turret.x, y + _turret.y);
		
		_mouse_x = x;
		_mouse_y = y;
	}
	
	private function computeVelocity(timeDelta: Number):void
	{
		_acceleration = _force / _mass;
		
		var subVelocity:Vector2D = _direction.mult(_acceleration * timeDelta);
				
		_velocity.plusEquals(subVelocity);
		_velocity.multEquals(0.99); //this is not physically correct, it is a costant decelleration that will make the velocity tend to 0 in this way I do not need to check maximum speed or 0 speed	
		
		_speed = _velocity.magnitude();

		var space:Vector2D = _velocity.mult(timeDelta);
		
		Camera.bound.x += space.x;
		Camera.bound.y += space.y;
		
		_worldPos.x += space.x;
		_worldPos.y += space.y;
		
		_diffPos.plusEquals(_direction.mult(-100 * _force));
		_diffPos.multEquals(0.98);
	
		_worldDiffPos = _worldPos.plus(_diffPos);
	}
	
	public function tick(timeDelta:Number):void
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
			_bulletEngine.shootLikeIfThereIsNoTomorrow(timeDelta, _shootDirection.mult(1.85), _worldDiffPos);
			
			_isShooting = true;
		}
			
		_bulletEngine.update(timeDelta);
			
		x = _worldDiffPos.x - Camera.bound.x;
		y = _worldDiffPos.y - Camera.bound.y;
	}
	
	private function calcTurretRotation():Number 
	{
		_shootDirection = new Vector2D(_mouse_x - x, _mouse_y - y);
		
		var module:Number = _shootDirection.magnitude();
		
		if (module > 0)
		{
			module = 1 / module;
			
			_shootDirection.x *= module;
			_shootDirection.y *= module;
			
			var degrees:Number = _shootDirection.toAngle() - rotation;
			
			return degrees;
		}
		
		return 1;
	}
		
	private function calcRotation():Number 
	{
		if (_mouseDown == false) return this.rotation;
		
		var new_direction:Vector2D = new Vector2D(_mouse_x - x, _mouse_y - y);
		
		var module:Number = new_direction.magnitude();
		
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
}}