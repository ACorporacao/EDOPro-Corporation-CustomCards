--(DEV)Titan de Ataque
local s,id = GetID()
function s.initial_effect(c)
	-- Restrição de Invocação Xyz
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,s.matfilter,4,1) -- Nível 4, 1 material
end

-- Filtro para material Xyz (Eren Yeager que não foi Invocado Normalmente neste turno)
function s.matfilter(c)
	return c:IsCode(101) and not c:IsSummonType(SUMMON_TYPE_NORMAL)
end

-- EFEITO 01: Perfuração
function s.initial_effect(c)
	-- ...
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)

	-- EFEITO 02: Após 3 Fases Finais do oponente, invocar Eren Yeager
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCondition(s.spcon)
	e2:SetOperation(s.spop)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)

	-- EFEITO 03: Autodestruição se não tiver Eren Yeager como material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.descon)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
end

-- EFEITO 02: Contador de turnos e invocação de Eren Yeager
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetTurnPlayer()==tp then return false end
	if not c:IsSummonType(SUMMON_TYPE_XYZ) then return false end

	if not c:GetFlagEffectLabel(id) then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,3)
		return false
	end

	local ct=c:GetFlagEffectLabel(id)
	if ct and ct<2 then
		c:SetFlagEffectLabel(id,ct+1)
		return false
	end

	return true
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	local yg=og:Filter(Card.IsCode,nil,101)
	if #yg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=yg:Select(tp,1,1,nil):GetFirst()
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

-- EFEITO 03: Destruição se não houver Eren Yeager entre os materiais
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	return og:FilterCount(Card.IsCode,nil,101)==0
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Destroy(c,REASON_EFFECT)
end