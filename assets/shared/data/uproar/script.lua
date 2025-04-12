function onCreate()
	setPropertyFromClass('substates.GameOverSubstate', 'characterName', 'bf-spirit-dead');
	setPropertyFromClass('substates.GameOverSubstate', 'loopSoundName', 'GameOverScary');
	setPropertyFromClass('substates.GameOverSubstate', 'deathSoundName', 'SpiritBFDeath');
	setPropertyFromClass('substates.GameOverSubstate', 'endSoundName', 'SpiritBFRetry');
	setProperty('camZooming', true);
end

local blockEnd = true;
local shouldPlayCutscene = true;
function onEndSong()
	if isStoryMode and blockEnd then
		if shouldPlayCutscene then --Workaround for bug on cutscene
			shouldPlayCutscene = false;
			setProperty('camHUD.visible', false);
			setProperty('camGame.visible', false);
			startVideo('Uproar_Cutscene');
			runTimer('End for real', 155.0);
		end
		return Function_Stop;
	end
	return Function_Continue;
end

function onGameOverConfirm(retry)
	if retry then
		setProperty('boyfriend.visible', false)
	end
end

-- Dialogue shit
local allowCountdown = false;
function onStartCountdown()
	-- Block the first countdown and start the dialogue
	if not allowCountdown and isStoryMode and not seenCutscene then
		allowCountdown = true;
		startDialogue('dialogue', 'Spiritual_Unrest');

		-- snap camera
		cameraSetTarget('boyfriend');
		setProperty('camGame.scroll.x', getProperty('camFollow.x') - 40 -(screenWidth / 2));
		setProperty('camGame.scroll.y', getProperty('camFollow.y') - 40  -(screenHeight / 2));
		return Function_Stop;
	end
	return Function_Continue;
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'End for real' then
		blockEnd = false;
		endSong();
	end
end





