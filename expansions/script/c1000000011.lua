--Pegaso
function c1000000011.initial_effect(c)
	c:EnableReviveLimit()
	-- Fusão com 2 monstros ESPECÍFICOS (IDs fixos):
	Fusion.AddProcMix(c, true, true, 1000000006, 1000000003)
end
