local USWN = {}

--Defining on which direction the other directions should be bassed on
--This will let us use less files which is quite handy to keep the noteskin directory nice
--Do remember this will Redirect all the files of that Direction to the Direction its pointed to
--If you only want some files to be redirected take a look at the "custom hold/roll per direction"
USWN.ButtonRedir =
{
	Up = "Down",
	Down = "Down",
	Left = "Down",
	Right = "Down"
}

-- Defined the parts to be rotated at which degree
USWN.Rotate =
{
	Up = 180,
	Down = 0,
	Left = 90,
	Right = -90
}

USWN.ElementRedir =
{
	["Roll Head Active"] = "Tap Note",
	["Roll Head Inactive"] = "Tap Note",
	["Hold Head Active"] = "Hold Head",
	["Hold Head Inactive"] = "Hold Head",
	["Tap Fake"] = "Tap Note",
	["Roll Explosion"] = "Hold Explosion",
	["Tap Explosion Dim"] = "Tap Explosion Bright"
}

USWN.PartsToRotate =
{
	["Receptor"] = true,
	["Tap Explosion Bright"] = true,
	["Tap Explosion Dim"] = true,
	["Tap Note"] = true,
	["Tap Fake"] = true,
	["Tap Addition"] = true,
	["Hold Explosion"] = true,
	["Hold Head Active"] = true,
	["Hold Head Inactive"] = true,
	["Roll Explosion"] = true,
	["Roll Head Active"] = true,
	["Roll Head Inactive"] = true
}

USWN.Blank =
{
	["Hold Tail Active"] = true,
	["Hold Tail Inactive"] = true,
	["Roll Tail Active"] = true,
	["Roll Tail Inactive"] = true,
}

function USWN.Load()
	local sButton = Var "Button"
	local sElement = Var "Element"

	local Button = USWN.ButtonRedir[sButton] or sButton	
	local Element = USWN.ElementRedir[sElement] or sElement

	if string.find(Element, "Active") or 
	   string.find(Element, "Inactive") then
		Button = sButton
	end
	
	local Actor = loadfile(NOTESKIN:GetPath(Button,Element))
	
	if type(Actor) == "function" then
		Actor = Actor(nil)
	else
		Actor = Def.Sprite { Texture=NOTESKIN:GetPath(Button,Element) }
	end
	
	if USWN.Blank[sElement] then
		Actor = Def.Actor {}
		if Var "SpriteOnly" then
			Actor = Def.Sprite{ Texture=NOTESKIN:GetPath("","_blank") }
		end
	end
	
	if USWN.PartsToRotate[sElement] then
		Actor.BaseRotationZ = USWN.Rotate[sButton] or nil
	end
		
	return Actor
end

return USWN
