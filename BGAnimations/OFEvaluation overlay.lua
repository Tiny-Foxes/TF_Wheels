-- The Evals we support/have.
local Evals = {
	"DDR1st1.5Eval",
	"DDR1stEval"
}

-- The last defined eval, Its like smart shuffle, We dont want to get the same eval twice.
if not TF_WHEEL.LastE then TF_WHEEL.LastE = 0 end

-- Our random suffle function.
local function RandButNotLast(Amount)
	local Now
	while true do
		Now = math.random(1,Amount)
		if Now ~= TF_WHEEL.LastE then break end
	end
	TF_WHEEL.LastE = Now
	return Now
end

--Return the Def table that contains all the stuff, Check the module folder for the evals.
return LoadModule("Eval."..Evals[RandButNotLast(#Evals)]..".lua")()

--Debugging.
--return LoadModule("Eval.DDR1st1.5Eval.lua")()