package states;

class TheEndState extends MusicBeatState
{
	var funnyText:Alphabet;
	override function create()
	{
		super.create();

        var text:String; //This local variable didn't like being located in the timer for some reason 
		funnyText = new Alphabet(0, 0, 'The End', true);
		funnyText.screenCenter();
		funnyText.y -= 25;
		add(funnyText);
		funnyText.alpha = 0;

		FlxTween.tween(funnyText, {alpha: 1}, 3,
		{
			onComplete: function(twn:FlxTween)
			{
				new FlxTimer().start(1.5, function(tmr:FlxTimer)
				{
					new FlxTimer().start(0.4, function(tmr:FlxTimer)
					{
						text = funnyText.text;
						switch(tmr.elapsedLoops)
						{
							case 1, 2, 3: text += '.';
							case 4: text += '?';
						}
						@:privateAccess
						funnyText.set_text(text);
						FlxG.sound.play(Paths.sound('dialogue'));
						funnyText.screenCenter(X);
					}, 4);
				});
			}
		});

		FlxTween.tween(funnyText, {alpha: 0}, 2, {
			startDelay: 8,
			onComplete: function(twn:FlxTween)
			{
				MusicBeatState.switchState(new StoryMenuState());
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		});
	}
}
