--(DEV)Porco Galliard
local s,id = GetID()
function s.initial_effect(c)
	-- Efeito de aumentar ATK de monstros Attack On Titan
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_FZONE) -- A carta deve estar em uma zona de campo
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.atkfilter)
	e1:SetValue(300)
	c:RegisterEffect(e1)
end

function s.atkfilter(c)
	return c:IsSetCard(0x100) -- Filtro para monstros da série Attack On Titan
end