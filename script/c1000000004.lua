-- Tubarão
function c1000000004.initial_effect(c)
	-- Efeito de busca ao ser Invocado Normalmente ou virado
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1000000004,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c1000000004.thtg)
	e1:SetOperation(c1000000004.thop)
	c:RegisterEffect(e1)
	
	-- Efeito de FLIP (cópia do primeiro)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP)
	c:RegisterEffect(e2)
end

-- Filtro para buscar Répteis, Peixes, Bestas ou Bestas Aladas
function c1000000004.thfilter(c)
	return (c:IsRace(RACE_REPTILE) or c:IsRace(RACE_FISH) or 
		   c:IsRace(RACE_BEAST) or c:IsRace(RACE_WINGEDBEAST)) and 
		   c:IsAbleToHand()
end

-- Função de target
function c1000000004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000000004.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

-- Função de operação
function c1000000004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1000000004.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end