-- サイバー・エンジェル－韋駄天－ (Cyber Angel - Idaten)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	-- Ritual Summon condition
	Ritual.AddProcGreater(c,aux.FilterBoolFunction(Card.IsSetCard,0x2093))
	
	-- Search Ritual Spell when destroyed (after being Ritual Summoned)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(s.thcon)  -- Condições mais precisas
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	
	-- ATK/DEF boost to Ritual Monsters when released
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetTarget(s.adtg)
	e2:SetOperation(s.adop)
	c:RegisterEffect(e2)
end

-- Condição para o efeito de busca (somente se foi Invocado por Ritual)
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_RITUAL) and 
		   (c:IsReason(REASON_EFFECT) and rp==1-tp) or c:IsReason(REASON_BATTLE)
end

-- Filtro para buscar Magias de Ritual
function s.thfilter(c)
	return c:IsRitualSpell() and c:IsAbleToHand()
end

-- Target para o efeito de busca
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

-- Operação de busca
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

-- Filtro para aumentar ATK/DEF
function s.adfilter(c)
	return c:IsFaceup() and c:IsRitualMonster()
end

-- Target para o boost de ATK/DEF (apenas verificação)
function s.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.adfilter,tp,LOCATION_MZONE,0,1,nil) end
end

-- Operação de aumento de ATK/DEF
function s.adop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.adfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end