function GetChannel()
  local channel
  if (UnitInRaid("player")) then
    if (UnitIsRaidOfficer("player")) then
      channel="raid_warning"
    else
      channel="raid"
    end
  elseif (GetNumPartyMembers()>0) then
    if (UnitIsPartyLeader("player")) then
      channel="raid_warning"
    else
      channel="party"
    end
  else
    channel=nil
  end
  return channel
end

function TauntWarning_OnLoad()
  this:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  DEFAULT_CHAT_FRAME:AddMessage ("TauntWarning has been loaded")
end

function TauntWarning_OnEvent(self, events, ...)
  local timestamp, type, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags = select(1, ...)
  local playerName = UnitName("player")
  local icon = GetRaidTargetIndex("target")
  local warning, warning2, channel

  if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
    local targetName = UnitName("target")
    local threatSituation=UnitThreatSituation("target")
    local targetOfTargetName=UnitName("targettarget")

    if (type == "SPELL_AURA_APPLIED" and sourceName == playerName) then
      local spellId, spellName, spellSchool = select(9, ...)

      -- debug
      -- DEFAULT_CHAT_FRAME:AddMessage (format ("%s,%s", spellId, spellName))

      if (spellId == 56222 or -- death knight
	spellId == 49560 or -- death knight
	spellId == 355 or   -- war
	spellId == 1161 or  -- war
	spellId == 694 or -- war
	spellId == 62124 or -- pal
	spellId == 31789 or -- pal
	spellId == 6795  or -- druid
	spellId == 5209     -- druid
	) then
	if (not threatSituation) then
	  if (not icon) then
	    warning = format("開怪摟 >>%s<<", destName)
	  else
	    warning = format("開怪摟 >>{rt%d}%s{rt%d}<<", icon, destName, icon)
	  end
	elseif (threatSituation==0 or threatSituation==1) then
	  if (not icon) then
	    warning = format("%s %s → >>%s<<", sourceName, spellName, destName)
	  else
	    warning = format("%s %s → >>{rt%d}%s{rt%d}<<", sourceName, spellNameon, icon, destName, icon)
	  end
	else
	  if (targetOfTargetName ~= playerName) then
	    if (not icon) then
	      warning = format("%s %s → >>%s<< (%s)", sourceName, spellName, destName, targetOftargetName)
	    else
	      warning = format("%s %s → >>{rt%d}%s{rt%d}<< (%s)", sourceName, spellName, icon, destName, icon,  targetOftargetName)
	    end
	  end
	end

	warning2 = "請補職注意我"

	channel = GetChannel()

	if (not channel) then
	  return
	else
	  SendChatMessage(warning, channel)
	  SendChatMessage(warning2, channel)
	end
      end
    elseif(type == "SPELL_CAST_FAILED" and sourceName == playerName) then
      local spellId, spellName, spellSchool = select(9, ...)

      if (spellId == 56222 or -- death knight
	spellId == 49560 or -- death knight
	spellId == 355 or   -- war
	spellId == 1161 or  -- war
	spellId == 694 or   -- war
	spellId == 62124 or -- pal
	spellId == 31789 or -- pal
	spellId == 6795  or -- druid
	spellId == 5209     -- druid
	) then

	local start, duration, enabled = GetSpellCooldown(spellName)

	if ((start + duration)>0) then
	  -- if not out of range
	  warning = format("%s %s → >>%s<< 施法失敗，還在冷卻中，剩餘%d秒", playerName, spellName, targetName, start + duration - GetTime())
	  SendChatMessage(warning, "say")
	end
       end
      elseif(type == "SPELL_MISSED" and sourceName == playerName) then
	local spellId, spellName, spellSchool = select(9, ...)

	--debug
	-- DEFAULT_CHAT_FRAME:AddMessage (format ("miss: %s,%s,%s", spellId, spellName, spellSchool))

	if (spellId == 56222 or -- death knight
	  spellId == 49560 or -- death knight
	  spellId == 355 or   -- war
	  spellId == 1161 or  -- war
	  spellId == 694 or   -- war
	  spellId == 62124 or -- pal
	  spellId == 31789 or -- pal
	  spellId == 6795  or -- druid
	  spellId == 5209     -- druid
	  ) then
	  if (not icon) then
	    warning = format(">>%s<< 嘲諷失敗", destName)
	  else
	    warning = format("對標記為{rt%d}的 >>%s<< 嘲諷失敗", icon, destName)
	  end

	  channel = GetChannel()

	  if (not channel) then
	    return
	  else
	    SendChatMessage(warning, channel)
	    if (targetOfTarget ~= nil and targetOfTarget ~= playerName) then
	      warning2 = format("請補好原目標%s", targetOfTargetName)
	      SendChatMessage(warning2, channel)
	    end
	  end
	end
      end
    end
  end
