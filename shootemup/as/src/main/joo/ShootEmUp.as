package 
{
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;

import flash.events.Event;

import flash.text.TextField;

import flash.utils.getTimer;

import mylittleframework.CollidingItem;
import mylittleframework.CollisionEngine;
import mylittleframework.Ticktock;

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

 [SWF(width="1100", height="600", backgroundColor="#FFFFFF")]
public class ShootEmUp extends Sprite
{
	static public var StageWidthHalf:Number;
	static public var StageHeightHalf:Number;
	static public var NumberOfEnemiesKilled:Number;
		
	private var _asteroidEngine:AsteroidEngine;
	private var _collisionEngine:CollisionEngine;
	private var _enemyEngine:EnemyEngine;
	private var _camera:Camera;
	private var textBox:TextField;
	private var _lastTime:Number;
	private var _FPS:Number;
	private var _ticktock:Ticktock;
	
	public function ShootEmUp () 
	{
		super ();
		
		_FPS = 0;
				
		initialize ();
	}
	
	private function initialize ():void 
	{
		stage.align = StageAlign.TOP_LEFT;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		
		StageWidthHalf = stage.stageWidth / 2;
		StageHeightHalf = stage.stageHeight / 2;
		
		addChild(new Background);
		
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
		_lastTime = getTimer();
		
		NumberOfEnemiesKilled = 0;
	}
	
	private function onEnterFrame(evt:Event):void
	{
		var time:Number = getTimer();
				
		textBox.text = " FPS: " + (_FPS.toString()).substr(0, 5) + " " + (time - _lastTime) + " Enemies Killed:" + NumberOfEnemiesKilled + " Energy: "+ SpaceShip.Energy;
				
		_FPS = (_FPS * 0.9) + ((1000 / ((time - _lastTime))) * 0.1);
		
		_lastTime = time; 
	}
}
}