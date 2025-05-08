local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(s.attg)
	e2:SetValue(500)
	c:RegisterEffect(e2)

	-- Imunidade a Magias
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(s.normtg)
	e3:SetValue(s.immallval)
	c:RegisterEffect(e3)
end

function s.attg(e,c)
	return c:IsSetCard(0x100)
end

-- Alvo para monstros normais do arquétipo 0x100
function s.normtg(e,c)
	return c:IsSetCard(0x100) and c:IsType(TYPE_NORMAL)
end

-- Imune a todos os efeitos do oponente
function s.immallval(e,te)
	return te:GetOwner()~=e:GetHandler():GetOwner()
end