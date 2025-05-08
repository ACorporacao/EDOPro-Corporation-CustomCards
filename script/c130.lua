-- Paradis
local s,id=GetID()
function s.initial_effect(c)
	-- Ativação
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	-- ATK +300
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.statfilter)
	e2:SetValue(300)
	c:RegisterEffect(e2)

	-- DEF +300
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)

	-- Imunidade contra Magias
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(s.statfilter)
	e4:SetValue(s.immval)
	c:RegisterEffect(e4)
end

-- Alvo: Guerreiro, Nível 4, do arquétipo 0x100
function s.statfilter(e,c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsLevel(4) and c:IsSetCard(0x100)
end

-- Imunidade apenas a Magias
function s.immval(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
