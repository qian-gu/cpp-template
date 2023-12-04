############################### Customise #####################################
CURDIR := $(shell pwd)
src_dir := $(CURDIR)/src
inc_dir := $(CURDIR)/include
build_dir := $(CURDIR)/build
target := out

############################### Variables #####################################

CXX := g++
CXXFLAGS := -g -Wall -O3 -I$(inc_dir)
LDFLAGS ?=
LIBS ?=

depdir := $(build_dir)/.deps
DEPFLAGS = -MT $@ -MMD -MP -MF $(depdir)/$*.d

COMPILE.c = $(CXX) $(DEPFLAGS) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c

srcs := $(foreach dir, $(src_dir), $(wildcard $(dir)/*.cpp))
objs := $(addprefix $(build_dir)/, $(addsuffix .o, $(notdir $(basename $(srcs)))))

vpath %.cpp $(src_dir)
vpath %.h $(inc_dir)

############################### Rules #########################################

.PHONY: all rebuild clean

all: $(build_dir)/$(target)

rebuild: clean all

$(build_dir)/$(target): $(objs)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $(LIBS) $^ -o $@

$(build_dir)/%.o: %.cpp $(depdir)/%.d | $(depdir)
	$(COMPILE.c) $(OUTPUT_OPTION) $<

$(depdir): ; @mkdir -p $@

DEPFILES := $(addprefix $(depdir)/, $(addsuffix .d, $(notdir $(basename $(srcs)))))
$(DEPFILES):
include $(wildcard $(DEPFILES))

clean:
	rm -rf $(build_dir)

debug:
	@echo $(srcs)
	@echo $(objs)
	@echo $(DEPFILES)
	@echo $(depdir)
