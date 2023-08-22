package;

#if desktop
// import Discord.DiscordClient;
#end
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

class PlayState extends FlxState
{
	private var ponyBG:FlxSprite;
	private var ponyIconBottom:FlxSprite;
	private var ponyIconTop:FlxSprite;
	var playButton:FlxSprite;
	private var settingsButton:FlxSprite;
	private var characterButton:FlxSprite;
	private var friendsButton:FlxSprite;
	var theScript:String;
	var newCursor:FlxSprite = new FlxSprite(0, 0);

	override public function create()
	{
		#if desktop
		// Updating Discord Rich Presence.
		// DiscordClient.changePresence("In The Main Menu", "The Pony Experience", "icon");
		#end
		Paths.returnGraphic('storymenu/bg');
		Paths.returnGraphic('storymenu/exploration');
		Paths.returnGraphic('storymenu/storymode');
		Paths.returnGraphic('explorationmap/map');
		Paths.returnGraphic('explorationmap/hitbox');

		FlxG.mouse.visible = true;

		ponyBG = new FlxSprite(-645, 0).loadGraphic(Paths.image('ponies yipeeee/ponyBG'));
		ponyBG.scrollFactor.set(0, 0);
		ponyBG.scale.x = 0.475;
		ponyBG.scale.y = 0.475;
		ponyBG.updateHitbox();
		ponyBG.antialiasing = true;
		add(ponyBG);

		ponyIconBottom = new FlxSprite(0, 1000).loadGraphic(Paths.image('ponies yipeeee/logoBottom'));
		ponyIconBottom.scrollFactor.set(0, 0);
		ponyIconBottom.updateHitbox();
		ponyIconBottom.screenCenter(X);
		ponyIconBottom.scale.x = 0.4;
		ponyIconBottom.scale.y = 0.4;
		ponyIconBottom.antialiasing = true;
		add(ponyIconBottom);
		// y = 375
		ponyIconTop = new FlxSprite(0, -500).loadGraphic(Paths.image('ponies yipeeee/logoTop'));
		ponyIconTop.scrollFactor.set(0, 0);
		ponyIconTop.updateHitbox();
		ponyIconTop.screenCenter(X);
		ponyIconTop.scale.x = 0.4;
		ponyIconTop.scale.y = 0.4;
		ponyIconTop.antialiasing = true;
		add(ponyIconTop);

		playButton = new FlxSprite(-650, 420).loadGraphic(Paths.image('ponies yipeeee/playButton'));
		playButton.scrollFactor.set(0, 0);
		playButton.scale.x = 0.4;
		playButton.scale.y = 0.4;
		playButton.updateHitbox();
		playButton.antialiasing = true;
		add(playButton);
		// x = -120

		settingsButton = new FlxSprite(-550, 420).loadGraphic(Paths.image('ponies yipeeee/settingsButton'));
		settingsButton.scrollFactor.set(0, 0);
		settingsButton.scale.x = 0.4;
		settingsButton.scale.y = 0.4;
		settingsButton.updateHitbox();
		settingsButton.antialiasing = true;
		add(settingsButton);

		characterButton = new FlxSprite(-650, 220).loadGraphic(Paths.image('ponies yipeeee/charactersButton'));
		characterButton.scrollFactor.set(0, 0);
		characterButton.scale.x = 0.4;
		characterButton.scale.y = 0.4;
		characterButton.updateHitbox();
		characterButton.antialiasing = true;
		add(characterButton);

		friendsButton = new FlxSprite(-550, 220).loadGraphic(Paths.image('ponies yipeeee/friendsButton'));
		friendsButton.scrollFactor.set(0, 0);
		friendsButton.scale.x = 0.4;
		friendsButton.scale.y = 0.4;
		friendsButton.updateHitbox();
		friendsButton.antialiasing = true;
		add(friendsButton);

		newCursor.frames = Paths.getSparrowAtlas('ponies yipeeee/cursor/cursor');
		newCursor.animation.addByPrefix('idle', "cursor", 24, true);
		newCursor.animation.play('idle');
		newCursor.scale.set(0.175, 0.175);
		newCursor.antialiasing = false;
		newCursor.updateHitbox();
		// add(newCursor);

		// flixel.input.mouse.FlxMouse.load(newCursor);
		#if desktop
		if (sys.FileSystem.exists('mods/'))
		{
			var folders:Array<String> = [];
			for (file in sys.FileSystem.readDirectory('mods/'))
			{
				var path = haxe.io.Path.join(['mods/', file]);
				trace("Loaded: " + file);
				trace(File.getContent(path));
				theScript = File.getContent(path);
			}
		}
		var expr = theScript;
		var parser = new hscript.Parser();
		var ast = parser.parseString(expr);
		var interp = new hscript.Interp();
		interp.execute(ast);
		trace(interp.execute(ast));
		#end
		FlxG.mouse.load(newCursor);

		var volume:Float = 0.5;
		var volumeBar = new FlxBar(ponyIconBottom.x, ponyIconBottom.y, LEFT_TO_RIGHT, 500, 200, this, 'volume', 0, 1);
		volumeBar.scrollFactor.set(1, 1);
		volumeBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
		volumeBar.percent = 100;
		volumeBar.numDivisions = 800; // How much lag this causes?? Should i tone it down to idk, 400 or 200?
		add(volumeBar);

		// x = 300
		if (FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(Paths.sound('menu music'), 0.7);

			FlxTween.tween(ponyIconTop, {y: -25}, 0.95, {ease: FlxEase.quintOut});
			FlxTween.tween(ponyIconBottom, {y: 375}, 0.95, {ease: FlxEase.quintOut});

			new FlxTimer().start(2.1, function(tmr:FlxTimer)
			{
				FlxTween.tween(ponyIconTop, {y: ponyIconTop.y - 125, x: ponyIconTop.x + 387}, 0.6, {ease: FlxEase.sineInOut});
				FlxTween.tween(ponyIconBottom, {y: ponyIconBottom.y - 125, x: ponyIconBottom.x + 387}, 0.6, {ease: FlxEase.sineInOut});
				FlxTween.tween(ponyBG, {y: ponyBG.y - 125, x: ponyBG.x + 387}, 0.6, {ease: FlxEase.sineInOut});
			});

			new FlxTimer().start(4.01, function(tmr:FlxTimer)
			{
				FlxTween.tween(playButton, {x: 120}, 0.9, {ease: FlxEase.quintOut});
			});
			new FlxTimer().start(4.4, function(tmr:FlxTimer)
			{
				FlxTween.tween(settingsButton, {x: 540}, 0.9, {ease: FlxEase.quintOut});
			});
			new FlxTimer().start(4.8, function(tmr:FlxTimer)
			{
				FlxTween.tween(characterButton, {x: 120}, 0.9, {ease: FlxEase.quintOut});
			});
			new FlxTimer().start(5.2, function(tmr:FlxTimer)
			{
				FlxTween.tween(friendsButton, {x: 540}, 0.9, {ease: FlxEase.quintOut});
				// playButton.updateHitbox();
			});
		}
		else
		{
			ponyIconTop.y = -25;
			ponyIconTop.y -= 125;
			ponyIconTop.x += 387;
			ponyIconBottom.y = 375;
			ponyIconBottom.y -= 125;
			ponyIconBottom.x += 387;
			ponyBG.y -= 125;
			ponyBG.x += 387;
			playButton.x = 120;
			settingsButton.x = 540;
			characterButton.x = 120;
			friendsButton.x = 540;
		}
		super.create();
	}

	var updatePlayButton:Bool = true;
	var updatePlayButtonDeselected:Bool = true;

	var updateCharacterButton:Bool = true;
	var updateCharacterButtonDeselected:Bool = true;

	var updateFriendsButton:Bool = true;
	var updateFriendsButtonDeselected:Bool = true;

	var updateSettingsButton:Bool = true;
	var updateSettingsButtonDeselected:Bool = true;

	var e:Float = 0.4;
	var sa:Float = 0;
	var e1:Float = 0.4;
	var sa1:Float = 0;

	var e2:Float = 0.4;
	var sa2:Float = 0;
	var e3:Float = 0.4;
	var sa3:Float = 0;

	// public static var stage(get, never):Stage;

	override public function update(elapsed:Float)
	{
		// FlxG.scaleMode = new FixedScaleAdjustSizeScaleMode();
		// stage.__resize(Lib.application.window.width, Lib.application.window.height);
		// FlxG.scaleMode.scale.x = 5;
		// trace(FlxG.sound.volume); // ?

		newCursor.x = FlxG.game.mouseX;
		newCursor.y = FlxG.game.mouseY;
		e += sa;
		sa /= 2;
		e1 += sa1;
		sa1 /= 2;
		e2 += sa2;
		sa2 /= 2;
		e3 += sa3;
		sa3 /= 2;
		if (playButton.scale.y >= 0.4)
		{
			playButton.scale.set(e, e);
		}
		else
		{
			e = 0.4;
			playButton.scale.set(0.4, 0.4);
		}
		if (characterButton.scale.x >= 0.4)
		{
			characterButton.scale.set(e1, e1);
		}
		else
		{
			e1 = 0.4;
			characterButton.scale.set(0.4, 0.4);
		}
		if (friendsButton.scale.x >= 0.4)
		{
			friendsButton.scale.set(e2, e2);
		}
		else
		{
			e2 = 0.4;
			friendsButton.scale.set(0.4, 0.4);
		}
		if (settingsButton.scale.x >= 0.4)
		{
			settingsButton.scale.set(e3, e3);
		}
		else
		{
			e3 = 0.4;
			settingsButton.scale.set(0.4, 0.4);
		}
		if (FlxG.mouse.justPressed)
		{
			if (FlxG.mouse.overlaps(playButton)
				|| FlxG.mouse.overlaps(characterButton)
				|| FlxG.mouse.overlaps(friendsButton)
				|| FlxG.mouse.overlaps(settingsButton))
			{
				FlxG.sound.play(Paths.sound('click lol'), 0.7, false, null, false);
				// FlxG.sound.playMusic(Paths.sound('click lol'), 0.7, false);
			}
		}
		if (FlxG.mouse.visible)
		{
			// Play button code
			if (FlxG.mouse.overlaps(playButton))
			{
				if (updatePlayButton)
				{
					// FlxTween.tween(e, {0.6}, 0.1, {ease: FlxEase.quintOut});
					sa = 0.01;
					updatePlayButton = false;
					updatePlayButtonDeselected = true;
				}
				if (FlxG.mouse.justPressed)
				{
					// FlxG.switchState(new GamemodeState());
					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						// openSubState(new GamemodeState());
						FlxG.switchState(new GamemodeState());
					});
				}
			}
			else
			{
				if (updatePlayButtonDeselected)
				{
					sa = -0.01;
					// FlxTween.tween(playButton, {scale: 0.4}, 0.1, {ease: FlxEase.quintOut});
					updatePlayButtonDeselected = false;
					updatePlayButton = true;
				}
			}
			// Character button code
			if (FlxG.mouse.overlaps(characterButton))
			{
				if (FlxG.mouse.justPressed)
				{
					// FlxG.switchState(new GamemodeState());
					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						// openSubState(new GamemodeState());
						FlxG.switchState(new CharacterEditorState());
					});
				}
				if (updateCharacterButton)
				{
					// FlxTween.tween(e, {0.6}, 0.1, {ease: FlxEase.quintOut});
					sa1 = 0.01;
					updateCharacterButton = false;
					updateCharacterButtonDeselected = true;
				}
			}
			else
			{
				if (updateCharacterButtonDeselected)
				{
					sa1 = -0.01;
					// FlxTween.tween(playButton, {scale: 0.4}, 0.1, {ease: FlxEase.quintOut});
					updateCharacterButtonDeselected = false;
					updateCharacterButton = true;
				}
			}
			// Friends button code
			if (FlxG.mouse.overlaps(friendsButton))
			{
				if (updateFriendsButton)
				{
					// FlxTween.tween(e, {0.6}, 0.1, {ease: FlxEase.quintOut});
					sa2 = 0.01;
					updateFriendsButton = false;
					updateFriendsButtonDeselected = true;
				}
				if (FlxG.mouse.justPressed)
				{
					trace("Clicked Play Button");
				}
			}
			else
			{
				if (updateFriendsButtonDeselected)
				{
					sa2 = -0.01;
					// FlxTween.tween(playButton, {scale: 0.4}, 0.1, {ease: FlxEase.quintOut});
					updateFriendsButtonDeselected = false;
					updateFriendsButton = true;
				}
			}
			// Settings button code
			if (FlxG.mouse.overlaps(settingsButton))
			{
				if (updateSettingsButton)
				{
					// FlxTween.tween(e, {0.6}, 0.1, {ease: FlxEase.quintOut});
					sa3 = 0.01;
					updateSettingsButton = false;
					updateSettingsButtonDeselected = true;
				}
				if (FlxG.mouse.justPressed)
				{
					openSubState(new SettingsSubstate());
				}
			}
			else
			{
				if (updateSettingsButtonDeselected)
				{
					sa3 = -0.01;
					// FlxTween.tween(playButton, {scale: 0.4}, 0.1, {ease: FlxEase.quintOut});
					updateSettingsButtonDeselected = false;
					updateSettingsButton = true;
				}
			}
		}

		super.update(elapsed);
	}
}
