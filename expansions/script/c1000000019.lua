--Zooxercito
function c1000000019.initial_effect(c)
	-- Ativar: adicione 1 monstro Beast/Winged Beast/Fish/Reptile do Deck à mão
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1000000019,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1000000019.target)
	e1:SetOperation(c1000000019.activate)
	c:RegisterEffect(e1)
end

function c1000000019.filter(c)
	return c:IsType(TYPE_MONSTER) and (
		c:IsRace(RACE_BEAST) or 
		c:IsRace(RACE_WINGEDBEAST) or 
		c:IsRace(RACE_FISH) or 
		c:IsRace(RACE_REPTILE)
	) and c:IsAbleToHand()
end

function c1000000019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000000019.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c1000000019.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1000000019.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
