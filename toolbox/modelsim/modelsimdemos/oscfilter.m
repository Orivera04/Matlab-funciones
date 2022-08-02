function [iport,tnext] = oscfilter(oport, tnow, portinfo)
%OSCFILTER HDL simulator demo "Osc"
%    FITLEROSC is executed by HDLDaemon on request from the HDL simulator.
%
%    ModelSim Entry - Executed by HDLDaemon on request from the HDL simulator
%     OSCFILTER(OPORT,TNOW,PORTINFO)
%     OSCFILTER(OPORT,TNOW)
%     Where
%       OPORT.DATA    - VHDL signal DATA value at simulation time TNOW
%       TNOW          - Simulation time (in seconds) 
%       PORTINFO.DATA - Structure of port information (first invocation)
%
%
%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/04/20 23:19:14 $

  persistent Hresp;
  persistent InDelayLine;
  persistent tscale;
  persistent fastestrate;
  persistent phase;
  global indata;                        % Make these global so that they
  global outdata1x;                     % can be plotted in MATLAB.
  global outdata4x;                     % You must type these same 
  global outdata8x;                     % global commands at the prompt
  global testisdone;

  Nbits  = 22;
  InputScale = 32;                      % Scale the input up by this
  Norder = 31;                          % smallest FIR filter order
  oversample = [1 4 8];                 % oversampling rates
  clockperiod = 80e-9;                  % 80 ns
  oversampleperiods = clockperiod./oversample;

  if nargin == 3 || isempty(Hresp),  % first time being called?
    tscale = portinfo.tscale;
    oversamplefreq = 1./oversampleperiods;
    basefreq = 1;
    for n=1:length(oversamplefreq)
      basefreq = lcm(basefreq,oversamplefreq(n));
    end
    fastestrate = 1 / basefreq;

    centerfreq = 70/256;
    passband = [centerfreq-0.01, centerfreq+0.01];

    for n=1:length(oversample)
      b = fir1((Norder+1)*oversample(n)-1, passband./oversample(n));
      Hresp{n} = oversample(n).*b;
    end

    InDelayLine = zeros(1,Norder+1);
    phase = ones(1,length(oversample));
    indata = [];
    outdata1x = [];
    outdata4x = [];
    outdata8x = [];
  end

  % Process Input Samples at clock rate
  if (mod(round(tnow/tscale), round(clockperiod/tscale)) < 0.5)  %  are we at a clock rising edge
    % Fill the Input Delay Line
    if all( oport.osc_out == '1' | oport.osc_out == '0')
      InDelayLine(2:end) = InDelayLine(1:end-1);
      if oport.osc_out(1) == '1'        % negative
        InDelayLine(1) = InputScale * (bin2dec(oport.osc_out(2:end)')-2^(Nbits-1))/2^(Nbits-1);
      else
        InDelayLine(1) = InputScale * bin2dec(oport.osc_out')/2^(Nbits-1);
      end
      indata = [indata, InDelayLine(1)];
    end
  end

  % Process Output Samples 
  clockedges = mod(round(tnow/tscale), round(oversampleperiods./tscale));

  if clockedges(1) < 0.5                % base sample rate, same as input
    firout1 = sum(Hresp{1}.*InDelayLine);
    outputvalue = dec2bin(floor(firout1*2^(Nbits-1)), Nbits);
    outputvalue(find(outputvalue=='/')) = '1'; % fix negative numbers
    iport.matlab1x_in = outputvalue';
    outdata1x = [outdata1x, firout1];
  end
  % Oversampled outputs 
  if clockedges(2) < 0.5                
    b = Hresp{2};
    firout2 = sum(b(phase(2):oversample(2):phase(2)+oversample(2)*(Norder)).*InDelayLine);
    outputvalue = dec2bin(floor(firout2*2^(Nbits-1)), Nbits);
    outputvalue(find(outputvalue=='/')) = '1'; % fix negative numbers
    iport.matlab4x_in = outputvalue';
    phase(2) = phase(2)+1;
    if phase(2) == oversample(2)+1, phase(2) = 1; end
    outdata4x = [outdata4x, firout2];
  end

  if clockedges(3) < 0.5
    b = Hresp{3};
    firout3 = sum(b(phase(3):oversample(3):phase(3)+oversample(3)*(Norder)).*InDelayLine);
    outputvalue = dec2bin(floor(firout3*2^(Nbits-1)), Nbits);
    outputvalue(find(outputvalue=='/')) = '1'; % fix negative numbers
    iport.matlab8x_in = outputvalue';
    phase(3) = phase(3)+1;
    if phase(3) == oversample(3)+1, phase(3) = 1; end
    outdata8x = [outdata8x, firout3];
  end

  % When ever we are called, wake up on the 
  % next clock rising edge of the fastest rate
  tnext = tnow + fastestrate;
  if tnow > 9.99e-6
    testisdone = 1;
  end
