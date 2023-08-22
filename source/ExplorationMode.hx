package;
//server stuff
import lime.app.Future;
import haxe.Http;
import haxe.http.HttpJs;

import flixel.graphics.FlxGraphic;

import Math;
import flash.display.Stage;
import flash.display.StageDisplayState;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
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
using StringTools;

class ExplorationMode extends FlxState
{
	private var ipAddress:String = "10.0.0.1";
	private var port:String = "11111";
	private var townhall:FlxSprite;
	private var applejack:FlxSprite = new FlxSprite(0, 0);

	var camFollowPos = new FlxObject(0, 0, 1, 1);

	var globalUsername:String = FlxG.save.data.ponyUsername;

	var usernameText:FlxText = new FlxText(200, 200, 0, "", 30);

	var chatBox:FlxSprite = new FlxSprite(0,0);
	var names:Array<Dynamic> = [];

	function formatText(txt:String)
		{
			var finalTxt:String = txt.toLowerCase(); //
            finalTxt = finalTxt.replace(' ', "-"); // what are you doing? removing spaces that's what this line does
			return finalTxt;
		}
	override public function create()
	{
		var future = new Future(function () {
            //charName = charName.replace(' ', "-");
            var isCool = new Http('http://$ipAddress:$port/ponygameconnections');
            isCool.setParameter('name', formatText(globalUsername));
            isCool.request(true);
            var serverResponse = isCool.responseData;
			trace(serverResponse);
            var r = ~/[|]+/g;

            var responseArray = r.split(serverResponse);
			trace(responseArray);
			for (i in 0...responseArray.length)
				{
					names.push(responseArray[i]);
				}
			trace(names); 
        }, true); 

		Paths.returnGraphic('ponyville/townhall');

		FlxG.camera.follow(camFollowPos, LOCKON, 1);

		townhall = new FlxSprite(0, 0).loadGraphic(Paths.image('ponyville/townhall'));
		townhall.scrollFactor.set(1, 1);
		townhall.updateHitbox();
		townhall.antialiasing = true;
		add(townhall);

		applejack.frames = Paths.getSparrowAtlas('basecharacter/applejack');
		applejack.animation.addByPrefix('idle', "idle", 24, false);
		applejack.animation.addByPrefix('walk', "walk", 24, true);
		applejack.scrollFactor.set(0, 0);
		applejack.animation.play('idle');
		// applejack.scale.set(0.4, 0.4);
		applejack.screenCenter(XY);
		applejack.antialiasing = true;
		applejack.updateHitbox();
		add(applejack);

		usernameText.scrollFactor.set(0, 0);
		usernameText.alignment = CENTER;
		usernameText.font = "equestria.otf";
		usernameText.color = 0xFFFFFFFF;
		add(usernameText);

		camFollowPos.x = 2780;
		camFollowPos.y = 2793;
		// camera.zoom = 0.1;

		chatBox.makeGraphic(300, 250, 0xFF000000);
		chatBox.scrollFactor.set(0, 0);
		chatBox.y = FlxG.height - 10 - chatBox.height;
		chatBox.x += 10;
		chatBox.alpha = 0.2;
		add(chatBox);
		super.create();
	}

	var moveAmount:Int = 3;
	var epdateFlipX:Bool = true;

	override public function update(elapsed:Float)
	{
		//ServerCode.updateServer(elapsed);
		for (name in 0...names.length)
			{
				trace(names[name]);
			}
		ServerCode.updatePos('$globalUsername', camFollowPos.x, camFollowPos.y);
		applejack.screenCenter(XY);
		usernameText.screenCenter(X);
		usernameText.y = applejack.y + applejack.height + 20;
		usernameText.visible = FlxG.mouse.overlaps(applejack);
		usernameText.text = globalUsername;
		if (FlxG.keys.justPressed.ESCAPE)
		{
			// close();
			FlxG.switchState(new PlayState());
		}
		if (FlxG.keys.pressed.SHIFT)
		{
			moveAmount = 5;
		}
		else
		{
			if (FlxG.keys.pressed.CONTROL)
			{
				moveAmount = 10;
			}
			else
			{
				moveAmount = 3;
			}
		}
		if (FlxG.keys.pressed.LEFT)
		{
			if (epdateFlipX)
			{
				applejack.flipX = false;
			}
			camFollowPos.x -= moveAmount;
		}
		if (FlxG.keys.pressed.RIGHT)
		{
			if (epdateFlipX)
			{
				applejack.flipX = true;
			}
			camFollowPos.x += moveAmount;
		}
		if (FlxG.keys.pressed.UP)
		{
			camFollowPos.y -= moveAmount;
		}
		if (FlxG.keys.pressed.DOWN)
		{
			camFollowPos.y += moveAmount;
		}

		if (FlxG.keys.justPressed.LEFT)
		{
			applejack.animation.play('walk');
		}

		if (FlxG.keys.justPressed.R)
		{
			trace("Pressed Secret Key (R), Enabling Moonwalk");
			epdateFlipX = false;
			applejack.flipX = !applejack.flipX;
		}
		else if (FlxG.keys.justPressed.RIGHT)
		{
			applejack.animation.play('walk');
		}
		if (!FlxG.keys.pressed.RIGHT && !FlxG.keys.pressed.LEFT)
		{
			applejack.animation.play('idle');
		}
		if (FlxG.keys.released.RIGHT && FlxG.keys.released.LEFT)
		{
			epdateFlipX = true;
		}

		if (camFollowPos.x > 7620)
		{
			camFollowPos.x -= moveAmount;
		}
		if (camFollowPos.x < 162)
		{
			camFollowPos.x += moveAmount * 1;
		}
		if (FlxG.keys.justPressed.ENTER)
		{
			trace("Y: " + camFollowPos.y);
			trace("X: " + camFollowPos.x);
		}
		super.update(elapsed);
	}
}
