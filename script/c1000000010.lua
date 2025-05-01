--Tubaravalo
function c1000000010.initial_effect(c)
	c:EnableReviveLimit()
	-- Fusão com 2 monstros ESPECÍFICOS (IDs fixos):
	Fusion.AddProcMix(c, true, true, 1000000004, 1000000006)
end
