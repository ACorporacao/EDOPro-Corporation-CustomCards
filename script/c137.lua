-- Defesa Coordenada
local s,id=GetID()
function s.initial_effect(c)
	-- Ativar quando um Guerreiro AOT for alvo de ataque
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)

	-- Monstro equipado não pode ser destruído em batalha
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)

	-- Sem dano de batalha envolvendo o monstro equipado
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetValue(1)
	c:RegisterEffect(e3)

	-- Limite de Equipamento
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(s.eqlimit)
	c:RegisterEffect(e4)
end

-- Condição: Um Guerreiro AOT é alvo de ataque
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	return tc and tc:IsControler(tp) and tc:IsFaceup() and tc:IsRace(RACE_WARRIOR) and tc:IsSetCard(0x100)
end

-- Alvo: O monstro que foi atacado
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetAttackTarget()
	if chk==0 then return tc and tc:IsControler(tp) and tc:IsRelateToBattle() end
	Duel.SetTargetCard(tc)
end

-- Operação: Equipa esta carta ao monstro alvo
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFaceup()==false then return end
	if tc:IsRelateToBattle() and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end

-- Apenas monstros Guerreiro AOT podem ser equipados
function s.eqlimit(e,c)
	return c:IsRace(RACE_WARRIOR) and c:IsSetCard(0x100)
end
