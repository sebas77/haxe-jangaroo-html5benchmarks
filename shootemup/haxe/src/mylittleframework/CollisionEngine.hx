package mylittleframework;
import flash.geom.Rectangle;

class CollisionEngine implements ITickable
{
	var _colliders:Array<CollidingItem>;
	var _toRemove:Array<CollidingItem>;

	public function new() 
	{
		_colliders = new Array<CollidingItem>();
		_toRemove = new Array<CollidingItem>();
	}
	
	public function add(collider:CollidingItem):Void
	{
		_colliders.push(collider);
	}
	
	private function checkCollisions(a:CollidingItem, b:CollidingItem)
	{
		if (a.isCollidingWith(b) || b.isCollidingWith(a))
		{
			if (a.onCollision(b) == true)
				_toRemove.push(a);
				
			if (b.onCollision(a) == true)
				_toRemove.push(b);
		}
	}
	
	public function tick(deltaTime:Float):Void
	{
		var i:Int = 0;
		
		while (i < _colliders.length - 1)
		{
			if (_colliders[i].enabled() == true) 
			{
				var j:Int = i + 1;
				
				while (j < _colliders.length)
				{
					if (_colliders[j].enabled() == true) 
						checkCollisions(_colliders[i], _colliders[j]);
						
					j++;
				}
			}
						
			i++;
		}
		
		
		if (_toRemove.length > 0)
		{
			for (collider in _toRemove)
				_colliders.remove(collider);
			
			_toRemove.splice(0, _toRemove.length);
		}
	}
}