package mylittleframework
{

import flash.geom.Rectangle;

public interface ICollideable 
{
	function bounds() : Rectangle;
	function enabled() : Boolean;
	function onCollision(Type:Class):Boolean;
}}