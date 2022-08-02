function inputdata = generatetbstimulus(filterobj, varargin)
%GENERATETBSTIMULUS Generates and returns HDL Test Bench Stimulus
%   GENERATETBSTIMULUS(Hq) automatically generates the filter
%   input stimulus based on the settings for the current filter.
%   The stimulus consists of any or all of impulse, step, ramp,
%   chirp, noise, or user-defined stimulus.  Note that the results
%   are quantized using the input quantizer of Hq.
%
%   GENERATETBSTIMULUS(Hq, PARAMETER1, VALUE1, PARAMETER2, VALUE2, ...) 
%   generates the test bench with parameter/value pairs. Valid 
%   properties and values for GENERATETBSTIMULUS are listed in 
%   the Filter Design HDL Coder documentation section "Property 
%   Reference."
%
%   Y = GENERATETBSTIMULUS(Hq,...) returns the stimulus to MATLAB
%   variable Y. 
%
%   GENERATETBSTIMULUS(Hq,...) with no output argument plots the 
%   stimulus in the current figure window.
%
%   EXAMPLE:
%   % Setup filter
%   h = firceqrip(30,0.4,[0.05 0.03]);
%   Hq = qfilt('fir',{h});
%
%   % Generate Ramp and Chirp stimulus and return in the variable y.
%   y = generatetbstimulus(Hq, 'TestBenchStimulus',{'ramp','chirp'});
%
%   % Generate Noise stimulus and plot in the current figure window
%   generatetbstimulus(Hq, 'TestBenchStimulus','noise');
%
%   See also GENERATEHDL, GENERATETB.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/01 16:09:02 $ 


  global hdl_parameters;

  if isempty(hdl_parameters)
    hdldefaultfilterparameters;         % Set up the default params structure
  end

  hdlparsefilterparameters(varargin{:});

  iq = inputformat(filterobj);
  switch mode(iq)
   case 'fixed'
    slope = 2;
    bias = 1;
    chirpslope = 1;
    chirpbias  = 0;
   case 'ufixed'
    slope = 1;
    bias = 0;
    chirpslope = 1/2;
    chirpbias  = 1/2;
   otherwise
    slope = 2;
    bias = 1;
    chirpslope = 1;
    chirpbias  = 0;
  end

  if isfir(filterobj)
    ilen = impzlength(filterobj.quantizedcoefficients{1},1);
  elseif issos(filterobj)
    ilen = 0;
    % Use impzlength(Hq) here when it is fixed for IIR SOS via geck 163471
    if ~iscell(filterobj.quantizedcoefficients{1})
      ilen = impzlength(filterobj.quantizedcoefficients{1},...
                        filterobj.quantizedcoefficients{2});
    else
      for n = 1:numberofsections(filterobj)
        ilen = max(ilen, impzlength(filterobj.quantizedcoefficients{n}{1},...
                                    filterobj.quantizedcoefficients{n}{2}));
      end
    end
  else
    ilen = 256;                         % default value or error here?
  end

  zlen = ilen;                          % transition band 

  range = [0:1023];

  stimdata = [];
  if any(strcmpi('impulse',hdl_parameters.tb_stimulus))
    impulse = zeros(1,ilen);
    impulse(1) = 1.0;
    stimdata = [stimdata, impulse];
  end

  if any(strcmpi('step',hdl_parameters.tb_stimulus))
    if ~isempty(stimdata)
      stimdata = [stimdata, zeros(1,zlen)];
    end
    step = ones(1,ilen);
    step(1) = 0;
    stimdata = [stimdata, step];
  end

  if any(strcmpi('ramp',hdl_parameters.tb_stimulus))
    if ~isempty(stimdata)
      stimdata = [stimdata, zeros(1,zlen)];
    end
    ramp = slope.*(range./range(end)) - bias;
    stimdata = [stimdata, ramp];
  end

  if any(strcmpi('chirp',hdl_parameters.tb_stimulus))
    if ~isempty(stimdata)
      stimdata = [stimdata, zeros(1,zlen)];
    end
    chin = chirpslope.*chirp(range,0,range(end),0.49) + chirpbias;
    stimdata = [stimdata, chin];
  end


  if any(strcmpi('noise',hdl_parameters.tb_stimulus))
    if ~isempty(stimdata)
      stimdata = [stimdata, zeros(1,zlen)];
    end
    rnd = slope.*rand(1,range(end)+1) - bias;
    stimdata = [stimdata, rnd];
  end

  if ~isempty(stimdata)
    stimdata = [stimdata, zeros(1,zlen)];
  end

  if ~isempty(hdl_parameters.tb_user_stimulus)
    if ~isempty(stimdata)
      stimdata = [stimdata, zeros(1,zlen)];
    end
    stimdata = [stimdata, hdl_parameters.tb_user_stimulus];
  end
    
  if isempty(stimdata)
    error(generatemsgid('unknownstimulus'),...
          'No test bench stimulus was generated');
  end
  
  stimdata  = quantize(iq, stimdata); % quantize the data

  if nargout==0

    % Build Title string
    nstims = length(hdl_parameters.tb_stimulus);

    if ~isempty(hdl_parameters.tb_user_stimulus)
      if nstims == 1
        stimname = 'stimulus';
        stims = sprintf('%s ',hdl_parameters.tb_stimulus{:});
      else
        stimname = 'stimuli';
        stims = sprintf('%s, ',hdl_parameters.tb_stimulus{:});
      end
      if isempty(stims)
        stims = 'user defined';
        stimname = 'stimulus';        
      else
        stims = [stims 'and user defined'];
        stimname = 'stimuli';
      end
    else % no user defined stimulus
      if nstims == 1
        stimname = 'stimulus';
        stims = sprintf('%s ',hdl_parameters.tb_stimulus{:});
      elseif nstims == 2
        stimname = 'stimuli';
        stims = sprintf('%s and %s ',hdl_parameters.tb_stimulus{:});      
      else
        stimname = 'stimuli';
        stims = sprintf('%s, ',hdl_parameters.tb_stimulus{:});
      end
      if stims(end-1:end) == ', '
        stims = stims(1:end-2);           % remove trailing comma & space
      else
        stims = stims(1:end-1);           % remove trailing space        
      end
      lastcomma = find(stims==',');
      if ~isempty(lastcomma)
        stims = [stims(1:lastcomma(end)), ' and', stims(lastcomma(end)+1:end)];
      end
    end

    %hdl = stem(stimdata);
    hdl = plot(stimdata);
    ylim(ylim.*1.1);                    % add some white space around the top and bottom
    title(sprintf('Stimulus data for filter %s\nwith %s %s.',...
                  inputname(1), stims, stimname),...
          'Interpreter','none');
    
  else % return the data
    inputdata = stimdata;
  end


% [EOF]

