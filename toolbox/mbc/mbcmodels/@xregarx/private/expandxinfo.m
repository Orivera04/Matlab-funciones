function new = expandxinfo( xi, yi, order, delay, time )
%EXPANDXINFO   Dynamic to static input symbol conversion
%   EXPANDXINFO(XINFO,YINFO,ORDER,DELAY,TIME) takes the dynamic input stucture 
%   XINFO and output structture YINFO and produces an Xinfo structure for the 
%   static part of a dynamic model with dynamic order ORDER and, optionally, 
%   delay DELAY. If DELAY is not sepcified or is empty, it is taken to be all 
%   zero. To specify the timestep varaible, use TIME. The default is 'k'.
%
%   An input X gets expanded to X(K-Q), X(K-P-1), ..., X(K-Q-P+1), where Q is 
%   the delay and P the dyanmic order for that variable. Note that X 
%   contributes P terms. An input corresponding to the current timestep is only 
%   used in the model if the delay for that input is zero. If the dynamic input 
%   for an input is zero, then that input is not used at all in the model. The 
%   delay for the output (feedback) must be greater than zero.
%
%   See also EXPANDDATA.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:45:31 $


% XINFO
%       Names: {''}
%       Units: {[1x1 junit]}
%     Symbols: {'X1'}
% 
% YINFO
%       Name: 'y'
%      Units: [1x1 junit]
%     Symbol: 'y'

% Parse inputs
if ~isstruct( xi ) | ~all(ismember({'Names','Units','Symbols'},fieldnames(xi)))
    error( ['Invalid input. XINFO must be a structure with fields ', ...
            '''Names'', ''Units'', and ''Symbols''.'] );
end
if ~isstruct( yi ) | ~all(ismember({'Name','Units','Symbol'},fieldnames(yi)))
    error( ['Invalid input. YINFO must be a structure with fields ', ...
            '''Name'', ''Units'', and ''Symbol''.'] );
end
if length( order ) ~= length( xi.Symbols ) + 1,
    error( ['Invalid input. Length of ORDER must be one more than that ', ...
            'of XINFO.Symbols'] );
end
if nargin < 4 | isempty( delay ),
    delay = zeros( size( order ) );
elseif ~isnumeric( delay ),
    error( 'Invalid input. DELAY must be a numeric.' )
end
if nargin < 5,
    time = 'k';
elseif ~ischar( time ),
    error( 'Invalid input. TIME must be a char.' )
end

% Expand the inputs
dynamicsymbols = i_symbols( xi.Symbols, order(1:end-1), delay(1:end-1), time );
dynamicunits   = i_units(   xi.Units,   order(1:end-1), delay(1:end-1), time );
dynamicnames   = i_names(   xi.Names,   order(1:end-1), delay(1:end-1), time );

% Exapnd the fedback outputs, if required
if order(end) > 0,
    backsymbols = i_symbols( {yi.Symbol}, order(end), delay(end), time );
    backunits   = i_units(   {yi.Units},  order(end), delay(end), time );
    backnames   = i_names(   {yi.Name},   order(end), delay(end), time );
    dynamicsymbols = { dynamicsymbols{:}, backsymbols{:} }';
    dynamicunits   = { dynamicunits{:},   backunits{:} }';
    dynamicnames   = { dynamicnames{:},   backnames{:} }';
end

% Setup the output structure
new = struct( ...
    'Names',   {dynamicnames}, ...
    'Units',   {dynamicunits}, ...
    'Symbols', {dynamicsymbols} );

return

%------------------------------------------------------------------------------|
function new = i_units( units, order, delay, time )

nf = length( units );
ni = sum( order );
new = cell( ni, 1 );

z = 1; % cell array placement tracker
for i = 1:nf, 
    for j = 1:order(i), 
        new(z) = units(i);
        z = z + 1;
    end
end

return

%------------------------------------------------------------------------------|
function new = i_names( names, order, delay, time )

nf = length( names );
ni = sum( order );
new = cell( ni, 1 );

z = 1; % cell array placement tracker
for i = 1:nf, 
    if order(i),
        if isempty( names{i} ),
            z = z + order(i);
        else,
            if delay(i) == 0,
                new(z) = strcat( names(i), '(', time, ')' );
            else
                new(z) = strcat( names(i), '(', time, '-', int2str( delay(i) ), ')' );
            end
            z = z + 1;
            for j = delay(i) + (1:order(i)-1); % input counter
                new(z) = strcat( names(i), '(', time, '-', int2str(j), ')' );
                z = z + 1;
            end
        end
    end
end

return

%------------------------------------------------------------------------------|
function new = i_symbols( symbols, order, delay, time )

nf = length( symbols );
ni = sum( order );
new = cell( ni, 1 );

z = 1; % cell array placement tracker
for i = 1:nf, 
    if order(i),
        if delay(i) == 0,
            new(z) = strcat( symbols(i), '(', time, ')' );
        else
            new(z) = strcat( symbols(i), '(', time, '-', int2str( delay(i) ), ')' );
        end
        z = z + 1;
        for j = delay(i) + (1:order(i)-1); % input counter
            new(z) = strcat( symbols(i), '(', time, '-', int2str(j), ')' );
            z = z + 1;
        end
    end
end

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
