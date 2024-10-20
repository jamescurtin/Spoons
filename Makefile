ZIPDIR=Spoons
SRCDIR=Source
SOURCES := $(wildcard $(SRCDIR)/*.spoon)
SPOONS := $(patsubst $(SRCDIR)/%, $(ZIPDIR)/%.zip, $(SOURCES))
ZIP=rpzip

.PHONY: test

.PHONY: all
all: $(SPOONS)

.PHONY: clean
clean:
	rm -f $(ZIPDIR)/*.zip

$(ZIPDIR)/%.zip: $(SRCDIR)/%
	rm -f $@
	# Create the zip archive with fixed metadata
	cd $(SRCDIR) ; $(ZIP) -r ../$@ $(patsubst $(SRCDIR)/%, %, $<)
