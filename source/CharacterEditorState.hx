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
import flixel.addons.ui.FlxUICheckBox;
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

class CharacterEditorState extends FlxState
{
	private var bg:FlxSprite;
	// Tail, Base, Hair, Mane, Hat, Ear
	private var tail:FlxSprite = new FlxSprite(0, 0);
	private var base:FlxSprite = new FlxSprite(0, 0);
	private var hair:FlxSprite = new FlxSprite(0, 0);
	private var mane:FlxSprite = new FlxSprite(0, 0);
	private var hat:FlxSprite = new FlxSprite(0, 0);
	private var ear:FlxSprite = new FlxSprite(0, 0);

	private var checkBoxHAT:FlxSprite = new FlxSprite(0, 0);

	var hairType:String = "-style-1";
	var tailType:String = "-style-1";
	var maneType:String = "-style-1";

	var showHat:Bool = true;

	override public function create()
	{
		bg = new FlxSprite(0, -2).loadGraphic(Paths.image('charactereditor/boutique'));
		bg.scrollFactor.set(0, 0);
		bg.scale.x = 0.7;
		bg.scale.y = 0.7;
		bg.updateHitbox();
		bg.antialiasing = true;
		add(bg);

		tail.frames = Paths.getSparrowAtlas('character/tail' + tailType);
		tail.animation.addByPrefix('idle', "idle", 24, false);
		tail.animation.addByPrefix('walk', "walk", 24, true);
		tail.scrollFactor.set(0, 0);
		tail.animation.play('idle');
		tail.screenCenter(XY);
		tail.antialiasing = true;
		tail.updateHitbox();
		add(tail);

		base.frames = Paths.getSparrowAtlas('character/base');
		base.animation.addByPrefix('idle', "idle", 24, false);
		base.animation.addByPrefix('walk', "walk", 24, true);
		base.scrollFactor.set(0, 0);
		base.animation.play('idle');
		base.screenCenter(XY);
		base.antialiasing = true;
		base.updateHitbox();
		add(base);

		hair.frames = Paths.getSparrowAtlas('character/hair' + hairType);
		hair.animation.addByPrefix('idle', "idle", 24, false);
		hair.animation.addByPrefix('walk', "walk", 24, true);
		hair.scrollFactor.set(0, 0);
		hair.animation.play('idle');
		hair.screenCenter(XY);
		hair.antialiasing = true;
		hair.updateHitbox();
		add(hair);

		mane.frames = Paths.getSparrowAtlas('character/mane' + maneType);
		mane.animation.addByPrefix('idle', "idle", 24, false);
		mane.animation.addByPrefix('walk', "walk", 24, true);
		mane.scrollFactor.set(0, 0);
		mane.animation.play('idle');
		mane.screenCenter(XY);
		mane.antialiasing = true;
		mane.updateHitbox();
		add(mane);

		hat.frames = Paths.getSparrowAtlas('character/hataj');
		hat.animation.addByPrefix('idle', "idle", 24, false);
		hat.animation.addByPrefix('walk', "walk", 24, true);
		hat.scrollFactor.set(0, 0);
		hat.animation.play('idle');
		hat.screenCenter(XY);
		hat.antialiasing = true;
		hat.updateHitbox();
		add(hat);

		ear.frames = Paths.getSparrowAtlas('character/baseear');
		ear.animation.addByPrefix('idle', "idle", 24, false);
		ear.animation.addByPrefix('walk', "walk", 24, true);
		ear.scrollFactor.set(0, 0);
		ear.animation.play('idle');
		ear.screenCenter(XY);
		ear.antialiasing = true;
		ear.updateHitbox();
		add(ear);

		// showHat = new FlxUICheckBox(10, 15, null, true, "Hat", 100);

		checkBoxHAT = new FlxSprite(100, 220).loadGraphic(Paths.image('charactereditor/checkbox-false'));
		checkBoxHAT.scrollFactor.set(0, 0);
		checkBoxHAT.scale.set(0.4, 0.4);
		checkBoxHAT.animation.play('idle');
		// checkBoxHAT.screenCenter(XY);
		checkBoxHAT.antialiasing = true;
		checkBoxHAT.updateHitbox();
		add(checkBoxHAT);
		// add(showHat);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		checkBoxHAT.loadGraphic(Paths.image('charactereditor/checkbox-' + showHat));
		if (FlxG.mouse.overlaps(checkBoxHAT))
		{
			if (FlxG.mouse.justPressed)
			{
				// showHat != showHat;
				if (showHat == false)
				{
					showHat = true;
				}
				else if (showHat == true)
				{
					showHat = false;
				}
			}
		}
		if (FlxG.keys.justPressed.ESCAPE)
		{
			// close();
			FlxG.switchState(new PlayState());
		}
		hat.visible = showHat;
		super.update(elapsed);
	}
}
