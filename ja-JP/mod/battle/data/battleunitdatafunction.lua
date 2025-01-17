ys = ys or {}
slot0 = ys
slot1 = slot0.Battle.BattleConst
slot2 = slot0.Battle.BattleConfig
slot3 = slot0.Battle.BattleAttr
slot4 = pg.ship_data_statistics
slot5 = pg.ship_data_template
slot6 = pg.ship_skin_template
slot7 = pg.enemy_data_statistics
slot8 = pg.weapon_property
slot9 = pg.formation_template
slot10 = pg.auto_pilot_template
slot11 = pg.aircraft_template
slot12 = pg.ship_skin_words
slot13 = pg.equip_data_statistics
slot14 = pg.equip_data_template
slot15 = pg.enemy_data_skill
slot16 = pg.ship_data_personality
slot17 = pg.enemy_data_by_type
slot18 = pg.ship_data_by_type
slot19 = pg.ship_level
slot20 = pg.skill_data_template
slot21 = pg.ship_data_trans
slot22 = pg.battle_environment_behaviour_template
slot23 = pg.equip_skin_template
slot24 = pg.activity_template
slot25 = pg.activity_event_worldboss
slot26 = pg.world_joint_boss_template
slot27 = pg.world_boss_level
slot28 = pg.guild_boss_event
slot29 = pg.ship_strengthen_meta
slot30 = pg.map_data
slot0.Battle.BattleDataFunction = slot0.Battle.BattleDataFunction or {}
slot31 = slot0.Battle.BattleDataFunction

function slot31.CreateBattleUnitData(slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8, slot9, slot10, slot11)
	slot12, slot13 = nil

	if slot1 == uv0.UnitType.PLAYER_UNIT then
		slot12 = uv1.Battle.BattlePlayerUnit.New(slot0, slot2)

		slot12:SetSkinId(slot4)
		slot12:SetWeaponInfo(slot9, slot10)

		slot13 = Ship.WEAPON_COUNT
	elseif slot1 == uv0.UnitType.SUB_UNIT then
		slot12 = uv1.Battle.BattleSubUnit.New(slot0, slot2)

		slot12:SetSkinId(slot4)
		slot12:SetWeaponInfo(slot9, slot10)

		slot13 = Ship.WEAPON_COUNT
	elseif slot1 == uv0.UnitType.ENEMY_UNIT then
		uv1.Battle.BattleEnemyUnit.New(slot0, slot2):SetOverrideLevel(slot11)
	elseif slot1 == uv0.UnitType.BOSS_UNIT then
		uv1.Battle.BattleBossUnit.New(slot0, slot2):SetOverrideLevel(slot11)
	elseif slot1 == uv0.UnitType.NPC_UNIT then
		slot12 = uv1.Battle.BattleNPCUnit.New(slot0, slot2)
	elseif slot1 == uv0.UnitType.CONST_UNIT then
		slot12 = uv1.Battle.BattleConstPlayerUnit.New(slot0, slot2)

		slot12:SetSkinId(slot4)
		slot12:SetWeaponInfo(slot9, slot10)

		slot13 = Ship.WEAPON_COUNT
	end

	slot12:SetTemplate(slot3, slot6, slot7)

	slot14 = {}

	if slot1 == uv0.UnitType.ENEMY_UNIT or slot1 == uv0.UnitType.BOSS_UNIT then
		for slot18, slot19 in ipairs(slot5) do
			slot14[#slot14 + 1] = {
				equipment = {
					weapon_id = {
						slot19.id
					}
				}
			}
		end
	else
		for slot18, slot19 in ipairs(slot5) do
			if not slot19.id then
				slot14[#slot14 + 1] = {
					equipment = false,
					torpedoAmmo = 0,
					skin = slot19.skin
				}
			elseif not slot13 or slot18 <= slot13 or #uv2.GetWeaponDataFromID(slot19.id).weapon_id then
				slot14[#slot14 + 1] = {
					equipment = uv2.GetWeaponDataFromID(slot19.id),
					skin = slot19.skin,
					torpedoAmmo = slot19.equipmentInfo and slot19.equipmentInfo.config.torpedo_ammo or 0
				}
			else
				slot14[#slot14 + 1] = {
					equipment = false,
					skin = slot19.skin,
					torpedoAmmo = slot20
				}
			end
		end
	end

	slot12:SetProficiencyList(slot8)
	slot12:SetEquipment(slot14)

	return slot12
end

function slot31.InitUnitSkill(slot0, slot1, slot2)
	for slot7, slot8 in pairs(slot0.skills or {}) do
		slot1:AddBuff(uv0.Battle.BattleBuffUnit.New(slot8.id, slot8.level, slot1))
	end
end

function slot31.GetEquipSkill(slot0, slot1)
	slot2 = Ship.WEAPON_COUNT
	slot3 = {}

	for slot7, slot8 in ipairs(slot0) do
		if slot8.id then
			slot10 = nil

			if uv0.GetWeaponDataFromID(slot9) then
				for slot15, slot16 in ipairs(slot11.skill_id) do
					if slot1 then
						slot16 = uv0.SkillTranform(slot1, slot16) or slot16
					end

					table.insert(slot3, slot16)
				end

				for slot15, slot16 in ipairs(slot11.hidden_skill_id) do
					if slot1 then
						slot16 = uv0.SkillTranform(slot1, slot16) or slot16
					end

					table.insert(slot3, slot16)
				end
			end
		end
	end

	return slot3
end

function slot31.AttachWeather(slot0, slot1)
	if table.contains(slot1, uv0.WEATHER.NIGHT) then
		if slot0:GetFleetVO() then
			if table.contains(TeamType.VanguardShipType, slot0:GetTemplate().type) then
				slot0:GetFleetVO():GetFleetBias():AppendCrew(slot0)
			elseif table.contains(TeamType.MainShipType, slot3) then
				slot2:AttachCloak(slot0)
			elseif table.contains(TeamType.SubShipType, slot3) then
				slot4 = uv1.Battle.BattleUnitAimBiasComponent.New()

				slot4:ConfigRangeFormula(uv1.Battle.BattleFormulas.CalculateMaxAimBiasRangeSub, uv1.Battle.BattleFormulas.CalculateBiasDecay)
				slot4:AppendCrew(slot0)
				slot4:Active(slot4.STATE_ACTIVITING)
			end
		elseif slot0:GetUnitType() == uv0.UnitType.ENEMY_UNIT or slot0:GetUnitType() == uv0.UnitType.BOSS_UNIT then
			slot2 = uv1.Battle.BattleUnitAimBiasComponent.New()

			slot2:ConfigRangeFormula(uv1.Battle.BattleFormulas.CalculateMaxAimBiasRangeMonster, uv1.Battle.BattleFormulas.CalculateBiasDecayMonster)
			slot2:AppendCrew(slot0)
			slot2:Active(slot2.STATE_SUMMON_SICKNESS)
		end
	end
end

function slot31.InitEquipSkill(slot0, slot1, slot2)
	for slot7, slot8 in ipairs(uv0.GetEquipSkill(slot0, slot2)) do
		slot1:AddBuff(uv1.Battle.BattleBuffUnit.New(slot8, 1, slot1))
	end
end

function slot31.InitCommanderSkill(slot0, slot1, slot2)
	slot3 = uv0.Battle.BattleState.GetInstance():GetBattleType()

	for slot7, slot8 in pairs(slot0 or {}) do
		slot10 = false

		if uv0.Battle.BattleDataFunction.GetBuffTemplate(slot8.id, slot8.level).limit then
			for slot14, slot15 in ipairs(slot9) do
				if slot3 == slot15 then
					slot10 = true

					break
				end
			end
		end

		if not slot10 then
			slot11 = uv0.Battle.BattleBuffUnit.New(slot8.id, slot8.level, slot1)

			slot11:SetCommander(slot8.commander)
			slot1:AddBuff(slot11)
		end
	end
end

function slot31.CreateWeaponUnit(slot0, slot1, slot2, slot3, slot4)
	slot3 = slot3 or -1
	slot5 = slot1:GetUnitType()
	slot6 = nil

	if (slot4 or uv0.GetWeaponPropertyDataFromID(slot0).type) == uv1.EquipmentType.MAIN_CANNON then
		slot6 = uv2.Battle.BattleWeaponUnit.New()
	elseif slot8 == uv1.EquipmentType.SUB_CANNON then
		slot6 = uv2.Battle.BattleWeaponUnit.New()
	elseif slot8 == uv1.EquipmentType.TORPEDO then
		slot6 = uv2.Battle.BattleTorpedoUnit.New()
	elseif slot8 == uv1.EquipmentType.MANUAL_TORPEDO then
		slot6 = uv2.Battle.BattleManualTorpedoUnit.New()
	elseif slot8 == uv1.EquipmentType.ANTI_AIR then
		slot6 = uv2.Battle.BattleAntiAirUnit.New()
	elseif slot8 == uv1.EquipmentType.FLEET_ANTI_AIR then
		slot6 = uv2.Battle.BattleWeaponUnit.New()
	elseif slot8 == uv1.EquipmentType.SCOUT or slot8 == uv1.EquipmentType.PASSIVE_SCOUT then
		slot6 = uv2.Battle.BattleHiveUnit.New()
	elseif slot8 == uv1.EquipmentType.SPECIAL then
		slot6 = uv2.Battle.BattleSpecialWeapon.New()
	elseif slot8 == uv1.EquipmentType.ANTI_SEA then
		slot6 = uv2.Battle.BattleDirectHitWeaponUnit.New()
	elseif slot8 == uv1.EquipmentType.HAMMER_HEAD then
		slot6 = uv2.Battle.BattleHammerHeadWeaponUnit.New()
	elseif slot8 == uv1.EquipmentType.BOMBER_PRE_CAST_ALERT then
		slot6 = uv2.Battle.BattleBombWeaponUnit.New()
	elseif slot8 == uv1.EquipmentType.POINT_HIT_AND_LOCK then
		slot6 = uv2.Battle.BattlePointHitWeaponUnit.New()
	elseif slot8 == uv1.EquipmentType.BEAM then
		slot6 = uv2.Battle.BattleLaserUnit.New()
	elseif slot8 == uv1.EquipmentType.DEPTH_CHARGE then
		slot6 = uv2.Battle.BattleDepthChargeUnit.New()
	elseif slot8 == uv1.EquipmentType.REPEATER_ANTI_AIR then
		slot6 = uv2.Battle.BattleRepeaterAntiAirUnit.New()
	elseif slot8 == uv1.EquipmentType.DISPOSABLE_TORPEDO then
		slot6 = uv2.Battle.BattleDisposableTorpedoUnit.New()
	elseif slot8 == uv1.EquipmentType.MANUAL_AAMISSILE then
		slot6 = uv2.Battle.BattleManualAAMissileUnit.New()
	elseif slot8 == uv1.EquipmentType.SPACE_LASER then
		slot6 = uv2.Battle.BattleSpaceLaserWeaponUnit.New()
	elseif slot8 == uv1.EquipmentType.MISSILE then
		slot6 = uv2.Battle.BattleMissileWeaponUnit.New()
	end

	slot6:SetPotentialFactor(slot2)
	slot6:SetEquipmentIndex(slot3)
	slot6:SetTemplateData(slot7)
	slot6:SetHostData(slot1)

	if slot5 == uv1.UnitType.PLAYER_UNIT then
		if slot7.auto_aftercast > 0 then
			slot6:OverrideGCD(slot7.auto_aftercast)
		end
	elseif slot5 == uv1.UnitType.ENEMY_UNIT or uv1.UnitType.BOSS_UNIT then
		slot6:HostOnEnemy()
	end

	if slot7.type == uv1.EquipmentType.SCOUT or slot7.type == uv1.EquipmentType.PASSIVE_SCOUT then
		slot6:EnterCoolDown()
	end

	return slot6
end

function slot31.CreateAircraftUnit(slot0, slot1, slot2, slot3)
	slot4 = nil
	slot4 = (type(uv0.GetAircraftTmpDataFromID(slot1).funnel_behavior) ~= "table" or (not slot5.funnel_behavior.hover_range or uv1.Battle.BattelUAVUnit.New(slot0)) and (not slot5.funnel_behavior.AI or uv1.Battle.BattlePatternFunnelUnit.New(slot0)) and uv1.Battle.BattleFunnelUnit.New(slot0)) and uv1.Battle.BattleAircraftUnit.New(slot0)

	slot4:SetMotherUnit(slot2)
	slot4:SetWeanponPotential(slot3)
	slot4:SetTemplate(slot5)

	return slot4
end

function slot31.CreateAllInStrike(slot0)
	slot3 = 0

	for slot8, slot9 in ipairs(uv0.GetPlayerShipModelFromID(slot0:GetTemplateID()).airassist_time) do
		uv1.Battle.BattleAllInStrike.New(slot9):SetHost(slot0)
	end

	return {
		[slot8] = slot10
	}
end

function slot31.ExpandAllinStrike(slot0)
	if #uv0.GetPlayerShipModelFromID(slot0:GetTemplateID()).airassist_time > 0 then
		slot5 = uv1.Battle.BattleAllInStrike.New(slot3[#slot3])

		slot5:SetHost(slot0)
		slot0:GetFleetVO():GetAirAssistVO():AppendWeapon(slot5)
		slot5:OverHeat()
		slot0:GetAirAssistQueue():AppendWeapon(slot5)

		slot6 = slot0:GetAirAssistList()
		slot6[#slot6 + 1] = slot5
	end
end

function slot31.CreateAirFighterUnit(slot0, slot1)
	slot2 = nil
	slot2 = uv1.Battle.BattleAirFighterUnit.New(slot0)

	slot2:SetWeaponTemplateID(slot1.weaponID)
	slot2:SetTemplate(uv0.GetAircraftTmpDataFromID(slot1.templateID))

	return slot2
end

function slot31.GetPlayerShipTmpDataFromID(slot0)
	return Clone(uv0[slot0])
end

function slot31.GetPlayerShipModelFromID(slot0)
	return uv0[slot0]
end

function slot31.GetPlayerShipSkinDataFromID(slot0)
	return uv0[slot0]
end

function slot31.GetShipTypeTmp(slot0)
	return uv0[slot0]
end

function slot31.GetMonsterTmpDataFromID(slot0)
	return uv0[slot0]
end

function slot31.GetAircraftTmpDataFromID(slot0)
	return uv0[slot0]
end

function slot31.GetWeaponDataFromID(slot0)
	if slot0 ~= Equipment.EQUIPMENT_STATE_EMPTY and slot0 ~= Equipment.EQUIPMENT_STATE_LOCK then
		-- Nothing
	end

	return uv0[slot0]
end

function slot31.GetEquipDataTemplate(slot0)
	return uv0[slot0]
end

function slot31.GetWeaponPropertyDataFromID(slot0)
	return uv0[slot0]
end

function slot31.GetFormationTmpDataFromID(slot0)
	return uv0[slot0]
end

function slot31.GetAITmpDataFromID(slot0)
	return uv0[slot0]
end

function slot31.GetShipPersonality(slot0)
	return uv0[slot0]
end

function slot31.GetEnemyTypeDataByType(slot0)
	return uv0[slot0]
end

function slot31.GetArenaBuffByShipType(slot0)
	return uv0.GetShipTypeTmp(slot0).arena_buff
end

function slot31.GetPlayerUnitDurabilityExtraAddition(slot0, slot1)
	if slot0 == SYSTEM_DUEL then
		return uv0[slot1].arena_durability_ratio, uv0[slot1].arena_durability_add
	else
		return 1, 0
	end
end

function slot31.GetSkillDataTemplate(slot0)
	return uv0[slot0]
end

function slot31.GetShipTransformDataTemplate(slot0)
	return uv1[uv0.GetPlayerShipModelFromID(slot0).group_type]
end

function slot31.GetShipMetaFromDataTemplate(slot0)
	return uv1[uv0.GetPlayerShipModelFromID(slot0).group_type]
end

function slot31.GetEquipSkinDataFromID(slot0)
	return uv0[slot0]
end

function slot31.GetEquipSkin(slot0)
	slot1 = uv0[slot0]

	return slot1.bullet_name, slot1.derivate_bullet, slot1.derivate_torpedo, slot1.derivate_boom
end

function slot31.GetSpecificGuildBossEnemyList(slot0, slot1)
	slot4 = {}

	if uv0[slot0].expedition_id[1] == slot1 then
		slot4 = slot3[2]
	end

	return slot4
end

function slot31.GetSpecificEnemyList(slot0, slot1)
	slot5 = nil

	for slot9, slot10 in ipairs(uv1[uv0[slot0].config_id].ex_expedition_enemy) do
		if slot10[1] == slot1 then
			slot5 = slot10[2]

			break
		end
	end

	return slot5
end

function slot31.GetSpecificWorldJointEnemyList(slot0, slot1, slot2)
	return {
		pg.world_boss_level[uv0[slot1].boss_level_id + slot2 - 1].enemy_id
	}
end

function slot31.IncreaseAttributes(slot0, slot1, slot2)
	for slot6, slot7 in ipairs(slot2) do
		if slot7[slot1] ~= nil and type(slot7[slot1]) == "number" then
			slot0 = slot0 + slot7[slot1]
		end
	end
end

function slot31.CreateAirFighterWeaponUnit(slot0, slot1, slot2, slot3)
	slot4 = nil

	if uv0.GetWeaponPropertyDataFromID(slot0).type == uv1.EquipmentType.MAIN_CANNON then
		slot4 = uv2.Battle.BattleWeaponUnit.New()
	elseif slot5.type == uv1.EquipmentType.SUB_CANNON then
		slot4 = uv2.Battle.BattleWeaponUnit.New()
	elseif slot5.type == uv1.EquipmentType.TORPEDO then
		slot4 = uv2.Battle.BattleTorpedoUnit.New()
	elseif slot5.type == uv1.EquipmentType.ANTI_AIR then
		slot4 = uv2.Battle.BattleAntiAirUnit.New()
	elseif slot5.type == uv1.EquipmentType.ANTI_SEA then
		slot4 = uv2.Battle.BattleDirectHitWeaponUnit.New()
	elseif slot5.type == uv1.EquipmentType.HAMMER_HEAD then
		slot4 = uv2.Battle.BattleHammerHeadWeaponUnit.New()
	elseif slot5.type == uv1.EquipmentType.BOMBER_PRE_CAST_ALERT then
		slot4 = uv2.Battle.BattleBombWeaponUnit.New()
	elseif slot5.type == uv1.EquipmentType.DEPTH_CHARGE then
		slot4 = uv2.Battle.BattleDepthChargeUnit.New()
	end

	slot4:SetPotentialFactor(slot3)

	slot6 = Clone(slot5)
	slot6.spawn_bound = "weapon"

	slot4:SetTemplateData(slot6)
	slot4:SetHostData(slot1, slot2)

	return slot4
end

function slot31.GetWords(slot0, slot1, slot2)
	slot3, slot4, slot5 = ShipWordHelper.GetWordAndCV(slot0, slot1, 1, true, slot2)

	return slot5
end

function slot31.SkillTranform(slot0, slot1)
	if uv0.GetSkillDataTemplate(slot1).system_transform[slot0] == nil then
		return slot1
	else
		return slot3[slot0]
	end
end

function slot31.GenerateHiddenBuff(slot0)
	for slot6, slot7 in ipairs(uv0.GetPlayerShipModelFromID(slot0).hide_buff_list) do
		-- Nothing
	end

	return {
		[slot7] = {
			level = 1,
			id = slot7
		}
	}
end

function slot31.GetDivingFilter(slot0)
	return uv0[slot0].diving_filter
end

function slot31.GeneratePlayerSubmarinPhase(slot0, slot1, slot2, slot3, slot4)
	return {
		{
			index = 0,
			switchType = 3,
			switchTo = 1,
			switchParam = slot0 - slot2
		},
		{
			switchType = 5,
			dive = "STATE_RAID",
			switchTo = 2,
			index = 1,
			switchParam = 0
		},
		{
			switchType = 1,
			dive = "STATE_FLOAT",
			switchTo = 3,
			index = 2,
			switchParam = slot4
		},
		{
			switchType = 4,
			dive = "STATE_RETREAT",
			switchTo = 4,
			index = 3,
			switchParam = slot1
		},
		{
			index = 4,
			retreat = true
		}
	}
end

function slot31.GetEnvironmentBehaviour(slot0)
	return uv0[slot0]
end

function slot31.AttachUltimateBonus(slot0)
	if not Ship.IsMaxStarByTmpID(slot0:GetTemplateID()) then
		return
	end

	for slot7, slot8 in ipairs(uv0.GetPlayerShipModelFromID(slot1).specific_type) do
		if slot8 == ShipType.SpecificTypeTable.gunner then
			uv1.SetCurrent(slot0, "barrageCounterMod", uv2.UltimateBonus.GunnerCountMod)
		elseif slot8 == ShipType.SpecificTypeTable.torpedo then
			slot0:AddBuff(uv3.Battle.BattleBuffUnit.New(uv2.UltimateBonus.TorpedoBarrageBuff))
		elseif slot8 == ShipType.SpecificTypeTable.auxiliary then
			uv0.AuxBoost(slot0)
		end
	end
end

function slot31.AuxBoost(slot0)
	for slot5, slot6 in ipairs(slot0:GetEquipment()) do
		if slot6 and slot6.equipment and table.contains(EquipType.DeviceEquipTypes, slot6.equipment.type) then
			slot7 = slot6.equipment

			for slot11 = 1, 3 do
				if slot7["attribute_" .. slot11] then
					slot14 = AttributeType.ConvertBattleAttrName(slot7[slot12])

					uv0.SetCurrent(slot0, slot14, uv0.GetBase(slot0, slot14) + slot7["value_" .. slot11] * uv1.UltimateBonus.AuxBoostValue)
					uv0.SetBaseAttr(slot0)
				end
			end
		end
	end
end
