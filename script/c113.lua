-- Titan Assaltante Eren Yeager
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

	-- EFEITO 02: Após 3 Fases Finais do oponente, Invoca Especialmente o Eren Yeager" usado como material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.spcon)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

-- Filtro para Eren Yeager (c101)
function s.matfilter(c)
	return c:IsFaceup() and c:IsCode(101) and s.checkErenCondition(c)
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

-- ===== EFEITO 02: Invocação automática do Eren após 3 Fases Finais do oponente =====

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- Contamos apenas Fases Finais do oponente
	if Duel.GetTurnPlayer()~=tp then
		local ct=c:GetFlagEffectLabel(id) or 0
		ct=ct+1
		c:ResetFlagEffect(id)
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
		c:SetFlagEffectLabel(id,ct)
		return ct==3
	end
	return false
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	local eren=og:Filter(Card.IsCode,nil,101):GetFirst()
	if eren and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Overlay(c,og:Filter(aux.NOT(Card.IsCode),nil,101)) -- Remove outros materiais se houver
		Duel.SpecialSummon(eren,0,tp,tp,false,false,POS_FACEUP)
	end
end