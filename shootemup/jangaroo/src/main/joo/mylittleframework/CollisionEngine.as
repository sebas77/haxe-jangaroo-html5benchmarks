package mylittleframework
{
import flash.geom.Rectangle;

public class CollisionEngine implements ITickable
{
	private var _colliders:Vector.<CollidingItem>;
	private var _toRemove:Vector.<CollidingItem>;

	public function CollisionEngine() 
	{
		_colliders = new Vector.<CollidingItem>();
		_toRemove = new Vector.<CollidingItem>();
	}
	
	public function add(collider:CollidingItem):void
	{
		_colliders.push(collider);
	}
	
	private function checkCollisions(a:CollidingItem, b:CollidingItem):void
	{
		if (a.isCollidingWith(b) || b.isCollidingWith(a))
		{
			if (a.onCollision(b) == true)
				_toRemove.push(a);
				
			if (b.onCollision(a) == true)
				_toRemove.push(b);
		}
	}
	
	public function tick(deltaTime:Number):void
	{
		var enemy:Enemy;
		
		var i:int = 0;
		
		while (i < _colliders.length - 1)
		{
			if (_colliders[i].enabled() == true) 
			{
				var j:int = i + 1;
				
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
			for each (var collider:CollidingItem in _toRemove)
				_colliders.splice(_colliders.indexOf(collider), 1);
			
			_toRemove.splice(0, _toRemove.length);
		}
	}
}}