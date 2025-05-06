-- Progenitora
local s,id=GetID()

-- Definindo constante de vitória por efeito (caso não esteja no core do EDOPro)
local WIN_REASON_PROGENITORA = 0x1A  -- valor qualquer que represente vitória por efeito

function s.initial_effect(c)
	c:EnableReviveLimit()

	-- Invocação Especial: Sacrificar Titan Fundador
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	-- Efeito 01: Invocação não pode ser negada
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)

	-- Efeito 02: Imune a todos os efeitos
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)

	-- Efeito 03: Vitória instantânea ao ser invocada
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL) end)
	e4:SetOperation(function(_,tp) Duel.Win(tp, WIN_REASON_PROGENITORA) end)
	c:RegisterEffect(e4)
end

function s.spfilter(c,tp)
	return c:IsCode(121) and c:IsReleasable() and c:IsControler(tp)
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(s.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil,c:GetControler())
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end

function s.efilter(e,te)
	return true -- Imune a todos os efeitos
end
