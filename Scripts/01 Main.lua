-- LoadModule is by default included in 5.3, If people use 5.1 load 5.3's version manualy.
if not LoadModule then
	function LoadModule(ModuleName, ...)

		local Path = THEME:GetCurrentThemeDirectory() .. "Modules/" .. ModuleName

		if THEME.get_theme_fallback_list then -- pre-5.1 support.
			for _, theme in pairs(THEME:get_theme_fallback_list()) do
				if not FILEMAN:DoesFileExist(Path) then
					Path = "Appearance/Themes/" .. theme .. "/Modules/" .. ModuleName
				end
			end
		end

		if not FILEMAN:DoesFileExist(Path) then
			Path = "Appearance/Themes/_fallback/Modules/" .. ModuleName
		end

		if ... then
			return loadfile(Path)(...)
		end
		return loadfile(Path)()
	end
end

-- We hate using globals, So use 1 global table.
TF_WHEEL = {}

LoadModule("Row.Prefs.lua")(LoadModule("Options.Prefs.lua"))

TF_WHEEL.StyleDB = {
	--Dance
	["dance_single"] = "single",
	["dance_double"] = "double",
	["dance_couple"] = "couple",
	["dance_solo"] = "solo",
	["dance_threepanel"] = "threepanel",
	["dance_routine"] = "routine",

	--Pump
	["pump_single"] = "single",
	["pump_halfdouble"] = "halfdouble",
	["pump_double"] = "double",
	["pump_couple"] = "couple",
	["pump_routine"] = "routine",

	--SMX
	["smx_single"] = "single",
	["smx_double6"] = "double6",
	["smx_double10"] = "double10",
	["smx_couple"] = "couple",
	["smx_routine"] = "routine",

	--Ez2
	["ez2_single"] = "single",
	["ez2_double"] = "double",
	["ez2-real"] = "real",

	--Para
	["para_single"] = "single",
	["para_double"] = "double",
	["para_eight"] = "single-eight",

	--Ds3ddx
	["ds3ddx_single"] = "single",
	["ds3ddx_double"] = "double",
	["ds3ddx_single5"] = "single5",
	["ds3ddx_double5"] = "double5",
	["ds3ddx_routine5"] = "routine5",

	--Be-Mu
	["bm_single5"] = "single5",
	["bm_double5"] = "double5",
	["bm_single6"] = "single6",
	["bm_double6"] = "double6",
	["bm_single7"] = "single7",
	["bm_double7"] = "double7",

	--Maniax
	["maniax_single"] = "single",
	["maniax_double"] = "double",

	--Stepstage
	["stepstage_single"] = "single",
	["stepstage_twin"] = "twin-single",

	--Techno
	["techno_single4"] = "single4",
	["techno_single5"] = "single5",
	["techno_single8"] = "single8",
	["techno_single9"] = "single9",
	["techno_double4"] = "double4",
	["techno_double5"] = "double5",
	["techno_double8"] = "double8",
	["techno_double9"] = "double9",

	--Po-Mu
	["pnm_three"] = "po-mu-three",
	["pnm_four"] = "po-mu-four",
	["pnm_five"] = "po-mu-five",
	["pnm_seven"] = "po-mu-seven",
	["pnm_nine"] = "po-mu-nine",
	["pnm_nine_double"] = "po-mu-nine-double",

	--Gddm
	["gddm_real"] = "gddm-real",
	["gddm_new"] = "gddm-new",
	["gddm_old"] = "gddm-old",

	--Gdgf
	["gdgf_five"] = "five-fret",
	["gdgf_six"] = "six-fret",
	["gdgf_three"] = "three-fret",
	["gdgf_bass_five"] = "five-fret",
	["gdgf_bass_six"] = "five-fret",
	["gdgf_bass_three"] = "five-fret",

	--GH
	["gh_solo"] = "solo",
	["gh_solo6"] = "solo6",
	["gh_bass"] = "bass",
	["gh_bass6"] = "bass6",
	["gh_rhythm"] = "rhythm",
	["gh_rhythm6"] = "rhythm6",

	--KBX
	["kb1_single"] = "single1",
	["kb2_single"] = "single2",
	["kb3_single"] = "single3",
	["kb4_single"] = "single4",
	["kb5_single"] = "single5",
	["kb6_single"] = "single6",
	["kb7_single"] = "single7",
	["kb8_single"] = "single8",
	["kb9_single"] = "single9",
	["kb10_single"] = "single10",
	["kb11_single"] = "single11",
	["kb12_single"] = "single12",
	["kb13_single"] = "single13",
	["kb14_single"] = "single14",
	["kb15_single"] = "single15",

	--Taiko
	["taiko"] = "taiko-single",

	--Lights
	["lights_cabinet"] = "cabinet",

	--Kickbox
	["kickbox_human"] = "human",
	["kickbox_quadarm"] = "quadarm",
	["kickbox_insect"] = "insect",
	["kickbox_arachnid"] = "arachnid"
}

TF_WHEEL.StyleDBVersus = {
	--Dance
	["dance_single"] = "versus",
	["dance_threepanel"] = "threepanel-versus",

	--Pump
	["pump_single"] = "versus",

	--SMX
	["smx_single"] = "versus",

	--Ez2
	["ez2_single"] = "versus",
	["ez2-real"] = "versusReal",

	--Para
	["para_single"] = "versus",

	--Ds3ddx
	["ds3ddx_single"] = "versus",
	["ds3ddx_single5"] = "versus5",

	--Be-Mu
	["bm_single5"] = "versus5",
	["bm_single6"] = "versus6",
	["bm_single7"] = "versus7",

	--Maniax
	["maniax_single"] = "versus",

	--Stepstage
	["stepstage_single"] = "versus",
	["stepstage_twin"] = "twin-versus",

	--Techno
	["techno_single4"] = "versus4",
	["techno_single5"] = "versus5",
	["techno_single8"] = "versus8",
	["techno_single9"] = "versus9",

	--Po-Mu
	["pnm_three"] = "po-mu-three-versus",
	["pnm_four"] = "po-mu-four-versus",
	["pnm_five"] = "po-mu-five-versus",
	["pnm_seven"] = "po-mu-seven-versus",
	["pnm_nine"] = "po-mu-nine-versus",

	--Gdgf
	["gdgf_five"] = "five-fret-versus",
	["gdgf_six"] = "six-fret-versus",
	["gdgf_three"] = "three-fret-versus",
	["gdgf_bass_five"] = "five-fret-versus",
	["gdgf_bass_six"] = "five-fret-versus",
	["gdgf_bass_three"] = "five-fret-versus",

	--GH
	["gh_solo"] = "solo-versus",
	["gh_solo6"] = "solo-versus6",
	["gh_bass"] = "bass-versus",
	["gh_bass6"] = "bass-versus6",
	["gh_rhythm"] = "rhythm-versus",
	["gh_rhythm6"] = "rhythm-versus6",

	--Taiko
	["taiko"] = "taiko-versus",

	--Kickbox
	["kickbox_human"] = "hversus",
	["kickbox_quadarm"] = "qversus",
	["kickbox_insect"] = "iversus",
	["kickbox_arachnid"] = "aversus"
}

TF_WHEEL.MPath = THEME:GetCurrentThemeDirectory() .. "Modules/"

function Actor:ForParent(Amount)
	local CurSelf = self
	for i = 1, Amount do
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
	["Difficulty_Edit"] = 6,
	["Difficulty_D7"] = 7,
	["Difficulty_D8"] = 8,
	["Difficulty_D9"] = 9,
	["Difficulty_D10"] = 10,
	["Difficulty_D11"] = 11,
	["Difficulty_D12"] = 12,
	["Difficulty_D13"] = 13,
	["Difficulty_D14"] = 14,
	["Difficulty_D15"] = 15
}

-- Resize function, We use this to resize images to size while keeping aspect ratio.
function TF_WHEEL.Resize(width, height, setwidth, sethight, preserve)
	if height >= sethight and width >= setwidth then
		if height * (setwidth / sethight) >= width then
			return preserve and setwidth / width or sethight / height
		else
			return preserve and sethight / height or setwidth / width
		end
	elseif height >= sethight then
		return sethight / height
	elseif width >= setwidth then
		return setwidth / width
	else
		return 1
	end
end

-- TO WRITE DOC.
function TF_WHEEL.CountingNumbers(self, NumStart, NumEnd, Duration, format)
	self:stoptweening()

	TF_WHEEL.Cur = 1
	TF_WHEEL.Count = {}

	if format == nil then format = "%.0f" end

	local Length = (NumEnd - NumStart) / 10
	if string.format("%.0f", Length) == "0" then Length = 1 end
	if string.format("%.0f", Length) == "-0" then Length = -1 end

	if not self:GetCommand("Count") then
		self:addcommand("Count", function(self)
			self:settext(TF_WHEEL.Count[TF_WHEEL.Cur])
			TF_WHEEL.Cur = TF_WHEEL.Cur + 1
		end)
	end

	for n = NumStart, NumEnd, string.format("%.0f", Length) do
		TF_WHEEL.Count[#TF_WHEEL.Count + 1] = string.format(format, n)
		self:sleep(Duration / 10):queuecommand("Count")
	end
	TF_WHEEL.Count[#TF_WHEEL.Count + 1] = string.format(format, NumEnd)
	self:sleep(Duration / 10):queuecommand("Count")
end

function TF_WHEEL.FormatAddNewline(Text, Amount)
	local Amount = Amount or 20
	local count = 0
	local out = ""

	for char in string.gmatch(Text, ".") do
		if char == "\n" then char = " " end
		if count > Amount and char == " " then
			char = char .. "\n"
			count = 0
		end
		out = out .. char
		count = count + 1
	end
	return out
end

-- Main Input Function.
-- We use this so we can do ButtonCommand.
-- Example: MenuLeftCommand=function(self) end.
function TF_WHEEL.Input(self)
	return function(event)
		if not event.PlayerNumber then return end
		self.pn = event.PlayerNumber
		if ToEnumShortString(event.type) == "FirstPress" or ToEnumShortString(event.type) == "Repeat" then
			self:playcommand(event.GameButton)
		end
		if ToEnumShortString(event.type) == "Release" then
			self:playcommand(event.GameButton .. "Release")
		end
	end
end
