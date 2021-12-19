-- The Evals we support/have.
local Evals = {
	"DDR1st1.5Eval"
}

-- The last defined eval, Its like smart shuffle, We dont want to get the same eval twice.
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

--Return the Def table that contains all the stuff, Check the module folder for the evals.
--return LoadModule("Eval."..evals[RandButNotLast(#Evals)]..".lua")()

--Debugging.
return LoadModule("Eval.DDR1st1.5Eval.lua")()