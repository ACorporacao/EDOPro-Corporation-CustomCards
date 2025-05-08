-- Paradis
local s,id=GetID()
function s.initial_effect(c)
	-- Ativação normal de Spell de Campo
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	-- E1: Monstros Xyz "Attack On Titan" ganham 500 ATK
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.atktg)
	e1:SetValue(500)
	c:RegisterEffect(e1)

	-- E2: Monstros Xyz "Attack On Titan" ganham 500 DEF
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.deftg)
	e2:SetValue(500)
	c:RegisterEffect(e2)

	-- E3: Monstros Xyz "Attack On Titan" não são afetados por Magias
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.immtg)
	e3:SetValue(s.immval)
	c:RegisterEffect(e3)
end

function s.atktg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x100)
end

function s.deftg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x100)
end

function s.immtg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x100)
end

function s.immval(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
