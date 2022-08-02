function generatehdl(filterobj, varargin)
%GENERATEHDL Generate HDL.
%   GENERATEHDL(Hb) automatically generates VHDL or Verilog code for 
%   the quantized filter, Hb. The default language is VHDL; to generate
%   Verilog, supply the property/value pair 'TargetLanguage','Verilog'. 
%   The default file name is the name of the filter variable, e.g. 
%   Hb.vhd for VHDL and Hb.v for Verilog.  The file is written to 
%   the HDL source directory which defaults to 'hdlsrc' under the 
%   current directory. This directory will be created if necessary.
%
%   GENERATEHDL(Hb, PARAMETER1, VALUE1, PARAMETER2, VALUE2, ...)
%   generates the HDL code with parameter/value pairs. Valid properties
%   and values for GENERATEHDL are listed in the Filter Design HDL 
%   Coder documentation section "Property Reference."
%
%   EXAMPLE:
%   h = firceqrip(30,0.4,[0.05 0.03]);
%   Hb = dfilt.dffir(h);
%   Hb.arithmetic = 'fixed';
%   Hb.castbeforesum = false;
%   generatehdl(Hb);
%   generatehdl(Hb,'TargetLanguage','Verilog');
%   generatehdl(Hb,'Name','myfiltername','TargetDirectory','mysrcdir');
%   generatehdl(Hb,'InputPort','adc_data','OutputPort','dac_data');
%   generatehdl(Hb,'AddInputRegister','on','AddOutputRegister','off');
%   generatehdl(Hb,'OptimizeForHDL','on','CoeffMultipliers','csd');
%
%   See also GENERATETB, GENERATETBSTIMULUS.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/04/01 16:19:57 $ 

% M-file help for generatehdl method.

% [EOF]

