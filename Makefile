PKG_NAME=cmsis-dsp

# A list of all the directories to build for CMSIS-DSP
CMSIS_DIRS += \
  BasicMathFunctions \
  CommonTables \
  ComplexMathFunctions \
  ControllerFunctions \
  FastMathFunctions \
  FilteringFunctions \
  MatrixFunctions \
  StatisticsFunctions \
  SupportFunctions \
  TransformFunctions \
#

INCLUDES += -I$(CURDIR)/include
CMSIS_BINDIRS = $(addprefix $(BINDIR)$/(PKG_NAME)/,$(CMSIS_DIRS))

# Override default RIOT search path for sources to include all of the CMSIS-DSP
# sources in one library instead of one library per subdirectory.
SRC := $(foreach DIR,$(CMSIS_DIRS),$(wildcard $(DIR)/*.c))
SRCXX := $(foreach DIR,$(CMSIS_DIRS),$(wildcard $(DIR)/*.cpp))
ASMSRC := $(foreach DIR,$(CMSIS_DIRS),$(wildcard $(DIR)/*.s))
ASSMSRC := $(foreach DIR,$(CMSIS_DIRS),$(wildcard $(DIR)/*.S))

OBJC    := $(SRC:%.c=$(BINDIR)/$(PKG_NAME)/%.o)
OBJCXX  := $(SRCXX:%.cpp=$(BINDIR)/$(PKG_NAME)/%.o)
ASMOBJ  := $(ASMSRC:%.s=$(BINDIR)/$(PKG_NAME)/%.o)
ASSMOBJ := $(ASSMSRC:%.S=$(BINDIR)/$(PKG_NAME)/%.o)
OBJ = $(OBJC) $(OBJCXX) $(ASMOBJ) $(ASSMOBJ)

# Create subdirectories if they do not already exist
$(OBJ): | $(CMSIS_BINDIRS)

$(CMSIS_BINDIRS):
	@mkdir -p $@

# Reset the default goal.
.DEFAULT_GOAL :=

# Include RIOT settings and recipes
include $(RIOTBASE)/Makefile.base
