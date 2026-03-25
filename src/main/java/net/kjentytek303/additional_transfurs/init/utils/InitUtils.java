package net.kjentytek303.additional_transfurs.init.utils;

import com.mojang.datafixers.util.Pair;
import net.kjentytek303.additional_transfurs.AdditionalTransfurs;
import net.ltxprogrammer.changed.entity.ChangedEntity;
import net.minecraft.world.entity.*;
import net.minecraft.world.entity.ai.attributes.AttributeSupplier;
import net.minecraft.world.item.Item;
import net.minecraft.world.entity.SpawnPlacements;
import net.minecraft.world.level.levelgen.Heightmap;
import net.minecraftforge.common.ForgeSpawnEggItem;
import net.minecraftforge.registries.RegistryObject;

import javax.annotation.Nullable;
import java.util.function.Supplier;

import static net.kjentytek303.additional_transfurs.init.InitEntities.*;
import static net.kjentytek303.additional_transfurs.init.InitEntities.INIT_ATTRIBS;
import static net.kjentytek303.additional_transfurs.init.InitItems.ITEM_REGISTRY;
import static net.kjentytek303.additional_transfurs.init.InitItems.SPAWN_EGGS;

public class InitUtils
{
	public static <T extends ChangedEntity> RegistryObject<EntityType<T>> getEntityInitRObject(String name, int eggBack, int eggHighlight, EntityType.Builder<T> builder, @Nullable SpawnPlacements.Type spawnType, @Nullable Heightmap.Types spawn_heightmap, Supplier<AttributeSupplier.Builder> attributes) {
		ENTITY_COLORS.put(name, new Pair<>(eggBack, eggHighlight));
		String regName = AdditionalTransfurs.modResource(name).toString();
		
		RegistryObject<EntityType<T>> entityType = ENTITY_REGISTRY.register(name, () -> builder.build(regName));
		if ( spawnType != null ) {
			INIT_SPAWNS.add( new InitSpawnsContainer<T> (entityType, spawnType, spawn_heightmap ) );
		}
		
		INIT_ATTRIBS.add(new Pair<>(entityType::get, attributes));
		RegistryObject<ForgeSpawnEggItem> spawnEggItem = ITEM_REGISTRY.register(name + "_spawn_egg", () -> new ForgeSpawnEggItem(entityType, eggBack, eggHighlight, new Item.Properties()));
		SPAWN_EGGS.put(entityType, spawnEggItem);
		
		return entityType;
	}
}