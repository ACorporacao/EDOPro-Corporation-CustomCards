-- Paradis
local s,id=GetID()
function s.initial_effect(c)
	-- Ativação normal de Spell de Campo
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	-- E1: Todos os Monstros Xyz Attack On Titan ganham 500 ATK/DEF
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(function(e,c) return c:IsSetCard(0x100) and c:IsType(TYPE_XYZ) end)
	e1:SetValue(500)
	c:RegisterEffect(e1)

	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)


	-- E2: Monstros Xyz "Attack On Titan" não são afetados por Magias
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.statfilter)
	e3:SetValue(s.immval)
	c:RegisterEffect(e3)
end

-- Filtro: Monstros Xyz do arquétipo "Attack On Titan"
function s.statfilter(e,c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x100)
end

-- Imunidade apenas contra efeitos de Magias
function s.immval(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
