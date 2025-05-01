local s, id = GetID()

function s.initial_effect(c)
	-- Invocação-Especial automática (sem botão de ativação)
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O) -- Tipo mais adequado para resposta rápida
	e1:SetCode(EVENT_FREE_CHAIN) -- Pode ser ativado a qualquer momento
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end

function s.spcon(e, tp, eg, ep, ev, re, r, rp)
	-- Só pode ser Invocado se o oponente controlar um monstro e você não
	return Duel.GetFieldGroupCount(tp, LOCATION_MZONE, 0) == 0
		and Duel.GetFieldGroupCount(1-tp, LOCATION_MZONE, 0) > 0
		and Duel.GetCurrentPhase() == PHASE_MAIN1 or Duel.GetCurrentPhase() == PHASE_MAIN2 -- Só na Main Phase
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
			and e:GetHandler():IsCanBeSpecialSummoned(e, 0, tp, false, false)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
	end
end