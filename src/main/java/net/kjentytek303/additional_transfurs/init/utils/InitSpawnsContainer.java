package net.kjentytek303.additional_transfurs.init.utils;

import net.ltxprogrammer.changed.entity.ChangedEntity;
import net.minecraft.world.entity.EntityType;
import net.minecraft.world.entity.SpawnPlacements;
import net.minecraft.world.level.levelgen.Heightmap;
import net.minecraftforge.event.entity.SpawnPlacementRegisterEvent;
import net.minecraftforge.registries.RegistryObject;

public class InitSpawnsContainer<T extends ChangedEntity> {
	public InitSpawnsContainer (RegistryObject<EntityType<T>> robject, SpawnPlacements.Type placement, Heightmap.Types heightmap) {
		this.entity = robject.get();
		this.placement = placement;
		this.heightmap = heightmap;
	}
	
	public void register(SpawnPlacementRegisterEvent event ) {
		event.register( entity, placement, heightmap, T::checkEntitySpawnRules, SpawnPlacementRegisterEvent.Operation.OR );
	}
	
	private final EntityType<T> entity;
	private final SpawnPlacements.Type placement;
	private final Heightmap.Types heightmap;
}
