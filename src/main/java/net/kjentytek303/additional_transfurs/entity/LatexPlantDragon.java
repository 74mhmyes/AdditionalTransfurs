package net.kjentytek303.additional_transfurs.entity;

import net.kjentytek303.additional_transfurs.init.utils.InitUtils;
import net.ltxprogrammer.changed.entity.*;
import net.ltxprogrammer.changed.entity.variant.TransfurVariant;
import net.ltxprogrammer.changed.init.ChangedAbilities;
import net.ltxprogrammer.changed.init.ChangedEntities;
import net.ltxprogrammer.changed.init.ChangedSounds;
import net.minecraft.world.entity.EntityType;
import net.minecraft.world.entity.MobCategory;
import net.minecraft.world.entity.SpawnPlacements;
import net.minecraft.world.level.Level;
import net.minecraftforge.registries.RegistryObject;

import static net.kjentytek303.additional_transfurs.init.InitEntities.LATEX_PLANT_DRAGON;

public class LatexPlantDragon extends ChangedEntity {
	
	LatexPlantDragon(EntityType<? extends ChangedEntity> type, Level level) {
		super(type, level);
	}
	
	@Override
	public TransfurMode getTransfurMode() {
		return null;
	}
	
	public static RegistryObject<EntityType<LatexPlantDragon>> getEntityInitRObject() {
		return InitUtils.getEntityInitRObject(
			   "latex_plant_dragon",
			   0xE37107,
			   0x9E4F05,
			   LatexPlantDragon.getEntityInitBuilder(),
			   ChangedEntities::overworldOnly,
			   SpawnPlacements.Type.ON_GROUND,
			   LatexPlantDragon::checkEntitySpawnRules,
			   ChangedEntity::createLatexAttributes
		);
	}
	
	public static EntityType.Builder<LatexPlantDragon> getEntityInitBuilder() {
		return EntityType.Builder
			   .of(LatexPlantDragon::new, MobCategory.MONSTER)
			   .clientTrackingRange(10)
			   .sized(0.7F, 1.93F);
	}
	
	public static TransfurVariant<LatexPlantDragon> getTFInitBuilder()
	{
		return TransfurVariant.Builder
			   .of(LATEX_PLANT_DRAGON)
			   .breatheMode(TransfurVariant.BreatheMode.NORMAL)
			   .glide(false)
			   .extraJumps(0)
			   .canClimb(false)
			   .visionType(VisionType.NIGHT_VISION)
			   .miningStrength(MiningStrength.NORMAL)
			   .itemUseMode(UseItemMode.NORMAL)
			   //.scares(AbstractVillager.class)
			   .transfurMode(TransfurMode.REPLICATION)
			   .addAbility(ChangedAbilities.SWITCH_TRANSFUR_MODE)
			   .addAbility(ChangedAbilities.GRAB_ENTITY_ABILITY)
			   .addAbility(ChangedAbilities.TOGGLE_NIGHT_VISION)
			   .cameraZOffset(0.0f)
			   .sound(ChangedSounds.TRANSFUR_BY_LATEX.getId())
			   .build();
	}
	
	
}
