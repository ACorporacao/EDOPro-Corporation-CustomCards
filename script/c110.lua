-- Pieck Finger
local s,id = GetID()
function s.initial_effect(c)
	-- Efeito: Adicionar 1 Magia Attack On Titan ao deck quando invocada normalmente ou desvirada
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)

	local e2 = e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
end

-- Filtro para buscar apenas Magias do arquétipo Attack On Titan
function s.thfilter(c)
	return c:IsSetCard(0x100) and c:IsType(TYPE_SPELL) and c:IsAbleToHand() -- Somente Magias Attack On Titan
end

-- Alvo do efeito, checando se há Magias Attack On Titan no deck
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then 
		return Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK, 0, 1, nil) 
	end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

-- Operação do efeito, adicionando a Magia à mão
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
	if #g > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1 - tp, g)
	end
end
