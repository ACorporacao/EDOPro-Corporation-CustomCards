-- Chimpanzini Bananini
local c302 = {}

c302.initial_effect = function(c)
	-- Invocação-Especial da mão se apenas o oponente controlar monstros
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(302, 0)) -- Descrição do efeito (use um ID único)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION) -- Ativável manualmente
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c302.spcon) -- Verifica a condição
	e1:SetTarget(c302.sptg) -- Define o alvo
	e1:SetOperation(c302.spop) -- Executa a operação
	c:RegisterEffect(e1)
end

-- Condição: Somente o oponente controla monstros
function c302.spcon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetFieldGroupCount(tp, LOCATION_MZONE, 0) == 0 -- Você não tem monstros
		and Duel.GetFieldGroupCount(1-tp, LOCATION_MZONE, 0) > 0 -- O oponente tem pelo menos 1
end

-- Alvo: Permitir Invocação-Especial
function c302.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and e:GetHandler():IsCanBeSpecialSummoned(e, 0, tp, false, false) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
end

-- Operação: Invocar o monstro
function c302.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
	end
end

return c302