-- Titan Assaltante Eren Yeager
local s,id = GetID()
function s.initial_effect(c)
	-- Invocação personalizada por Xyz
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.xyzcon)
	e1:SetOperation(s.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)

	-- Iniciar contagem após Invocação por Xyz
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end)
	e2:SetOperation(s.start_count)
	c:RegisterEffect(e2)

	-- EFEITO 03: Se não tiver Eren como material, destrua no fim do turno
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.no_eren_cond)
	e3:SetOperation(s.destroy_self)
	c:RegisterEffect(e3)

	-- EFEITO 04: Se esta carta atacar um monstro em posição de defesa, destrua-o imediatamente
local e4=Effect.CreateEffect(c)
e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
e4:SetCode(EVENT_BATTLE_CONFIRM)
e4:SetCondition(s.descond)
e4:SetOperation(s.desop)
c:RegisterEffect(e4)
end


-- ===== INVOCACAO XYZ CUSTOMIZADA =====

function s.matfilter(c)
	return c:IsFaceup() and c:IsCode(103) and s.checkErenCondition(c)
end

-- Verifica se o monstro NÃO foi invocado neste turno
function s.checkErenCondition(c)
	local current_turn = Duel.GetTurnCount()
	local summon_turn = c:GetTurnID()
	return summon_turn < current_turn
end

function s.xyzcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.matfilter,tp,LOCATION_MZONE,0,1,nil)
end

function s.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,s.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end


-- ===== CONTAGEM DE FASE FINAL DO OPONENTE =====

function s.start_count(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetTurnCounter(0)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_TURN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.count_con)
	e1:SetOperation(s.count_op)
	e1:SetLabelObject(c)
	c:RegisterEffect(e1)
end


function s.count_con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end

function s.count_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if not c or not c:IsFaceup() or not c:IsOnField() then return end

	-- Evita contar mais de uma vez por turno
	if c:GetFlagEffect(id)==0 then
		local ct=c:GetTurnCounter()+1
		c:SetTurnCounter(ct)
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)

		if ct==3 then
			-- Invoca Especialmente "Eren Yeager" do overlay
			local og=c:GetOverlayGroup()
			local eren=og:Filter(Card.IsCode,nil,109):GetFirst()
			if eren and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 then
				Duel.Overlay(c,og:Filter(aux.NOT(Card.IsCode),nil,109)) -- remove os outros materiais
				Duel.SpecialSummon(eren,0,tp,tp,false,false,POS_FACEUP)

				-- Destrói o monstro que invocou o C104
				Duel.BreakEffect()
				Duel.Destroy(c,REASON_EFFECT)
			else
				Duel.Destroy(c,REASON_EFFECT)
			end
		end
	end
end





function s.reset(e,tp,eg,ep,ev,re,r,rp)
	s.count_op(e:GetLabelObject(),tp,eg,ep,ev,re,r,rp)
end

--EFEITO 3
function s.check_material(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	local og=c:GetOverlayGroup()
	if not og:IsExists(Card.IsCode,1,nil,109) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end

function s.no_eren_cond(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsLocation(LOCATION_MZONE) then return false end
	local og=c:GetOverlayGroup()
	return not og:IsExists(Card.IsCode,1,nil,109)
end

function s.destroy_self(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Destroy(c,REASON_EFFECT)
end


function s.descond(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsDefensePos() and bc:IsControler(1-tp)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc and bc:IsDefensePos() and bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end
