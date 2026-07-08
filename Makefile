ZIPDIR=Spoons
SRCDIR=Source
SOURCES := $(wildcard $(SRCDIR)/*.spoon)
SPOONS := $(patsubst $(SRCDIR)/%, $(ZIPDIR)/%.zip, $(SOURCES))
ZIP=rpzip

.DEFAULT_GOAL := all

.PHONY: all
all: $(SPOONS)

.PHONY: clean
clean:
	rm -f $(ZIPDIR)/*.zip

.PHONY: test
test:
	@echo "No automated tests defined"

$(ZIPDIR)/%.zip: $(SRCDIR)/%
	rm -f $@
	# Create the zip archive with fixed metadata
	cd $(SRCDIR) ; $(ZIP) -r ../$@ $(patsubst $(SRCDIR)/%, %, $<)
