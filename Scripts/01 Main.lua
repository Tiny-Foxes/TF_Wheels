-- LoadModule is by default included in 5.3, If people use 5.1 load 5.3's version manualy.
if not LoadModule then 
	function LoadModule(ModuleName,...)
	
		local Path = THEME:GetCurrentThemeDirectory().."Modules/"..ModuleName
	
		for _,theme in pairs(THEME:get_theme_fallback_list()) do
			if not FILEMAN:DoesFileExist(Path) then
				Path = "Appearance/Themes/"..theme.."/Modules/"..ModuleName
			end
		end
	
		if not FILEMAN:DoesFileExist(Path) then
			Path = "Appearance/Themes/_fallback/Modules/"..ModuleName
		end
	
		if ... then
			return loadfile(Path)(...)
		end
		return loadfile(Path)()
	end
end

-- We hate using globals, So use 1 global table.
TF_WHEEL = {}

TF_WHEEL.MPath = THEME:GetCurrentThemeDirectory().."Modules/"

function Actor:ForParent(Amount)
	local CurSelf = self
	for i = 1,Amount do
		CurSelf = CurSelf:GetParent()
	end
	return CurSelf
end

-- Change Difficulties to numbers.
TF_WHEEL.DiffTab = { 
	["Difficulty_Beginner"] = 1,
	["Difficulty_Easy"] = 2,
	["Difficulty_Medium"] = 3,
	["Difficulty_Hard"] = 4,
	["Difficulty_Challenge"] = 5,
	["Difficulty_Edit"] = 6
}

-- Resize function, We use this to resize images to size while keeping aspect ratio.
function TF_WHEEL.Resize(width,height,setwidth,sethight)

	if height >= sethight and width >= setwidth then
		if height*(setwidth/sethight) >= width then
			return sethight/height
		else
			return setwidth/width
		end
	elseif height >= sethight then
		return sethight/height
	elseif width >= setwidth then
		return setwidth/width
	else 
		return 1
	end
end

-- TO WRITE DOC.
function TF_WHEEL.CountingNumbers(self,NumStart,NumEnd,Duration)
	self:stoptweening()

	TF_WHEEL.Cur = 1
	TF_WHEEL.Count = {}
		
	local Length = (NumEnd - NumStart)/10
	if string.format("%.0f",Length) == "0" then Length = 1 end
	if string.format("%.0f",Length) == "-0" then Length = -1 end
	
	if not self:GetCommand("Count") then
		self:addcommand("Count",function(self) 
			self:settext(TF_WHEEL.Count[TF_WHEEL.Cur])
			TF_WHEEL.Cur = TF_WHEEL.Cur + 1 
		end)
	end
	
	for n = NumStart,NumEnd,string.format("%.0f",Length) do	
		TF_WHEEL.Count[#TF_WHEEL.Count+1] = string.format("%.0f",n)
		self:sleep(Duration/10):queuecommand("Count")
	end
	TF_WHEEL.Count[#TF_WHEEL.Count+1] = string.format("%.0f",NumEnd)
	self:sleep(Duration/10):queuecommand("Count")
end

-- Main Input Function.
-- We use this so we can do ButtonCommand.
-- Example: MenuLeftCommand=function(self) end.
function TF_WHEEL.Input(self)
	return function(event)
		if not event.PlayerNumber then return end
		self.pn = event.PlayerNumber		
		if ToEnumShortString(event.type) == "FirstPress" or ToEnumShortString(event.type) == "Repeat" then
			self:queuecommand(event.GameButton)			
		end
		if ToEnumShortString(event.type) == "Release" then
			self:queuecommand(event.GameButton.."Release")	
		end
	end
end