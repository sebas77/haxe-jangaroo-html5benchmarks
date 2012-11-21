package ;
import flash.display.Stage;
import mylittleframework.ITickable;

class AsteroidEngine implements ITickable
{
	private var _asteroids:Array<Asteroid>;
	private var _stage:Stage;
	
	public function new(stage:Stage) 
	{
		_stage = stage;
			
		_asteroids = new Array<Asteroid>();
					
		buildAsteroidsField();
	}
	
	private function buildAsteroidsField():Void
	{
		var i:Int = 0;
		
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
	
	private function isVisible(asteroid:Asteroid):Bool
	{
		if ((Math.abs(asteroid.x - ShootEmUp.StageWidthHalf) < (ShootEmUp.StageWidthHalf + 16)) &&
			(Math.abs(asteroid.y - ShootEmUp.StageHeightHalf) < (ShootEmUp.StageHeightHalf + 16)))
			return true;
		 
		return false;
	}
	
	public function tick(deltaTime:Float):Void
	{
		for (asteroid in _asteroids)
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
}