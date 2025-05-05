--(DEV)Zeke Yeager
local s,id=GetID()
function s.initial_effect(c)
	-- Monstros do arquétipo 0x100 não são afetados por efeitos enquanto esta carta estiver com a face para cima no campo
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.immtg)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
end

-- Alvo: monstros com SetCode 0x100
function s.immtg(e,c)
	return c:IsSetCard(0x100)
end

-- Imunidade a efeitos de qualquer jogador
function s.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end