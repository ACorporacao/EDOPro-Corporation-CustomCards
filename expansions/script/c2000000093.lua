--Vitinho Avassalador
function c2000000093.initial_effect(c)
	-- Destrói o monstro que equipou esta carta
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2000000093,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_EQUIP)
	e1:SetTarget(c2000000093.destg)
	e1:SetOperation(c2000000093.desop)
	c:RegisterEffect(e1)
end

function c2000000093.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ec=eg:GetFirst():GetEquipTarget()
	if ec and ec==e:GetHandler() then
		local tc=eg:GetFirst():GetEquipTarget():GetEquipTarget()
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
	end
end

function c2000000093.desop(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	if ec and ec:GetEquipTarget()==e:GetHandler() then
		Duel.Destroy(ec,REASON_EFFECT)
	end
end