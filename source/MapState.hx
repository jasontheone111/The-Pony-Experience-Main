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

class MapState extends flixel.FlxSubState
{
	private var map:FlxSprite;
	private var hitbox:FlxSprite;

	// var camera = new FlxCamera();
	var camFollowPos = new FlxObject(0, 0, 1, 1);

	override public function create()
	{
		/*
			FlxG.cameras.reset(camera);
			FlxG.cameras.add(camera, false);
			FlxG.cameras.setDefaultDrawTarget(camera, true); //You continue code I play game ok */

		map = new FlxSprite(0, 0).loadGraphic(Paths.image('explorationmap/map'));
		map.scrollFactor.set(0, 0);
		map.scale.x = 0.7;
		map.scale.y = 0.7;
		// map.screenCenter(XY);
		map.updateHitbox();
		map.x = (FlxG.camera.width / 2) - (map.width / 2);
		map.y = (FlxG.camera.height / 2) - (map.height / 2);
		map.updateHitbox();
		map.antialiasing = true;
		add(map);

		hitbox = new FlxSprite(518, 367).loadGraphic(Paths.image('explorationmap/hitbox'));
		hitbox.scrollFactor.set(0, 0);
		hitbox.scale.x = 0.7;
		hitbox.scale.y = 0.7;
		// map.screenCenter(XY);
		hitbox.updateHitbox();
		hitbox.antialiasing = true;
		hitbox.visible = false;
		add(hitbox);
		FlxG.camera.follow(camFollowPos, LOCKON, 1);

		super.create();
	}

	var amountOfTimesClicked:Int = 0;

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ESCAPE)
		{
			camera.zoom = 1;
			close();
		}

		if (FlxG.mouse.visible)
		{
			// Play button code
			if (FlxG.mouse.overlaps(hitbox))
			{
				if (FlxG.mouse.justPressed)
				{
					FlxG.sound.play(Paths.sound('click lol'), 0.7, false, null, false);
					trace('Is cool');
					if (amountOfTimesClicked == 0)
					{
						FlxTween.tween(camera, {zoom: 2.3}, 0.95, {ease: FlxEase.quintInOut});

						FlxTween.tween(map, {x: map.x + 60}, 0.95,
							{ease: FlxEase.quintInOut}); // What? what are these forrr?? <-- When zooms in they ain't centered
						FlxTween.tween(hitbox, {x: hitbox.x + 60}, 0.95, {ease: FlxEase.quintInOut}); // Back cool

						FlxTween.tween(map, {y: map.y - 30}, 0.95, {ease: FlxEase.quintInOut});
						FlxTween.tween(hitbox, {y: hitbox.y - 30}, 0.95, {ease: FlxEase.quintInOut});
					}
					if (amountOfTimesClicked == 1)
					{
						FlxG.switchState(new ExplorationMode());
					}
					amountOfTimesClicked++;
				}
			}
		}

		super.update(elapsed);
	}
}
