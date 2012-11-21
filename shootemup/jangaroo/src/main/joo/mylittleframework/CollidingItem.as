package mylittleframework
{
import flash.geom.Rectangle;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

public class CollidingItem
{
	private var _collidesWidth:Class;
	private var _collider:ICollideable;
	private var _type:Class;

	public function type():Class { return _type; }
	public function enabled():Boolean { return _collider.enabled(); }
	public function bounds():Rectangle { return _collider.bounds(); }
	
	public function CollidingItem(collider:ICollideable)
	{
		_type = collider["constructor"];
		
		_collider = collider;
	}
	
	public function collidesWidth(colliderWidth:Class):void
	{
		_collidesWidth = colliderWidth;
	}
	
	public function isCollidingWith(otherCollider:CollidingItem):Boolean
	{
		if (getQualifiedClassName(_collidesWidth) == getQualifiedClassName(otherCollider.type()))
		{
			var aBounds:Rectangle = bounds();
			var bBounds:Rectangle = otherCollider.bounds();
			
			if (aBounds == null || bBounds == null) return false;
		
			return (aBounds.intersects(bBounds));
		}
		
		return false;
	}
	
	public function onCollision(otherCollider:CollidingItem):Boolean
	{
		return _collider.onCollision(otherCollider._collider["constructor"]);
	}
}
}