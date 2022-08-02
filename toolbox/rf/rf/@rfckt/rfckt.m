function varargout=rfckt(varargin)
%RFCKT RF circuit object.
%    Hd = RFCKT.COMPONENT(input1,...) returns an RFCKT object, Hd, of type
%    COMPONENT. You must specify a component with RFCKT. Each component
%    takes one or more inputs. When you specify an RFCKT.COMPONENT
%    with/without inputs, an RF circuit with specified/default parameters
%    is created (the defaults depend on the particular RF circuit
%    component).
%
%    RFCKT.COMPONENT can be one of the following.
%
%    The following objects are the RF circuit objects.
%    General RF Networks
%      rfckt.datafile        - RF network described by a data file
%      rfckt.amplifier       - Amplifier described by a data file
%      rfckt.mixer           - Mixer described by a data file
%      rfckt.cascade         - Cascaded network
%      rfckt.series          - Series connected network
%      rfckt.hybrid          - Hybrid connected network
%      rfckt.parallel        - Parallel connected network
%    Transmission Lines
%      rfckt.txline          - General transmission line
%      rfckt.twowire         - Two-Wire transmission line
%      rfckt.parallelplate   - Parallel-Plate transmission line
%      rfckt.coaxial         - Coaxial transmission line
%      rfckt.microstrip      - Microstrip transmission line
%      rfckt.cpw             - Coplanar Waveguide transmission line
%    RLC Circuits
%      rfckt.seriesrlc       - Series RLC Circuit
%      rfckt.shuntrlc        - Shunt RLC Circuit
%    LC Ladder Filters
%      rfckt.lclowpasstee    - LC Lowpass Tee Network
%      rfckt.lclowpasspi     - LC Lowpass Pi Network
%      rfckt.lchighpasstee   - LC Highpass Tee Network
%      rfckt.lchighpasspi    - LC Highpass Pi Network
%      rfckt.lcbandpasstee   - LC Bandpass Tee Network
%      rfckt.lcbandpasspi    - LC Bandpass Pi Network
%      rfckt.lcbandstoptee   - LC Bandstop Tee Network
%      rfckt.lcbandstoppi    - LC Bandstop Pi Network
%
%    The following methods are available for rfckt objects (type help
%    rfckt.rfckt.METHOD to get help on a specific method - e.g. help
%    rfckt.rfckt.analyze):
%
%      analyze               - Analyze the circuit in frequency domain  
%      calculate             - Calculate the needed parameters
%      copy                  - Copy the object
%      getdata               - Get the RFDATA object
%      listformat            - List the legitimate formats for the given PARAMETER
%      listparam             - List the legitimate parameters that can be visualized
%      plot                  - Plot the data on X-Y plane
%      polar                 - Plot the data on polar plane
%      smith                 - Plot the data on the Smith chart
%
%    Example:
%
%    % Construct an amplifier
%    % The properties of amplifier are  
%    %      File:     Data file
%    %      IntpType: Interpolation Type: linear/cubic/spline
%    %      OIP3:     Output third order intercept point
%    %      NF:       Noise Figure
%      ckt = rfckt.amplifier('File', 'default.amp');    
%
%    % Do frequency domain analysis at the given frequency
%      f = .9e9:1e8:3e9;             % Simulation frequency
%      analyze(ckt,f);               % Do frequency Domain analysis
%     
%    % Visualize the Results
%      plot(ckt,'s21', 'db');        % Plot dB(S21) in XY plane
%      polar(ckt,'s21');             % Plot S21 in polar plane
%      smith(ckt,'GAMMAIN','zy');    % Plot GAMMAIN in ZY Smith chart
%
%    % Common methods 
%      methods(ckt);                 % List all class methods
%      get(ckt);                     % Get the properties
%      delete(ckt);                  % Delete the object
%
%  See also RFDATA.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.13 $  $Date: 2004/04/12 23:38:05 $

msg = sprintf(['Use RFCKT.COMPONENT to create an RFCKT object.\n',...
               'For example,\n   Hd = rfckt.txline']);
error(msg)
