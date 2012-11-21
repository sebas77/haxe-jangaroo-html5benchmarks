package mylittleframework;

import flash.geom.Rectangle;

interface ICollideable 
{
	function bounds() : Rectangle;
	function enabled() : Bool;
	function onCollision<T>(Type:Class<T>):Bool;
}