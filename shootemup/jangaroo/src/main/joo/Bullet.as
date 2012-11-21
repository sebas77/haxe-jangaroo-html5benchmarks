package 
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Stage;
import flash.geom.Rectangle;
import mylittleframework.ICollideable;
import mylittleframework.Vector2D;

public class Bullet implements ICollideable
{
	private var _velocity:Vector2D;
	private var _wx:Number;
	private var _wy:Number;
	private var _totalTime:Number;
	private var _bitmap:Bitmap;
	private var _parent:Stage;
	private var _enabled:Boolean;
	
	private function setEnabled(enable:Boolean):Boolean
	{
		if (enable && _bitmap.visible == false)
		{
			if (_bitmap.parent != null)
			_bitmap.parent.removeChild(_bitmap);
			_parent.addChild(_bitmap);
		}
		else
		if (enable == false && _bitmap.visible == true)
			_parent.removeChild(_bitmap);
			
		_bitmap.visible = enable;
		_enabled = enable;
		 
		return _enabled;
	}
	
	public function bounds():Rectangle 
	{
		if (_bitmap.parent != null)
			return _bitmap.getBounds(_bitmap.parent);
		
		return null;
	}
	public function enabled():Boolean { return _enabled; }
	
	public function onCollision(item:Class):Boolean
	{
		setEnabled(false);
		
		return false;
	}
	
	public function Bullet(bitmap:BitmapData, parent:Stage) 
	{
		_totalTime = 0;
		_bitmap = new Bitmap(bitmap);
		_parent = parent;
		_bitmap.visible = false;
		_enabled = false;
	}
	
	public function shoot(pos:Vector2D, velocity:Vector2D):void
	{
		setEnabled(true);
	
		_wx = pos.x;
		_wy = pos.y;
		_velocity = velocity;
		_totalTime = 0;
	}
	
	public function update(timeDelta:Number):void
	{
		if (_enabled == false || isAlive(timeDelta) == false)
			return ;
		
		var space:Vector2D = _velocity.mult(timeDelta);
		
		_wx += space.x;
		_wy += space.y;
		
		_bitmap.x = _wx - Camera.bound.x;
		_bitmap.y = _wy - Camera.bound.y;
	}
	
	private function isAlive(timeDelta:Number):Boolean
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
}}