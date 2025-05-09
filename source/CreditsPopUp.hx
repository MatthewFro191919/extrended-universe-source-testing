package;

import sys.FileSystem;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.math.FlxMath;

typedef SongHeading = {
	var path:String;
	var antiAliasing:Bool;
	var ?animation:Animation;
	var iconOffset:Float;
}
class CreditsPopUp extends FlxSpriteGroup
{
	public var bg:FlxSprite;
	public var bgHeading:FlxSprite;

	public var funnyText:FlxText;
	public var funnyIcon:FlxSprite;
	var iconOffset:Float;
	var curHeading:SongHeading;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		bg = new FlxSprite().makeGraphic(400, 50, FlxColor.WHITE);
		add(bg);
		var songCreator:String = '';
		var songCreatorIcon:String = '';
		var headingPath:SongHeading = null;

		switch (PlayState.SONG.song.toLowerCase())
		{
		  case 'black-spikes' | 'blue-stars' | 'contented' | 'breakpoint' | 'fully-breakfast' | 'stars' | 'goldy-breaker' | 'polynomial' | 'goofy-keyboard' | 'Iniustitiam' | 'codekill':
			songCreator = 'stremblix';
		  case 'burger-blast':
			songCreator = 'hazetal';
		  case 'deep-dish':
			songCreator = 'zlix';
		  case 'powerfull-wheelchair' | 'corned' | 'whoopsie' | 'get-ready':
			songCreator = 'roblox2aj';
		  case 'binomial':
			songCreator = 'amgunt';
		  case 'egg-torsion':
			songCreator = null;
		}
		switch (PlayState.storyWeek)
		{
			case 0:
				headingPath = {path: 'songHeadings/stremblixHeading', antiAliasing: false, iconOffset: 0};
			case 1:
				headingPath = {path: 'songHeadings/hazetalHeading', antiAliasing: true, iconOffset: 0};
			case 2:
				headingPath = {path: 'songHeadings/zlixHeading', antiAliasing: false, iconOffset: 0};
			case 3:
				headingPath = {path: 'songHeadings/roblox2ajHeading', antiAliasing: true, iconOffset: 0};
			case 4:
				headingPath = {path: 'songHeadings/amguntHeading', antiAliasing: false, iconOffset: 0};
			case 5:
                		bg = new FlxSprite().makeGraphic(400, 50, FlxColor.WHITE);
        	}
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'polygonized' | 'interdimensional':
				headingPath = {path: 'songHeadings/3D-daveHeading', antiAliasing: false, iconOffset: 0};				
		}
		if (headingPath != null)
		{
			if (headingPath.animation == null)
			{
				bg.loadGraphic(Paths.image(headingPath.path));
			}
			else
			{
				var info = headingPath.animation;
				bg.frames = Paths.getSparrowAtlas(headingPath.path);
				bg.animation.addByPrefix(info.name, info.prefixName, info.frames, info.looped, info.flip[0], info.flip[1]);
				bg.animation.play(info.name);
			}
			bg.antialiasing = headingPath.antiAliasing;
			curHeading = headingPath;
		}
		createHeadingText('Song by $songCreator');
		
		funnyIcon = new FlxSprite(0, 0, Paths.image('songCreators/' + songCreator));
		rescaleIcon();
		add(funnyIcon);

		rescaleBG();

		var yValues = CoolUtil.getMinAndMax(bg.height, funnyText.height);
		funnyText.y = funnyText.y + ((yValues[0] - yValues[1]) / 2);
	}
	public function switchHeading(newHeading:SongHeading)
	{
		if (bg != null)
		{
			remove(bg);
		}
		bg = new FlxSprite().makeGraphic(400, 50, FlxColor.WHITE);
		if (newHeading != null)
		{
			if (newHeading.animation == null)
			{
				bg.loadGraphic(Paths.image(newHeading.path));
			}
			else
			{
				var info = newHeading.animation;
				bg.frames = Paths.getSparrowAtlas(newHeading.path);
				bg.animation.addByPrefix(info.name, info.prefixName, info.frames, info.looped, info.flip[0], info.flip[1]);
				bg.animation.play(info.name);
			}
		}
		bg.antialiasing = newHeading.antiAliasing;
		curHeading = newHeading;
		add(bg);
		
		rescaleBG();
	}
	public function changeText(newText:String, newIcon:String, rescaleHeading:Bool = true)
	{
		createHeadingText(newText);
		
		if (funnyIcon != null)
		{
			remove(funnyIcon);
		}
		funnyIcon = new FlxSprite(0, 0, Paths.image('songCreators/' + newIcon, 'shared'));
		rescaleIcon();
		add(funnyIcon);

		if (rescaleHeading)
		{
			rescaleBG();
		}
	}
	function createHeadingText(text:String)
	{
		if (funnyText != null)
		{
			remove(funnyText);
		}
		funnyText = new FlxText(1, 0, 650, text, 16);
		funnyText.setFormat('Comic Sans MS Bold', 30, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		funnyText.borderSize = 2;
		funnyText.antialiasing = true;
		add(funnyText);
	}
	public function rescaleIcon()
	{
		var offset = (curHeading == null ? 0 : curHeading.iconOffset);

		var scaleValues = CoolUtil.getMinAndMax(funnyIcon.height, funnyText.height);
		funnyIcon.setGraphicSize(Std.int(funnyIcon.height / (scaleValues[1] / scaleValues[0])));
		funnyIcon.updateHitbox();

		var heightValues = CoolUtil.getMinAndMax(funnyIcon.height, funnyText.height);
		funnyIcon.setPosition(funnyText.textField.textWidth + offset, (heightValues[0] - heightValues[1]) / 2);
	}
	function rescaleBG()
	{
		bg.setGraphicSize(Std.int((funnyText.textField.textWidth + funnyIcon.width + 0.5)), Std.int(funnyText.height + 0.5));
		bg.updateHitbox();
	}
}
