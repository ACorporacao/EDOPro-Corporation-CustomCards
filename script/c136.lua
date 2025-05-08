local s,id=GetID()
function s.initial_effect(c)
	-- Destrói Monstro Xyz Rank 6 ou menor ao ser declarado alvo de ataque
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCondition(s.descon)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end

-- Condição: o oponente declarar ataque com monstro Xyz Rank 6 ou menor
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttacker()
	return bc and bc:IsType(TYPE_XYZ) and bc:IsControler(1-tp) and bc:GetRank()<=6
end

-- Operação: destruir o atacante
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttacker()
	if bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end
