-- Paradis
local s,id=GetID()
function s.initial_effect(c)
	-- Ativação normal de Spell de Campo
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	-- E1: Monstros Guerreiro de Nível 4 "Attack On Titan" ganham 300 ATK
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.statfilter)
	e1:SetValue(300)
	c:RegisterEffect(e1)

	-- E2: Monstros Guerreiro de Nível 4 "Attack On Titan" ganham 300 DEF
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.statfilter)
	e2:SetValue(300)
	c:RegisterEffect(e2)

	-- E3: Monstros Guerreiro de Nível 4 "Attack On Titan" não são afetados por Magias
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.statfilter)
	e3:SetValue(s.immval)
	c:RegisterEffect(e3)
end

-- Filtro único para ATK/DEF/Imunidade
function s.statfilter(e,c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsLevel(4) and c:IsSetCard(0x100)
end

-- Imunidade contra Magias
function s.immval(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
