package 
{

import mylittleframework.Vector2D;

public interface ISpaceShipInfo 
{
	function shootDirection() : Vector2D;
	function worldPos() : Vector2D;
	function isShooting() : Boolean;
}}