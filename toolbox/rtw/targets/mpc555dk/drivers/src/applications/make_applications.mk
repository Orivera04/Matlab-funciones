.PHONY : all
all :
	@echo
	@echo +======================================================================
	@echo + Building directory [bootcode] {
	@echo +======================================================================
	@echo
	@$(MAKE) -C bootcode all
	@echo
	@echo +======================================================================
	@echo + } Finished building directory [bootcode] 
	@echo +======================================================================
	@echo

	@echo
	@echo +======================================================================
	@echo + Building directory [flash_programmer] {
	@echo +======================================================================
	@echo
	@$(MAKE) -C flash_programmer all
	@echo
	@echo +======================================================================
	@echo + } Finished building directory [flash_programmer] 
	@echo +======================================================================
	@echo

	@echo
	@echo +======================================================================
	@echo + Building directory [test_external_ram] {
	@echo +======================================================================
	@echo
	@$(MAKE) -C test_external_ram all
	@echo
	@echo +======================================================================
	@echo + } Finished building directory [test_external_ram] 
	@echo +======================================================================
	@echo

	@echo
	@echo +======================================================================
	@echo + Building directory [test_internal_flash] {
	@echo +======================================================================
	@echo
	@$(MAKE) -C test_internal_flash all
	@echo
	@echo +======================================================================
	@echo + } Finished building directory [test_internal_flash] 
	@echo +======================================================================
	@echo


.PHONY : clean
clean :
	@echo
	@echo +======================================================================
	@echo + Cleaning directory [bootcode] 
	@echo +======================================================================
	@echo
	$(MAKE) -C bootcode clean
	@echo
	@echo +======================================================================
	@echo + Finished cleaning directory [bootcode]
	@echo +======================================================================
	@echo
	@echo
	@echo +======================================================================
	@echo + Cleaning directory [flash_programmer] 
	@echo +======================================================================
	@echo
	$(MAKE) -C flash_programmer clean
	@echo
	@echo +======================================================================
	@echo + Finished cleaning directory [flash_programmer]
	@echo +======================================================================
	@echo
	@echo
	@echo +======================================================================
	@echo + Cleaning directory [test_external_ram] 
	@echo +======================================================================
	@echo
	$(MAKE) -C test_external_ram clean
	@echo
	@echo +======================================================================
	@echo + Finished cleaning directory [test_external_ram]
	@echo +======================================================================
	@echo
	@echo
	@echo +======================================================================
	@echo + Cleaning directory [test_internal_flash] 
	@echo +======================================================================
	@echo
	$(MAKE) -C test_internal_flash clean
	@echo
	@echo +======================================================================
	@echo + Finished cleaning directory [test_internal_flash]
	@echo +======================================================================
	@echo
