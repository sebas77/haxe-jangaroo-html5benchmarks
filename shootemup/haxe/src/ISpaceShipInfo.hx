package ;

import mylittleframework.Vector2D;

interface ISpaceShipInfo 
{
	function shootDirection() : Vector2D;
	function worldPos() : Vector2D;
	function isShooting() : Bool;
}