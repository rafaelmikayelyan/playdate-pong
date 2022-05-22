local PD <const> = playdate
local SND <const> = PD.sound

local function newSynth(a, d, s, r, volume, sound)
	local synth = SND.synth.new(sound)
	synth:setADSR(a, d, s, r)
	synth:setVolume(volume)
	return synth
end

beep = newSynth(0, 0.04, 0, 0, 0.1, SND.kWaveSawtooth)

function getCollideSound(int)
    local pitch

    if int < 0 then
        pitch = 100
    elseif int == 0 then
        pitch = 150
    else
        pitch = 200
    end

    beep:playNote(pitch)
end