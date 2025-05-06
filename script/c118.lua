-- Titan Martelo de Guerra
local s,id=GetID()
function s.initial_effect(c)
	-- Invocação Especial da mão
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	-- Imune a Armadilhas durante a Fase de Batalha
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.battle_phase_con)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)

	-- Destruir se Lara for enviada da mão para o cemitério/banida
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.descon)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)

	-- EFEITO 05: Imune a Armadilhas durante a Fase de Batalha
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(s.trapcon)
	e5:SetValue(s.trapimmune)
	c:RegisterEffect(e5)

	-- EFEITO 06: Autodestruição se "Lara Tybur" for da mão ao cemitério ou for banida
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(s.descon1)
	e6:SetOperation(s.desop)
	c:RegisterEffect(e6)

	local e6b=e6:Clone()
	e6b:SetCode(EVENT_REMOVE)
	e6b:SetCondition(s.descon2)
	c:RegisterEffect(e6b)

end

-- Invocação Especial
function s.spfilter(c,tp)
	return c:IsCode(108) and c:IsControler(tp) and c:IsAbleToHandAsCost()
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SendtoHand(g,nil,REASON_COST)
end

-- Imunidade a Armadilhas durante a Fase de Batalha
function s.battle_phase_con(e)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function s.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end



-- Destruição se "Lara Tybur" for enviada da mão
function s.desfilter(c,tp)
	return c:IsCode(108) and c:IsPreviousLocation(LOCATION_HAND) and c:GetPreviousControler()==tp
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.desfilter,1,nil,tp)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end

function s.trapcon(e)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function s.trapimmune(e,te)
	return te:IsActiveType(TYPE_TRAP)
end

--===
function s.desfilter(c,tp)
	return c:IsCode(108) and c:IsPreviousLocation(LOCATION_HAND) and c:GetPreviousControler()==tp
end

function s.descon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.desfilter,1,nil,tp)
end

function s.descon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.desfilter,1,nil,tp)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
