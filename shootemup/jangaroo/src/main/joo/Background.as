package 
{
import flash.display.Bitmap;
import flash.display.Sprite;

public class Background extends Sprite
{
	[Embed(source = "../assets/images/space.jpg")]
	private var space:Class;
	
	public function Background() 
	{
		addChild(new space());
	}
}}