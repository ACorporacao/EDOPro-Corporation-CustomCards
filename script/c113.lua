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
end

-- ===== INVOCACAO XYZ CUSTOMIZADA =====

function s.matfilter(c)
	return c:IsFaceup() and c:IsCode(101) and s.checkErenCondition(c)
end

function s.checkErenCondition(c)
	local turn_id = Duel.GetTurnCount()
	local summon_turn = c:GetTurnID()
	local summon_type = c:GetSummonType()
	if (summon_type & SUMMON_TYPE_SPECIAL) == SUMMON_TYPE_SPECIAL then return true end
	if (summon_type & SUMMON_TYPE_NORMAL) == SUMMON_TYPE_NORMAL then
		return summon_turn < turn_id
	end
	return false
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
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.count_con)
	e1:SetOperation(s.count_op)
	e1:SetReset(RESETS_STANDARD_PHASE_END+RESET_OPPO_TURN,3)
	c:RegisterEffect(e1)

	-- Usado para garantir reset da contagem
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(1082946)
	e2:SetLabelObject(e1)
	e2:SetOwnerPlayer(tp)
	e2:SetOperation(s.reset)
	e2:SetReset(RESETS_STANDARD_PHASE_END+RESET_OPPO_TURN,3)
	c:RegisterEffect(e2)
end

function s.count_con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end

function s.count_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()+1
	c:SetTurnCounter(ct)
	if ct==3 then
		-- Invoca Especialmente "Eren Yeager" do overlay
		local og=c:GetOverlayGroup()
		local eren=og:Filter(Card.IsCode,nil,101):GetFirst()
