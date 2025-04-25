--Kirby
function c1000000021.initial_effect(c)
	-- Equipar 1 monstro do oponente
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1000000021,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c1000000021.eqtg)
	e1:SetOperation(c1000000021.eqop)
	c:RegisterEffect(e1)
end

function c1000000021.eqfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsControler(1)
end

function c1000000021.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c1000000021.eqfilter(chkc) end
	if chk==0 then
		-- Verifica se já há um monstro equipado por esse efeito
		local g=c:GetEquipGroup()
		for ec in aux.Next(g) do
			if ec:GetOwner()==c then return false end
		end
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingTarget(c1000000021.eqfilter,tp,0,LOCATION_MZONE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c1000000021.eqfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end


function c1000000021.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc or not c:IsRelateToEffect(e) or c:IsFacedown() or not tc:IsRelateToEffect(e) then return end

	-- Verificar se já tem um monstro equipado por esse efeito
	local g=c:GetEquipGroup()
	for ec in aux.Next(g) do
		if ec:GetOwner()==c then return end
	end

	if Duel.Equip(tp,tc,c,false) then
		-- Permitir que o monstro seja tratado como Equip Spell
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_EQUIP_LIMIT)
		e0:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		e0:SetValue(function(e,c) return e:GetOwner()==c end)
		tc:RegisterEffect(e0)

		-- Aumentar ATK (valor igual ao ATK original do monstro equipado)
		local atk = tc:GetAttack()
		if atk < 0 then atk = 0 end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		
		-- Aumentar DEF (valor igual ao DEF original do monstro equipado)
		local def = tc:GetDefense()
		if def < 0 then def = 0 end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(def)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end

