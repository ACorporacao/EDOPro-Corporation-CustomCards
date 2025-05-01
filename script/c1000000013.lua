--Hidra
function c1000000013.initial_effect(c)
	-- Fusão com 3 cópias do mesmo monstro
	c:EnableReviveLimit()
	Fusion.AddProcMix(c, true, true, 1000000012, 1000000012, 1000000012)
end
