package ;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Stage;
import flash.geom.Rectangle;
import mylittleframework.ICollideable;
import mylittleframework.Vector2D;

class Bullet implements ICollideable
{
	var _velocity:Vector2D;
	var _wx:Float;
	var _wy:Float;
	var _totalTime:Float;
	var _bitmap:Bitmap;
	var _parent:Stage;
	var _enabled:Bool;
	var _space:Vector2D;
	
	private function setEnabled(enable:Bool):Bool
	{
		if (enable && _bitmap.visible == false)
			_parent.addChild(_bitmap);
		else
		if (enable == false && _bitmap.visible == true)
			_parent.removeChild(_bitmap);
			
		_bitmap.visible = _enabled = enable;
		 
		return _enabled;
	}
	
	public function bounds():Rectangle 
	{
		if (_bitmap.parent != null)
			return _bitmap.getBounds(_bitmap.parent);
		
		return null;
	}
	public function enabled():Bool { return _enabled; }
	
	public function onCollision<T>(item:Class<T>):Bool
	{
		setEnabled(false);
		
		return false;
	}
	
	public function new(bitmapdata:BitmapData, parent:Stage) 
	{
		_totalTime = 0;
		_bitmap = new Bitmap(bitmapdata);
		_parent = parent;
		_parent.addChild(_bitmap);
		_space = new Vector2D();
		_velocity = new Vector2D();
		
		setEnabled(false);
	}
	
	public function shoot(pos:Vector2D, velocity:Vector2D):Void
	{
		setEnabled(true);
	
		_wx = pos.x;
		_wy = pos.y;
		_velocity.copy(velocity);
		_totalTime = 0;
	}
	
	public function update(timeDelta:Float)
	{
		if (_enabled == false || isAlive(timeDelta) == false)
			return;
		
		_space.copy(_velocity).multEquals(timeDelta);
		
		_wx += _space.x;
		_wy += _space.y;
		
		_bitmap.x = _wx - Camera.bound.x;
		_bitmap.y = _wy - Camera.bound.y;
	}
	
	private function isAlive(timeDelta:Float):Bool
	{
		_totalTime += timeDelta;
		
		if (_totalTime > 1500)
		{
			setEnabled(false);
			_totalTime = 0;
			return false;
		}
		
		return true;
	}
}