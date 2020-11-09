-- The wheels we support/have.
local Wheels = {
	"DDR1st1.5Wheel",
	"DDR2ndMIXCLUBVERSiON2Wheel",
	"DDR3rdMixPlusWheel",
	"DDR4thMixPlusWheel",
	"DDR5thMixWheel"
}

-- The Styles that are defined for the game mode.
local GameModeStyles = {
	["dance"] = "dance_single",
	["pump"] = "pump_single",
}

-- The last defined wheel, Its like smart shuffle, We dont want to get the same wheel twice.
if not Last then Last = 0 end

-- Our random suffle function.
local function RandButNotLast(Amount)
	local Now
	while true do
		Now = math.random(1,Amount)
		if Now ~= Last then break end
	end
	Last = Now
	return Now
end

--Return the Def table that contains all the stuff, Check the module folder for the wheels.
return LoadModule("Wheel."..Wheels[RandButNotLast(#Wheels)]..".lua")(GameModeStyles[GAMESTATE:GetCurrentGame():GetName()] or "dance_single")