MAKEFILE_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

RUN_TAG = $(shell ls librelane/runs/ | tail -n 1)
TOP = heichips25_top

PDK_ROOT ?= $(MAKEFILE_DIR)/IHP-Open-PDK
PDK ?= ihp-sg13g2
PDK_COMMIT ?= c4b8b4e5e7a05f375cca3815d51b3a37721fbf5c

.DEFAULT_GOAL := help

$(PDK_ROOT)/$(PDK):
	ciel enable $(PDK_COMMIT) --pdk-root $(PDK_ROOT) --pdk-family $(PDK)

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
.PHONY: help

clone-pdk: $(PDK_ROOT)/$(PDK) ## Clone the IHP-Open-PDK repository
.PHONY: clone-pdk

all: librelane ## Build the project (runs LibreLane)
.PHONY: all

librelane: $(PDK_ROOT)/$(PDK) ## Run LibreLane flow (synthesis, PnR, verification)
	librelane librelane/config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk
.PHONY: librelane

librelane-nodrc: $(PDK_ROOT)/$(PDK) ## Run LibreLane flow without DRC checks
	librelane librelane/config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk --skip KLayout.DRC --skip Magic.DRC --skip KLayout.Density --skip KLayout.Filler 
.PHONY: librelane-nodrc

librelane-openroad: $(PDK_ROOT)/$(PDK) ## Open the last run in OpenROAD
	librelane librelane/config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk --last-run --flow OpenInOpenROAD
.PHONY: librelane-openroad

librelane-klayout: $(PDK_ROOT)/$(PDK) ## Open the last run in KLayout
	librelane librelane/config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk --last-run --flow OpenInKLayout
.PHONY: librelane-klayout

sim: ## Run RTL simulation with cocotb
	cd tb/heichips25_top; PDK_ROOT=${PDK_ROOT} PDK=${PDK} python3 heichips25_top_tb.py test_fpga_all_zeros
	! grep failure tb/heichips25_top/sim_build/results.xml
	cd tb/heichips25_top; PDK_ROOT=${PDK_ROOT} PDK=${PDK} python3 heichips25_top_tb.py test_fpga_all_ones
	! grep failure tb/heichips25_top/sim_build/results.xml
	cd tb/heichips25_top; PDK_ROOT=${PDK_ROOT} PDK=${PDK} python3 heichips25_top_tb.py test_fpga_counter_top
	! grep failure tb/heichips25_top/sim_build/results.xml
.PHONY: sim

sim-gl: $(PDK_ROOT)/$(PDK) ## Run gate-level simulation with cocotb
	cd tb/heichips25_top; GL=1 PDK_ROOT=${PDK_ROOT} PDK=${PDK} python3 heichips25_top_tb.py test_fpga_all_zeros
	! grep failure tb/heichips25_top/sim_build/results.xml
	cd tb/heichips25_top; GL=1 PDK_ROOT=${PDK_ROOT} PDK=${PDK} python3 heichips25_top_tb.py test_fpga_all_ones
	! grep failure tb/heichips25_top/sim_build/results.xml
	cd tb/heichips25_top; GL=1 PDK_ROOT=${PDK_ROOT} PDK=${PDK} python3 heichips25_top_tb.py test_fpga_counter_top
	! grep failure tb/heichips25_top/sim_build/results.xml
.PHONY: sim-gl

sim-view: ## View simulation waveforms in GTKWave
	gtkwave tb/heichips25_top/sim_build/heichips25_top_tb.fst
.PHONY: sim-view

copy-final: ## Copy final output files from the last run
	rm -rf final/
	cp -r librelane/runs/${RUN_TAG}/final/ final/
.PHONY: copy-final

create-image:
	PDK_ROOT=$(PDK_ROOT) PDK=$(PDK) klayout -z -r scripts/klayout_image.py -rd input_gds=final/gds/${TOP}.gds.gz -rd output_image=img/${TOP}.png
	convert img/${TOP}.png -resize 25% img/${TOP}_small.png
.PHONY: create-image
