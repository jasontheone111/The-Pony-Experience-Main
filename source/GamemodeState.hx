package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.xml.Access;
import lime.app.Application;
import lime.utils.Assets;
import openfl.geom.Rectangle;
import openfl.system.System;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

class GamemodeState extends FlxState
{
	private var bg:FlxSprite;
	private var lock:FlxSprite;
	private var explorationTile:FlxSprite;
	private var storymodeTile:FlxSprite;

	override public function create()
	{
		bg = new FlxSprite(0, 0).loadGraphic(Paths.image('storymenu/bg'));
		bg.scrollFactor.set(0, 0);
		bg.scale.x = 0.7;
		bg.scale.y = 0.7;
		bg.updateHitbox();
		bg.x = (FlxG.camera.width / 2) - (bg.width / 2);
		bg.y = (FlxG.camera.height / 2) - (bg.height / 2);
		bg.updateHitbox();
		bg.antialiasing = true;
		add(bg);

		explorationTile = new FlxSprite(700, 80);
		explorationTile.frames = Paths.getSparrowAtlas('storymenu/exploration');
		explorationTile.animation.addByPrefix('activate', "Activate", 24, false);
		explorationTile.animation.addByPrefix('deactivate', "Deactivate", 24, false);
		explorationTile.animation.play('deactivate', false, false, 4);
		explorationTile.scale.set(0.6, 0.6);
		explorationTile.scrollFactor.set(0, 0);
		explorationTile.antialiasing = false;
		explorationTile.updateHitbox();
		add(explorationTile);

		storymodeTile = new FlxSprite(250, 80);
		storymodeTile.frames = Paths.getSparrowAtlas('storymenu/storymode');
		storymodeTile.animation.addByPrefix('activate', "Activate", 24, false);
		storymodeTile.animation.addByPrefix('deactivate', "Deactivate", 24, false);
		storymodeTile.scrollFactor.set(0, 0);
		storymodeTile.animation.play('deactivate', false, false, 4);
		storymodeTile.scale.set(0.6, 0.6);
		storymodeTile.antialiasing = false;
		storymodeTile.updateHitbox();
		add(storymodeTile);

		lock = new FlxSprite(0, 0).loadGraphic(Paths.image('lock'));
		lock.scrollFactor.set(0, 0);
		lock.updateHitbox();
		lock.scale.set(0.4, 0.4);
		lock.x = (storymodeTile.width / 2) - (lock.width / 2);
		lock.y = (storymodeTile.height / 2) - (lock.height / 2);
		lock.updateHitbox();
		lock.x += 235;
		lock.y += 150;
		lock.antialiasing = true;
		lock.angle = -45;
		add(lock);

		changeSelection(0);
		tweenLock();
		super.create();
	}

	var curSelected = 1;
	var finishedAnim = false;

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ESCAPE)
		{
			// close();
			FlxG.switchState(new PlayState());
		}
		if (FlxG.keys.justPressed.ENTER)
		{
			if (curSelected == 2)
			{
				openSubState(new MapState());
			}
			if (curSelected == 1)
			{
				lock.scale.set(0.7, 0.7);
				FlxTween.tween(lock.scale, {x: 0.4, y: 0.4}, 0.4, {ease: FlxEase.quadOut});
			}
		}

		if (FlxG.keys.justPressed.LEFT)
		{
			trace('Left Key');
			changeSelection(1); // fnf style ye, it works well true
		}
		else if (FlxG.keys.justPressed.RIGHT)
		{
			changeSelection(-1);
		}

		super.update(elapsed);
	}

	function changeSelection(change:Int)
	{
		curSelected += change;
		if (curSelected < 1)
		{
			curSelected = 2;
		}
		else
		{
			if (curSelected > 2)
			{
				curSelected = 1;
			}
		}
		if (curSelected == 2)
		{
			explorationTile.animation.play('activate');
			storymodeTile.animation.play('deactivate');
		}
		else
		{
			explorationTile.animation.play('deactivate');
			storymodeTile.animation.play('activate');
		}
		trace(curSelected);
	}

	function tweenLock()
	{
		FlxTween.tween(lock, {angle: 45}, 2, {
			ease: FlxEase.sineInOut,
			onComplete: function(twn:FlxTween)
			{
				FlxTween.tween(lock, {angle: -45}, 2, {
					ease: FlxEase.sineInOut,
					onComplete: function(twn:FlxTween)
					{
						tweenLock();
					}
				});
			}
		});
	}
}
// I'm supposed to be finishing up an essay rn hold holdllll
