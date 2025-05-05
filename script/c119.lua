--(DEV)Titan Mandibula
local s,id = GetID()
function s.initial_effect(c)
	-- Só pode ser Invocado por Invocação-Xyz (manual)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.xyzcon)
	e1:SetOperation(s.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
end

-- Filtro para Eren Yeager (c101)
function s.matfilter(c)
	return c:IsFaceup() and c:IsCode(109) and s.checkErenCondition(c)
end

-- Condição personalizada
function s.checkErenCondition(c)
	local turn_id = Duel.GetTurnCount()
	local summon_turn = c:GetTurnID()
	local summon_type = c:GetSummonType()
	
	-- Se foi Invocado Especialmente, pode sempre
	if (summon_type & SUMMON_TYPE_SPECIAL) == SUMMON_TYPE_SPECIAL then
		return true
	end

	-- Se foi Invocado Normalmente, só se não for neste turno
	if (summon_type & SUMMON_TYPE_NORMAL) == SUMMON_TYPE_NORMAL then
		return summon_turn < turn_id
	end

	return false
end

-- Condição de Invocação Xyz
function s.xyzcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.matfilter,tp,LOCATION_MZONE,0,1,nil)
end

-- Operação da Invocação Xyz
function s.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,s.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end