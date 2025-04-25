-- Tigre (Dano Perfurante)
function c1000000005.initial_effect(c)
	-- Dano perfurante ao atacar um monstro em posição de defesa
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
end