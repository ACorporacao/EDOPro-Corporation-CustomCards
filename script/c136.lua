local s,id=GetID()
function s.initial_effect(c)
	-- Quando Levi ataca um Xyz Rank 6 ou menor, destrói imediatamente
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.descon)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end

-- Condição: Levi ataca um monstro Xyz Rank 6 ou menor
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsType(TYPE_XYZ) and bc:GetRank()<=6
end

-- Destrói o alvo e cancela a batalha
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc and bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
		Duel.ChangeAttackTarget(nil) -- remove o alvo de ataque
	end
end
