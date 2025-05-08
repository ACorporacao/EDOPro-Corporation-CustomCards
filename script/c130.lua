-- Paradis
local s,id=GetID()
function s.initial_effect(c)
	-- Ativar
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	-- Aumento de ATK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(s.statfilter))
	e2:SetValue(300)
	c:RegisterEffect(e2)

	-- Aumento de DEF
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)

	-- Imunidade a Magias
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(aux.TargetBoolFunction(s.statfilter))
	e4:SetValue(s.immval)
	c:RegisterEffect(e4)
end

-- Filtro com aux.TargetBoolFunction
function s.statfilter(c)
	return c:IsFaceup() and c:IsLevel(4) and c:IsRace(RACE_WARRIOR) and c:IsSetCard(0x100)
end

-- Imune a Magias
function s.immval(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
