#!/usr/bin/perl

use warnings;
use strict;


#global variables
my $VERSION = '0.1';

#pre-main {{{

my $errored=0;
my $mode='NORMAL';
my $array='';
my @infile = ();
my @implements = ();

my $name='';

getsopt(@ARGV);


#}}}

#variables #{{{

my $template = "data/java/tf-templates/generic-variant-template.java";	#template file
my $extend = "net.ltxprogrammer.changed.entity.ChangedEntity";	#which class to extend

my @presets=();
my @attributes=();
my @abilities=();
my @scares=( );			#what mobs fear the variant

my $transfur_sound="";			#sound a variant makes when transfurring
my $transfur_mode="REPLICATION";	#default tf mode
my $mining_speed="NORMAL";
#my $legs;			#amount of legs
my $entity_shape="ANTHRO";	#entity shape enum. Assumes changed namespace, and is a subject to change
my $use_item_mode="NORMAL";
my $fly="NONE";
my $jumps="0";			#jump charges
my $vision="NORMAL";		#default vision type
my $climb="false";		#stiger climb
my $z_offset="0.0";		#camera z-offset used for taurs
my $freezing_ticks="140";	#powder snow
my $breathing_mode="AIR";
my $powder_snow_walkable="false";
my $transfur_color="0xfdfdfd";
my $egg_back="0xfdfdfd";
my $egg_front="0xf0f0f0";
my @spawn_dimensions="net.minecraft.world.level.Level.OVERWORLD";
my $latex_type="NONE";

#}}}

while ( ! eof STDIN ) {
	push @infile, <STDIN>;
}

foreach ( @infile ) { #load config file
	loop_begin:

	if( ( $_ =~ /^;/ ) || ( $_ =~ /^\h*$/ ) ) { 
		next;
	}

	if ($mode eq 'NORMAL') { #{{{

		if ( $_ =~ /^[A-Z_]+=\[\h*/ ) { #if array opening {{{
$mode ='ARRAY';
			goto loop_begin; #reevaluate as array.
		} # }}}

		if ( $_ =~ /^TEMPLATE=(.+)/ ) { # {{{
			$template = $1
		} #}}}

		if ( $_ =~ /^EXTEND=([a-zA-Z0-9])+\h*/ ) { $extend = $1; }
		if ( $_ =~ /^TRANSFUR_SOUND=(.+)\h*/ ) { $transfur_sound = $1; }
		if ( $_ =~ /^TRANSFUR_MODE=(ABSORBING|REPLICATING|NONE)\h*/ ) { $transfur_mode = $1; }
		if ( $_ =~ /^MINING=(WEAK|NORMAL|STRONG)\h*/ ) { $mining_speed=$1; }
		if ( $_ =~ /^ENTITY_SHAPE=(ANTHRO|FERAL|TAUR|NAGA|MER)\h*/ ) { $entity_shape = $1; }
		if ( $_ =~ /^USE_ITEM_MODE=(NORMAL|MOUTH|NONE)\h*/ ) { $use_item_mode = $1; }
		if ( $_ =~ /^FLY=(NONE|CT|ELYTRA|BOTH)\h*/ ) { $fly = $1; }
		if ( $_ =~ /^JUMPS=(\d+)\h*/ ) { $jumps = $1; }
		if ( $_ =~ /^VISION=(NORMAL|NIGHT_VISION|BLIND|REDUCED|VAVE_VISION)\h*/ ) { $vision = $1; }
		if ( $_ =~ /^CLIMB=(true|false)\h*/ ) { $climb = $1; }
		if ( $_ =~ /^Z_OFFSET=(\d+\.\d+)\h*/ ) { $z_offset = $1; }
		if ( $_ =~ /^TICKS_TO_FREEZE=(\d+)\h*/ ) { $freezing_ticks = $1; }
		if ( $_ =~ /^BREATH=(NORMAL|WATER|ANY|NONE)\h*/ ) { $breathing_mode = $1; }
		if ( $_ =~ /^POWDER_SNOW_WALKABLE=(true|false)\h*/ ){ $powder_snow_walkable = $1; }
		if ( $_ =~ /^TRANSFUR_COLOR=(0x[0-9a-fA-F]{,6})\h*/ ) { $transfur_color = $1; }
		if ( $_ =~ /^ABILITY_COLOR_1ST=(0x[0-9a-fA-F]{,6})\h*/ ) { $egg_back = $1; }
		if ( $_ =~ /^ABILITY_COLOR_2ND=(0x[0-9a-fA-F]{,6})\h*/ ) { $egg_front = $1; }
		if ( $_ =~ /^LATEX_TYPE=(NONE|WHITE_LATEX|DARK_LATEX)/ ) { $latex_type = $1; }

		next;
	} #}}}

	if ( $mode eq 'ARRAY' ) { # {{{

		if ( $_ =~ /^]\h*/ ) { #{{{
			$array = '';
			$mode = 'NORMAL';
			next;
		} # }}}

		if ( $array eq '' ) { # if we drop from normal mode, get option {{{
			$_ =~ /([A-Z]+)=\[\h*/;
			$array = $1;
			next;
		} #}}}

		if ( $array eq 'PRESETS' ) { #{{{
			$_ =~ /(.+)\h*/;
			push( @presets, $1 );
			next;
		} #}}}

		if ( $array eq 'ABILITIES' ) { #{{{
			$_ =~ /(.+)\h*/;
			push( @abilities, $1 );
			next;
		} #}}}

		if ( $array eq 'ATTRIBUTES' ) { #{{{
			$_ =~ /(.+)\h*/;
			push @attributes, $1;
			next;
		} #}}}

		if ( $array eq 'SCARES' ) { #{{{
			$_ =~ /(.+)\h*/;
			push( @scares, $1 );
			next;
		} #}}}
		
		if ( $array eq 'SPAWN_DIMENSIONS' ) { #{{{
			$_ =~ /(.+)\h*/;
			push( @scares, $1 );
			next;
		} #}}}
		
		print STDERR "Unknown array definition: \"$array\", field: \"$_\"";
		$errored = 1;
		next;
	} #}}}

	$errored = 1;
	print STDERR "Internal Compiler Error - bad mode: $mode\n";
}

die 'Compilation aborted due to input errors' if $errored;

#main
if ( $EXTEND eq '' ) { print STDERR "Warning: Extend empty, defaulting to ChangedEntity\n"; $EXTEND = "ChangedEntity"; }

#Ternary operator spam
$transfur_sound = ( $transfur_sound eq '' ) ? '' : ".sound( $transfur_sound.getId() )";
my $transfur_mode_override = '@Override' . "\n\tpublic TransfurMode getTransfurMode() { return TransfurMode.$transfur_mode; }";
$MINING = ( $MINING eq "NORMAL" ) ? "" : '@Override' . "\n\tpublic getLatexType() { return ChangedLatexTypes.$MINING.get(); }";
$ENTITY_SHAPE = ( $ENTITY_SHAPE eq "ANTHRO" ) ? "" : '@Override' . "\n\tpublic getEntityShape() { return EntityShape.$ENTITY_SHAPE; }";
$USE_ITEM_MODE = ( $USE_ITEM_MODE eq "NORMAL" ) ? "" : ".itemUseMode( UseItemMode.$USE_ITEM_MODE )";
$FLY = ( $FLY eq "NONE" ) ? ".glide(false)" : ".glide(true)";
$JUMPS = ($JUMPS == 0 ) ? "" : ".extraJumps($JUMPS)";
$VISION = ( $VISION eq "NORMAL" ) ? "" : ".visionType(VisionType.$VISION)"
$CLIMB = ( $CLIMB eq "false" ) ? "" : ".climb()"
my $climb_override = ( $CLIMB eq "false" ) ? "" : "\tprotected void defineSynchedData() {
		super.defineSynchedData();
		this.entityData.define(DATA_FLAGS_ID, (byte) 0 );
	}

	public void tick() {
		super.tick(); 
		if (!this.level().isClientSide) { this.setClimbing(this.horizontalCollision); }
	}

	public boolean onClimbable() { return this.isClimbing(); }

	public boolean isClimbing() { return ((Byte)this.entityData.get(DATA_FLAGS_ID) & 1) != 0; }

	public void setClimbing(boolean p_33820_) {
		byte b0 = (Byte)this.entityData.get(DATA_FLAGS_ID);
		b0 = ( p_33820_ ) ? (byte) (b0 | 1); : (byte) (b0 & -2);
		this.entityData.set(DATA_FLAGS_ID, b0);
	}

	public void makeStuckInBlock(BlockState p_33796_, Vec3 p_33797_) {
		if (!p_33796_.is(Blocks.COBWEB)) { super.makeStuckInBlock(p_33796_, p_33797_); }
	}\n";
$Z_OFFSET = ( $Z_OFFSET eq "0.0" ) ? "" : ".cameraZOffset($Z_OFFSET)";
$TICKS_TO_FREEZE = ( $TICKS_TO_FREEZE == 140 ) ? "" : "\@Override\n\tpublic int getTicksRequiredToFreeze() { return $TICKS_TO_FREEZE }";
$BREATH = ( $BREATH eq "NORMAL" ) ? "" : ".breatheMode(TransfurVariant.BreatheMode.$BREATH)";
if ($POWDER_SNOW_WALKABLE eq "true" ) { push ( @implements, "PowderSnowWalkable" ); }
$LATEX_TYPE = ( $LATEX_TYPE eq "NONE" ) ? "" : "public LatexType getLatexType() { return ChangedLatexTypes.NONE.get(); }";





#prepare arrays{{{
foreach( @abilities ) {
	$_ = ".addAbility(" . $_ . ")\n";
}

foreach ( @scares ) {
	$_ = ".scares(" . $_ . ".class)\n";
}

foreach ( @attributes ) {
	$_ =~ /^(.+):^(.+)/;
	my $attribute = $1;
	my $value = $2;

	$_ = "attributes.getInstance(" . $attribute . ".get().setBaseValue(" . $value . ");";
}
# }}}


my $TEMPLATE;
open( $TEMPLATE, '<', $template ) or die "Couldn't open file $template, $!";
my @mapped_file = <$TEMPLATE>;
close ($TEMPLATE);

foreach ( @mapped_file ) {
	
}

print @abilities;
print @attributes;
print @scares;
print @spawn_dimensions;

print $transfur_sound;
print $transfur_mode;
print $mining_speed;
print $entity_shape;
print $use_item_mode;
print $fly;
print $jumps;
print $vision;
print $climb;
print $z_offset;
print $freezing_ticks;
print $breathing_mode;
print $aqua_affinity;
print $powder_snow_walkable;
print $transfur_color;
print $egg_back;
print $egg_front;


sub getsopt {
	foreach (@_) {
		if ($_ eq -h ) {
			printHelp();
			exit(0);
		}
	}
}

sub printHelp { 
	print "
KJEntytek's303 Line Oriented Format Transfur Generator
Version $VERSION

USAGE:
./generator.sh [OPTION] [FILE]

If no file is given, the program recompiles all models inside ./variants

OPTIONS:
 -h	- Displays this message
";
} 
