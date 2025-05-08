-- Paradis
local s,id=GetID()
function s.initial_effect(c)
	-- Ativação normal de Spell de Campo
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	-- E1: Monstros Guerreiro "Attack On Titan" ganham 300 ATK
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.atktg)
	e1:SetValue(300)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) -- Adicionado reset apropriado
	c:RegisterEffect(e1)

	-- E2: Monstros Guerreiro "Attack On Titan" ganham 300 DEF
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.deftg)
	e2:SetValue(300)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD) -- Adicionado reset apropriado
	c:RegisterEffect(e2)

	-- E3: Monstros Guerreiro "Attack On Titan" não são afetados por Magias
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.immtg)
	e3:SetValue(s.immval)
	c:RegisterEffect(e3)
	
	-- E4: Efeito adicional para garantir o aumento durante a Invocação-Xyz
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(s.xyzcon)
	e4:SetOperation(s.xyzop)
	c:RegisterEffect(e4)
end

-- Funções de filtro mantidas iguais, mas agora se aplicando a monstros do tipo Guerreiro
function s.atktg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x100) and c:IsRace(RACE_WARRIOR)
end

function s.deftg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x100) and c:IsRace(RACE_WARRIOR)
end

function s.immtg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x100) and c:IsRace(RACE_WARRIOR)
end

function s.immval(e,te)
	return te:IsActiveType(TYPE_SPELL)
end

-- Nova função para detectar Invocação-Xyz
function s.xyzfilter(c,tp)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x100) and c:IsRace(RACE_WARRIOR) and c:IsControler(tp)
end

-- Condição para o efeito adicional
function s.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.xyzfilter,1,nil,tp)
end

-- Operação para forçar atualização de ATK/DEF
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	Duel.GetMatchingGroup(s.atktg,tp,LOCATION_MZONE,0,nil):ForEach(function(c)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(300)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end)
end
