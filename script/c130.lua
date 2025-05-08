-- Magia de Campo: Ataque dos Titãs
local s,id=GetID()
function s.initial_effect(c)
	-- Ativação padrão de Field Spell
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	-- Efeito 1: Todos os monstros Xyz Attack On Titan ganham 500 ATK/DEF
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(s.xyzfilter)
	e1:SetValue(500)
	c:RegisterEffect(e1)

	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)

	-- Efeito 2: Monstros Xyz Attack On Titan não são afetados por Magias
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(s.xyzfilter)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)
end

-- Filtro para monstros Xyz Attack On Titan
function s.xyzfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x100) -- Assumindo que 'Attack On Titan' tem o código 0x100
end

-- Filtro de imunes a Magias
function s.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL) -- Protege contra Magias
end
