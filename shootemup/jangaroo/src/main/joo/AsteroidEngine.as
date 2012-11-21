package 
{
import flash.display.Stage;
import mylittleframework.ITickable;

public class AsteroidEngine implements ITickable
{
	private var _asteroids:Vector.<Asteroid>;
	private var _stage:Stage;
	
	public function AsteroidEngine(stage:Stage) 
	{
		_stage = stage;
			
		_asteroids = new Vector.<Asteroid>();
					
		buildAsteroidsField();
	}
	
	private function buildAsteroidsField():void
	{
		var i:int = 0;
		
		while (i < 50)
		{
			var asteroid:Asteroid = new Asteroid(i % 4);
			_asteroids[i] = asteroid;
			
			asteroid.wx = asteroid.x = Math.round((171079 * i * Math.random()) % (1200));
			asteroid.wy = asteroid.y = Math.round((85627 * i * Math.random()) % (1200));
			
			_stage.addChild(asteroid);
			asteroid.visible = true;
				
			i++;
		}
	}
	
	private function isVisible(asteroid:Asteroid):Boolean
	{
		if ((Math.abs(asteroid.x - ShootEmUp.StageWidthHalf) < (ShootEmUp.StageWidthHalf + 16)) &&
			(Math.abs(asteroid.y - ShootEmUp.StageHeightHalf) < (ShootEmUp.StageHeightHalf + 16)))
			return true;
		 
		return false;
	}
	
	public function tick(deltaTime:Number):void
	{
		for each (var asteroid:Asteroid in _asteroids)
		{
			asteroid.cameraUpdate();
			
			if (isVisible(asteroid))
			{
				if (asteroid.visible == false)
				{
					_stage.addChild(asteroid);
					asteroid.visible = true;
				}
			}
			else
			if (asteroid.visible == true)
			{
				_stage.removeChild(asteroid);
				asteroid.visible = false;
			}
		}
	}
}}