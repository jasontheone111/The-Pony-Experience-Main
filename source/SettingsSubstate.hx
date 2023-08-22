package;

import Math;
import flash.display.Stage;
import flash.display.StageDisplayState;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.ui.FlxUIInputText;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.scaleModes.BaseScaleMode;
import flixel.system.scaleModes.FixedScaleAdjustSizeScaleMode;
import flixel.system.scaleModes.StageSizeScaleMode;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.xml.Access;
import hscript.Expr;
import hscript.Interp;
import hscript.Parser;
import lime.app.Application;
import lime.utils.Assets;
import openfl.Lib;
import openfl.geom.Rectangle;
import openfl.system.System;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
#if desktop
import sys.FileSystem;
import sys.io.File;
#end

// import flixel.addons.ui.FlxUISlider;
class SettingsSubstate extends flixel.FlxSubState
{
	private var menuBase:FlxSprite;
	var settingsTxt:FlxText = new FlxText(200, 200, 0, "Settings", 80);

	var volumeBarBG:FlxSprite;
	var volumeBar:FlxSprite;
	var volumeKnob:FlxSprite;

	var usernameBox:FlxUIInputText;
	var usernameText:FlxText = new FlxText(200, 200, 0, "Username: ", 15);

	var globalUsername:String = FlxG.save.data.ponyUsername;

	//	var volumeSlider:FlxUISlider;
	var volume:Float = 1;

	override public function create()
	{
		menuBase = new FlxSprite(0, 0).loadGraphic(Paths.image('menuBase'));
		menuBase.scrollFactor.set(0, 0);
		menuBase.scale.x = 0.7;
		menuBase.scale.y = 0.7;
		menuBase.updateHitbox();
		menuBase.x = (FlxG.camera.width / 2) - (menuBase.width / 2) + 35;
		menuBase.y = menuBase.y + 1000;
		menuBase.antialiasing = true;
		add(menuBase);

		settingsTxt.alignment = CENTER;
		settingsTxt.font = "equestria.otf";
		settingsTxt.color = 0xFFFFFFFF;
		settingsTxt.angle = 8;
		settingsTxt.x += 20;
		settingsTxt.y += 20;
		add(settingsTxt);

		volumeBarBG = new FlxSprite(0, 0).loadGraphic(Paths.image('settingsStuff/volumeBarBG'));
		volumeBarBG.scrollFactor.set(0, 0);
		volumeBarBG.scale.x = 0.7;
		volumeBarBG.scale.y = 0.7;
		volumeBarBG.updateHitbox();
		volumeBarBG.x = menuBase.x + (menuBase.width / 2) - (volumeBarBG.width / 2) - 35;
		volumeBarBG.antialiasing = true;
		// add(volumeBarBG);

		volumeBar = new FlxSprite(0, 0).loadGraphic(Paths.image('settingsStuff/volumeBar'));
		volumeBar.scrollFactor.set(0, 0);
		volumeBar.scale.x = 0.7;
		volumeBar.scale.y = 0.7;
		volumeBar.updateHitbox();
		volumeBar.x = menuBase.x + (menuBase.width / 2) - (volumeBar.width / 2) - 35;
		volumeBar.antialiasing = true;
		// add(volumeBar);

		volumeKnob = new FlxSprite(0, 0).loadGraphic(Paths.image('settingsStuff/knob'));
		volumeKnob.scrollFactor.set(0, 0);
		volumeKnob.scale.x = 0.7;
		volumeKnob.scale.y = 0.7;
		volumeKnob.updateHitbox();
		volumeKnob.x = menuBase.x + (menuBase.width / 2) - (volumeKnob.width / 2) - 35;
		volumeKnob.antialiasing = true;
		// add(volumeKnob);

		usernameBox = new FlxUIInputText(menuBase.x, menuBase.y, 200, 'Username', 15, 0xFFF4288F, 0xFFF4288F, true);
		usernameBox.setFormat(Paths.font("equestria.otf"), 23, FlxColor.WHITE, LEFT);
		if (globalUsername == null)
		{
			usernameBox.text = "Username";
		}
		else
		{
			usernameBox.text = globalUsername;
		}
		usernameText.setFormat(Paths.font("equestria.otf"), 23, FlxColor.WHITE, LEFT);
		usernameText.text = "Username: ";
		usernameText.y = usernameBox.y;
		usernameText.x = usernameBox.x - usernameText.width;
		add(usernameText);

		add(usernameBox);

		// volumeSlider = new FlxUISlider(this, 'volume', 120, 120, 0, 1, 150, null, 5, FlxColor.WHITE, FlxColor.BLACK);
		// volumeSlider.nameLabel.text = 'Volume';
		// add(volumeSlider);

		// settingsTxt.setFormat('equestria.otf', 32);

		FlxTween.tween(menuBase, {y: (FlxG.camera.height / 2) - (menuBase.height / 2)}, 1, {ease: FlxEase.quintOut});
		super.create();
	}

	// public static var stage(get, never):Stage;

	override public function update(elapsed:Float)
	{
		// FlxG.scaleMode = new FixedScaleAdjustSizeScaleMode();
		// stage.__resize(Lib.application.window.width, Lib.application.window.height);
		// FlxG.scaleMode.scale.x = 5;
		settingsTxt.x = menuBase.x + 185;
		settingsTxt.y = menuBase.y + 15;

		usernameText.y = menuBase.y + 175;
		usernameText.x = menuBase.x + 200 - usernameText.width;

		usernameBox.x = menuBase.x + 200;
		usernameBox.y = menuBase.y + 175;

		volumeBarBG.y = menuBase.y + 200;
		volumeBar.y = menuBase.y + 203;
		volumeKnob.y = menuBase.y + 175;

		if (FlxG.keys.justPressed.ANY && usernameBox.hasFocus)
		{
			FlxG.save.data.ponyUsername = usernameBox.text;
		}
		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxTween.tween(menuBase, {y: menuBase.y + 1000}, 1, {
				ease: FlxEase.quintIn,
				onComplete: function(twn:FlxTween)
				{
					close();
				}
			});
		}
		super.update(elapsed);
	}
}
