Additional Notes on Configuration for XC167
-------------------------------------------

- The Starter kit board has an external oscillator frequency of 8 MHz. To
  achieve a system frequency of 40 MHz select Project
  Options-->Application-->Startup-->PLLCON then
      PLLODIV = 0x3 (Output divider = 4)
      PLLIDIV = 0x0 (Input divider = 1)
      PLLVB = 1 (VCO Band selectd = 150-200 MHz)
      PLLMUL = 0x13 (multipliction factor = 20)
      PLLCTRL = 3 (PLL clk used, input clk connected)

- Decrease the number of wait states for accessing external RAM. Select Project
  Options-->Application-->Startup-->TCONCS0 then set Phase E to 2 clock cycles
  and Phase F (write) to 0 clock cycles; check that resulting value for TCONCS0
  is 0x0040.
