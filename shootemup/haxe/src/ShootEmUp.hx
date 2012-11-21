package ;

import mylittleframework.CollidingItem;
import mylittleframework.CollisionEngine;
import mylittleframework.Ticktock;

import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;

import nme.events.Event;

import nme.Lib;

import nme.text.TextField;

/**
 * ...
 * @author Sebastiano Mandalà @sebify
 * 
 * Little experiment made to test haxe + jeash
 * 
 * Code design is acceptable, but not great
 * Mild code optimization, could be improved
 * 
 * Asset from: http://www.lostgarden.com/​2005/03/​download-complete-set-of-sw​eet-8-bit.html
 * 
 */

class ShootEmUp extends Sprite 
{
	static public var StageWidthHalf:Float;
	static public var StageHeightHalf:Float;
	static public var NumberOfEnemiesKilled:Float;
		
	private var _asteroidEngine:AsteroidEngine;
	private var _collisionEngine:CollisionEngine;
	private var _enemyEngine:EnemyEngine;
	private var _camera:Camera;
	private var textBox:TextField;
	private var _lastTime:Float;
	private var _FPS:Float;
	private var _ticktock:Ticktock;
			
	public function new () 
	{
		super ();
		
		_FPS = 0;
				
		initialize ();
	}
	
	private function initialize ():Void 
	{
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		
		this.addEventListener(Event.ADDED_TO_STAGE, onStage);	
	}
	
	private function onStage(evt:Event):Void
	{
		this.removeEventListener(Event.ADDED_TO_STAGE, onStage);//otherwise it is called twice
		
		StageWidthHalf = stage.stageWidth / 2;
		StageHeightHalf = stage.stageHeight / 2;
		
		var bg:Background = new Background();
		
		addChild(bg);
		
		_ticktock = new mylittleframework.Ticktock(stage);
		_collisionEngine = new CollisionEngine();
		_asteroidEngine = new AsteroidEngine(stage);
		
		var spaceShip:SpaceShip = new SpaceShip(new BulletEngine(stage, _collisionEngine));
		addChild(spaceShip);
		
		_enemyEngine = new EnemyEngine(stage, spaceShip, _collisionEngine);
		
		var collidingItem:CollidingItem = new CollidingItem(spaceShip);
		collidingItem.collidesWidth(Enemy);
		
		_collisionEngine.add(collidingItem);

		_ticktock.tick(spaceShip);
		_ticktock.tick(_enemyEngine);
		_ticktock.tick(_asteroidEngine);
		_ticktock.tick(_collisionEngine);
		
		textBox = new TextField();
		textBox.width = 800;
		textBox.textColor = 0xFFFFFFFF;
		this.addChild(textBox); 
		
		textBox.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		_lastTime = flash.Lib.getTimer();
		
		NumberOfEnemiesKilled = 0;
	}
	
	// Entry point
	public static function main () 
	{
		Lib.current.addChild (new ShootEmUp());
	}
	
	private function onEnterFrame(evt:Event):Void
	{
		var time:Float = flash.Lib.getTimer();
				
		textBox.text = " FPS: " +  Std.string(_FPS).substr(0, 5) + " " + (time - _lastTime) + " Enemies Killed:" + NumberOfEnemiesKilled + " Energy: "+ SpaceShip.Energy;
				
		_FPS = (_FPS * 0.9) + ((1000 / ((time - _lastTime))) * 0.1);
		
		_lastTime = time; 
	}
}