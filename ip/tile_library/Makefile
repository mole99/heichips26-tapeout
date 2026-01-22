PDK ?= ihp-sg13g2
PDK_ROOT ?= ~/.ciel

TILES = S_term_single N_term_single LUT4AB N_IO4 S_IO4 IHP_SRAM E_TT_IF E_TT_IF2 W_TT_IF W_TT_IF2 NE_term SE_term NW_term SW_term
TILE_DIR = tiles

TILE_PATHS := $(addprefix $(TILE_DIR)/,$(TILES))
TILE_PATHS_OPENROAD := $(addsuffix -openroad,$(TILE_PATHS))
TILE_PATHS_KLAYOUT := $(addsuffix -klayout,$(TILE_PATHS))

$(info $(TILE_PATHS))

# A rule for all tiles
$(TILE_PATHS):
	librelane --pdk ${PDK} common.yaml $@/config.yaml
.PHONY: $(TILE_PATHS)

$(TILE_PATHS_OPENROAD):
	librelane --pdk ${PDK} common.yaml $(subst -openroad,,$@)/config.yaml --last-run --flow OpenInOpenROAD
.PHONY: $(TILE_PATHS_OPENROAD)

$(TILE_PATHS_KLAYOUT):
	librelane --pdk ${PDK} common.yaml $(subst -klayout,,$@)/config.yaml --last-run --flow OpenInKLayout
.PHONY: $(TILE_PATHS_KLAYOUT)

boundary-tiles: $(TILE_DIR)/N_IO4 $(TILE_DIR)/S_IO4 $(TILE_DIR)/IHP_SRAM $(TILE_DIR)/E_TT_IF $(TILE_DIR)/E_TT_IF2 $(TILE_DIR)/W_TT_IF $(TILE_DIR)/W_TT_IF2
.PHONY: termination-tiles

termination-tiles: $(TILE_DIR)/S_term_single $(TILE_DIR)/N_term_single $(TILE_DIR)/NE_term $(TILE_DIR)/SE_term $(TILE_DIR)/NW_term $(TILE_DIR)/SW_term
.PHONY: termination-tiles

all-tiles: $(TILE_PATHS)
.PHONY: all-tiles
