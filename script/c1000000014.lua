function c1000000014.initial_effect(c)
	c:EnableReviveLimit()
	-- Fusão com 2 monstros ESPECÍFICOS (IDs fixos):
	Fusion.AddProcMix(c, true, true, 
	1000000001, 
	aux.FilterBoolFunctionEx(Card.IsRace,RACE_WINGEDBEAST), 
	aux.FilterBoolFunctionEx(Card.IsRace,RACE_REPTILE))
end