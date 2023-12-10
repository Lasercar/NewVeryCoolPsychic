-- Dialogue shit
local playDialogue = false;
local playedVideo = false;
function onCreate() -- Lasercar - no more split second frame without the black screen (in psych 0.7.1h)
	if not playedVideo and isStoryMode and not seenCutscene then
	makeLuaSprite('blackTransition', nil, -500, -400);
	makeGraphic('blackTransition', screenWidth * 2, screenHeight * 2, '000000');
	addLuaSprite('blackTransition', true);
	setProperty('camHUD.visible', false);
	end
end

function onStartCountdown()
	if not playedVideo and isStoryMode and not seenCutscene then -- Block the first countdown and play video cutscene
		startVideo('Psychic_Cutscene');
		playDialogue = true;
		playedVideo = true;
		return Function_Stop;
	elseif playDialogue then -- Block the second countdown and start a timer of 0.8 seconds to play the dialogue
		playedVideo = true;
		playDialogue = false;
		playMusic('psy-dialogue', 0, true);
		soundFadeIn(nil, 2);
		setProperty('inCutscene', true);

		setProperty('camGame.zoom', 0.65);
		runTimer('startZoom', 0.75);
		runTimer('startDialogue', 2.75);

		return Function_Stop;
	end
	return Function_Continue;
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'startDialogue' then -- Timer completed, play dialogue
		startDialogue('dialogue');
		setProperty('camHUD.visible', true);
	elseif tag == 'startZoom' then
		doTweenZoom('camGameZoomTwn', 'camGame', getProperty('defaultCamZoom'), 2, 'quadInOut');
		doTweenAlpha('blackTransitionTwn', 'blackTransition', 0, 2, 'sineOut');
	elseif tag == 'endSongAgain' then
		endSong();
	elseif tag == 'startBlackTrans' then
		doTweenAlpha('blackTransitionEndTwn', 'blackTransition', 0.8, 6, 'sineOut');
	elseif tag == 'endSongBlackTrans' then
		doTweenAlpha('blackTransitionTwn', 'blackTransition', 0, 1, 'linear');
	end
end

function onTweenCompleted(tag)
	if tag == 'blackTransitionTwn' then
		removeLuaSprite('blackTransition');
	end
end


-- End cutscene
local allowEnd = false;
function onEndSong()
	if not allowEnd and isStoryMode then
		allowEnd = true;
		setProperty('inCutscene', true);
		setProperty('boyfriendGroup.visible', false);
		setProperty('gf.stunned', true);
		setProperty('dad.stunned', true);

		makeLuaSprite('blackTransition', nil, -500, -400);
		makeGraphic('blackTransition', screenWidth * 2, screenHeight * 2, '000000');
		addLuaSprite('blackTransition', true);
		setProperty('blackTransition.alpha', 0);

		cutsceneX = 804;
		cutsceneY = 176;
		playSound('bf_transform');
		makeAnimatedLuaSprite('cutsceneBf', 'psychic/bf-senpai_cutscene', cutsceneX, cutsceneY);
		addAnimationByPrefix('cutsceneBf', 'cutscene', 'BF transform', 24, false);
		addLuaSprite('cutsceneBf', true);

		doTweenZoom('camGameZoomTwn', 'camGame', 1, 6, 'sineInOut');
		doTweenAlpha('camHUDAlphaTwn', 'camHUD', 0, 1, 'linear'); 
		doTweenX('camFollowPosXTwn', getProperty('camGame.scroll'), cutsceneX + 260 -(screenWidth / 2), 6, 'quadOut'); --Lasercar - this tween gets stopped/the camera reset when the song changes in Psych 0.71h and I can't be bothered to figure out how to fix it
		doTweenY('camFollowPosYTwn', getProperty('camGame.scroll'), cutsceneY + 400 -(screenHeight / 2), 6, 'quadOut');
		runTimer('startBlackTrans', 1.5);
		runTimer('endSongBlackTrans', 11);
		runTimer('endSongAgain', 15);
		return Function_Stop;
	end
	return Function_Continue;
end
