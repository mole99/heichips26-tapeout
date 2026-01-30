MAKEFILE_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

PDK_ROOT ?= $(MAKEFILE_DIR)/../../IHP-Open-PDK
PDK ?= ihp-sg13g2
TOP ?= logo_fabulous

all: logo drc
.PHONY: all

logo:
	python3 script/make_gds.py image/${TOP}.png gds/${TOP}.gds --cellname ${TOP} --merge --pixel-size 0.21 --width 380 --height 380 --foreground "67/0" --boundary "67/23" "126/23" "134/23" "189/4"
.PHONY: logo

drc:
	PDK_ROOT=${PDK_ROOT} PDK=${PDK} klayout -b -zz -r ${PDK_ROOT}/${PDK}/libs.tech/klayout/tech/drc/${PDK}.drc -rd input=gds/${TOP}.gds -rd report=report.lyrdb
.PHONY: drc
