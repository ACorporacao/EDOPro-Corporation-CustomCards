--Mega Man
function c1000000020.initial_effect(c)
	-- Copia os efeitos do monstro destruído por batalha
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1000000020,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(c1000000020.condition)
	e1:SetTarget(c1000000020.target)
	e1:SetOperation(c1000000020.operation)
	c:RegisterEffect(e1)
end

function c1000000020.condition(e,tp,eg,ep,ev,re,r,rp)
	-- Verifica se destruiu por batalha e o alvo foi enviado ao cemitério
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsType(TYPE_MONSTER) and bc:IsLocation(LOCATION_GRAVE)
end

function c1000000020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	--Duel.SetOperationInfo(0,CATEGORY_COPY,e:GetHandler(),1,0,0)
end

function c1000000020.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToEffect(e) and bc and bc:IsLocation(LOCATION_GRAVE) then
		local code=bc:GetOriginalCodeRule()
		if code then
			local reset=RESET_EVENT+RESETS_STANDARD
			c:CopyEffect(code, reset)
		end
	end
end
