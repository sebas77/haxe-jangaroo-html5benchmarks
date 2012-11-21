package ;

import flash.display.Stage;
import mylittleframework.CollidingItem;
import mylittleframework.CollisionEngine;
import mylittleframework.ITickable;

class EnemyEngine implements ITickable
{
	private var _enemies:Array<Enemy>;
	private var _stage:Stage;
	private var _buildAnotherEnemy:Enemy -> Void;
				
	public function new(stage:Stage, spaceShip:ISpaceShipInfo, collisionEngine:CollisionEngine) 
	{
		_stage = stage;
			
		_enemies = new Array<Enemy>();
		
		buildEnemies(spaceShip, collisionEngine);
	}
	
	private function buildEnemies(spaceShip:ISpaceShipInfo, collisionEngine:CollisionEngine):Void
	{
		_buildAnotherEnemy = function(enemy:Enemy):Void
		{
			var collidingItem:CollidingItem = new CollidingItem(enemy);
			collidingItem.collidesWidth(Bullet);
			collisionEngine.add(collidingItem);
				
			enemy.reset();
			enemy.InitCoords(Math.round((171079 * Math.random()) % (2048) + 2048),
								 Math.round((85627 * 171079 * Math.random()) % (2048)) + 2048);
		}
		
		for (i in 0...10)
		{
			var enemy:Enemy = new Enemy(spaceShip);
			
			_enemies.push(enemy);
			
			_buildAnotherEnemy(enemy);
			
			_stage.addChild(enemy);
		}
	}
	
	private function isVisible(enemy:Enemy):Bool
	{
		if ((Math.abs(enemy.x - ShootEmUp.StageWidthHalf) < ShootEmUp.StageWidthHalf + (enemy.width * 0.5)) &&
			(Math.abs(enemy.y - ShootEmUp.StageHeightHalf) < ShootEmUp.StageHeightHalf + (enemy.height * 0.5)))
			return true;
		 
		return false;
	}
	
	public function tick(deltaTime:Float):Void
	{
		for (enemy in _enemies)
		{
			if (enemy.destroyed() == true)
			{
				_buildAnotherEnemy(enemy);
				
				continue;
			}
			
			enemy.cameraUpdate(deltaTime);
	
			if (isVisible(enemy))
			{
				if (enemy.visible == false)
				{
					_stage.addChild(enemy);
					
					enemy.visible = true;
				}
			}
			else
			if (enemy.visible == true && enemy.parent == _stage)
			{
				_stage.removeChild(enemy);
				
				enemy.visible = false;
			}
		}
	}
}