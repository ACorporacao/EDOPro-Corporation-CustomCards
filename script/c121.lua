-- Fundador
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()

	-- Invocação-Xyz personalizada
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.xyzcon)
	e1:SetOperation(s.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)

	-- Cadeia não pode ser respondida à invocação
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	c:RegisterEffect(e2)

	-- Imune a efeitos/alvo se controlar Ficha do Colossal
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.indcon)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.indcon)
	e4:SetValue(s.efilter)
	c:RegisterEffect(e4)

	-- Não pode atacar
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e5)

	-- Invocar 2 Fichas
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(s.tkcon)
	e6:SetTarget(s.tktg)
	e6:SetOperation(s.tkop)
	c:RegisterEffect(e6)
end

-- Filtro dos monstros Xyz AOT
function s.xyzfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x100) and c:IsCanBeXyzMaterial()
end

-- Condição de invocação personalizada
function s.xyzcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(function(tc) return tc:IsCode(101) end, tp, LOCATION_GRAVE, 0, 1, nil)
		and Duel.GetMatchingGroupCount(s.xyzfilter, tp, LOCATION_GRAVE, 0, nil) >= 4
end

-- Operação da invocação personalizada
function s.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	-- Seleciona Eren (código 101)
	local eren=Duel.SelectMatchingCard(tp, function(tc) return tc:IsCode(101) end, tp, LOCATION_GRAVE, 0, 1, 1, nil)
	if #eren==0 then return end

	-- Seleciona 4 monstros Xyz AOT
	local xyzs=Duel.SelectMatchingCard(tp, s.xyzfilter, tp, LOCATION_GRAVE, 0, 4, 4, nil)
	if #xyzs<4 then return end

	-- Define os materiais e faz overlay
	eren:Merge(xyzs)
	c:SetMaterial(eren)
	Duel.Overlay(c, eren)
end

-- Condição para imunidade
function s.indcon(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,124)
end
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

-- Invocação de Fichas
function s.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>=2
end
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,124,0x100,TYPES_TOKEN,3000,3000,10,RACE_BEASTWARRIOR,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0)
end
function s.tkop(e,tp,eg,ep,ev,re,r,rp)
	for i=1,2 do
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local token=Duel.CreateToken(tp,124)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end
