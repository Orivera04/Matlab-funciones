function generatehdl(filterobj,varargin)
%GENERATEHDL Generate HDL.
%   GENERATEHDL(Hq) automatically generates VHDL or Verilog code for 
%   the quantized filter, Hq. The default language is VHDL; to generate
%   Verilog, supply the property/value pair 'TargetLanguage', 'Verilog'. 
%   The default file name is 'filter_variable.vhd', e.g., Hq.vhd for
%   VHDL and filter_variable.v e.g. Hq.v for Verilog. The file is 
%   written to the HDL source directory, which defaults to 'hdlsrc'
%   under the current directory. This directory will be created if
%   necessary.
%
%   GENERATEHDL(Hq, PARAMETER1, VALUE1, PARAMETER2, VALUE2, ...)
%   generates the HDL code with parameter/value pairs. Valid properties
%   and values for GENERATEHDL are listed in the Filter Design HDL 
%   Coder documentation section "Property Reference."
%
%   EXAMPLE:
%   h = firceqrip(30,0.4,[0.05 0.03]);
%   Hq = qfilt('fir',{h});
%   generatehdl(Hq);
%   generatehdl(Hq,'TargetLanguage','Verilog');
%   generatehdl(Hq,'Name','myfiltername','TargetDirectory','mysrcdir');
%   generatehdl(Hq,'InputPort','adc_data','OutputPort','dac_data');
%   generatehdl(Hq,'AddInputRegister','on','AddOutputRegister','off');
%   generatehdl(Hq,'OptimizeForHDL','on','CoeffMultipliers','csd');
%
%   See also GENERATETB, GENERATETBSTIMULUS.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/04/01 16:09:00 $ 

  global hdl_parameters;

  hdldefaultfilterparameters();

  if ~isempty(inputname(1)) 
    hdlparsefilterparameters('name',inputname(1)); 
  end

  [cando, errstr] = ishdlable(filterobj);
  if cando
    privgeneratehdl(filterobj,varargin{:});
  else
    error(generatemsgid('unsupportedarch'), errstr);
  end

% [EOF]
