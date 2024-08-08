TOP_ENTRY := ./vsrc/TestTop.v
TOP_FILES := ./vsrc/filelist.txt
TOP_MODULE = TestTop
TARGET_NAME = CoupledL2

WAVE := true
TL ?= python
VERBOSE := false
EXAMPLE := false


ifneq ($(TARGET),)
	TARGET := $(TARGET)
else
	TARGET := out/picker_out_coupledL2
endif

# if EXAMPLE is set, then _EXAMPLE is set to -e
ifneq ($(EXAMPLE), false)
	_EXAMPLE := -e
endif
_EXAMPLE ?=
# if VERBOSE is set, then _VERBOSE is set to -v
ifneq ($(VERBOSE), false)
	_VERBOSE := --verbose
endif
_VERBOSE ?=
# if WAVE is set, then _WAVEFORM is set to -w
ifneq ($(WAVE), false)
	ifneq ($(WAVE), true)
		_WAVEFORM := -w $(WAVE)
	else
		_WAVEFORM := -w RAS.fst
	endif
endif
_WAVEFORM ?=

dut:
	@echo "Building tage module with parameters: "
	@echo "TL=${TL}"
	@echo "TOP_ENTRY=${TOP_ENTRY}"
	@echo "TOP_FILES=${TOP_FILES}"
	@echo "TARGET=${TARGET}"
	@echo "WAVEFORM=${_WAVEFORM}"
	@echo "VERBOSE=${_VERBOSE}"
	@echo "EXAMPLE=${_EXAMPLE}"

	@mkdir -p out
	rm -rf ${TARGET}
	picker export ${TOP_ENTRY} --sname ${TOP_MODULE} --tname ${TARGET_NAME} --fs ${TOP_FILES} --lang ${TL} -c\
		--tdir ${TARGET} ${_WAVEFORM}${_EXAMPLE} ${_VERBOSE} --cp_lib

clean:
	rm -rf ${TARGET}
