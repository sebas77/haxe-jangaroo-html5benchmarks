package 
{
import flash.display.Stage;
import mylittleframework.CollidingItem;
import mylittleframework.CollisionEngine;
import mylittleframework.ITickable;

public class EnemyEngine implements ITickable
{
	private var _enemies:Vector.<Enemy>;
	private var _stage:Stage;
	private var _buildAnotherEnemy:Function;
			
	public function EnemyEngine(stage:Stage, spaceShip:ISpaceShipInfo, collisionEngine:CollisionEngine) 
	{
		_stage = stage;
			
		_enemies = new Vector.<Enemy>();
		
		buildEnemies(spaceShip, collisionEngine);
	}
	
	private function buildEnemies(spaceShip:ISpaceShipInfo, collisionEngine:CollisionEngine):void
	{
		_buildAnotherEnemy = function():void
		{
			var enemy:Enemy = new Enemy(spaceShip);
				
			_enemies.push(enemy);
			var collidingItem:CollidingItem = new CollidingItem(enemy);
			collidingItem.collidesWidth(Bullet);
			collisionEngine.add(collidingItem);
				
			enemy.InitCoords(Math.round((171079 * Math.random()) % (2048) + 2048),
								 Math.round((85627 * 171079 * Math.random()) % (2048)) + 2048);
				
			_stage.addChild(enemy);
		}
		
		for (var i:int = 0; i < 10; i++ )
			_buildAnotherEnemy();
	}
	
	private function isVisible(enemy:Enemy):Boolean
	{
		if ((Math.abs(enemy.x - ShootEmUp.StageWidthHalf) < ShootEmUp.StageWidthHalf + (enemy.width * 0.5)) &&
			(Math.abs(enemy.y - ShootEmUp.StageHeightHalf) < ShootEmUp.StageHeightHalf + (enemy.height * 0.5)))
			return true;
		 
		return false;
	}
	
	public function tick(deltaTime:Number):void
	{
		for each (var enemy:Enemy in _enemies)
		{
			if (enemy.destroyed() == true)
			{
				if (enemy.parent != null)
					_stage.removeChild(enemy);
					
				_enemies.splice(_enemies.indexOf(enemy), 1);
				_buildAnotherEnemy();
				
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
}}