PROJECT = JLRPOCX000.Fingerprint
WIDGET = $(PROJECT).wgt
INSTALL_FILES = images js icon.png index.html
WRT_FILES = DNA_common css data icon.png index.html setup config.xml images js manifest.json templates
VERSION := 0.0.1
PACKAGE = $(PROJECT)-$(VERSION)
TIZEN_IP ?= vtc
COMMON = ../common-app

all: dev

dev: clean dev-common
	zip -r $(WIDGET) $(WRT_FILES)

dev-common: $(COMMON)
	cp -rf $(COMMON) DNA_common

clean:
	rm -rf js/services common css/car css/user $(WIDGET)

run: install
ifndef OBS
	ssh app@$(TIZEN_IP) "app_launcher -d -s $(PROJECT)"
endif

install: deploy
ifndef OBS
	-ssh app@$(TIZEN_IP) "pkgcmd -u -n $(PROJECT) -q"
	ssh app@$(TIZEN_IP) "pkgcmd -i -t wgt -p $(WIDGET) -q"
endif

deploy: dev
ifndef OBS
	scp $(WIDGET) app@$(TIZEN_IP):/home/app
endif

wgtPkg: clean
	cp -rf ../DNA_common .
	zip -r $(PROJECT).wgt $(WRT_FILES)

config:
	scp setup/weston.ini root@$(TIZEN_IP):/etc/xdg/weston/

$(PROJECT).wgt : dev

wgt:
	zip -r $(PROJECT).wgt $(WRT_FILES)

$(PROJECT).wgt : wgt

all:
	@echo "Nothing to build"
