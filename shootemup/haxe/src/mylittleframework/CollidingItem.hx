package mylittleframework;
import flash.geom.Rectangle;

class CollidingItem
{
	var _collidesWidth:Dynamic;
	var _collider:ICollideable;

	public var type(default, null):Dynamic;
	public function enabled():Bool return _collider.enabled()
	public function bounds():Rectangle return _collider.bounds()
	
	public function new(collider:ICollideable)
	{
		type = Type.getClass(collider);
		
		_collider = collider;
	}
	
	public function collidesWidth<T>(colliderWidth:Class<T>):Void
	{
		_collidesWidth = colliderWidth;
	}
	
	public function isCollidingWith<T>(otherCollider:CollidingItem):Bool
	{
		if (_collidesWidth == otherCollider.type)
		{
			var aBounds:Rectangle = bounds();
			var bBounds:Rectangle = otherCollider.bounds();
			
			if (aBounds == null || bBounds == null) return false;
		
			return (aBounds.intersects(bBounds));
		}
		
		return false;
	}
	
	public function onCollision(otherCollider:CollidingItem):Bool
	{
		return _collider.onCollision(Type.getClass(otherCollider._collider));
	}
}