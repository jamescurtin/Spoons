ZIPDIR=Spoons
SRCDIR=Source
SOURCES := $(wildcard $(SRCDIR)/*.spoon)
SPOONS := $(patsubst $(SRCDIR)/%, $(ZIPDIR)/%.zip, $(SOURCES))
ZIP=/usr/bin/zip
FIXED_DATE := 198001010000 # YYYYMMDDHHMM format for touch

all: $(SPOONS)

clean:
	rm -f $(ZIPDIR)/*.zip

$(ZIPDIR)/%.zip: $(SRCDIR)/%
	rm -f $@
	# Recursively set a fixed timestamp for all files and directories in the full source path
	find $< -exec touch -t $(FIXED_DATE) {} \;
	# Create the zip archive with fixed metadata
	cd $(SRCDIR) ; $(ZIP) -X -r ../$@ $(patsubst $(SRCDIR)/%, %, $<)

.PHONY: clean
