ZFLAGS = -ur
XLFLAGS = --dropdtd --noent

SOURCES = \
	$(srcdir)/index.html \
	$(srcdir)/icon.png \
	$(srcdir)/css \
	$(srcdir)/js \
	$(srcdir)/images \
	$(srcdir)/DNA_common
CONFIG = config.xml
TARGET = $(PACKAGE_NAME).wgt

EXTRA_DIST = $(CONFIG) $(SOURCES)
CLEANFILES = $(TARGET)
MAINTAINERCLEANFILES = $(CONFIG)

ZFLAGS_V = $(ZFLAGS_V_@AM_V@)
ZFLAGS_V_ = $(ZFLAGS) -q
ZFLAGS_V_0 = $(ZFLAGS)

wgtdir = $(datadir)/wgt
wgt_DATA = $(TARGET)

$(TARGET): $(CONFIG) $(SOURCES)
	$(AM_V_GEN) $(ZIP) $(ZFLAGS_V) $@ $(CONFIG) $(SOURCES)

$(CONFIG): $(top_srcdir)/configure.ac.in $(PACKAGE).xml.in
	$(AM_V_GEN) $(XML_LINT) $(XLFLAGS) $(PACKAGE).xml > $@
