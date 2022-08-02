function m = xregarx( varargin )
%XREGARX   Dynamic auto-regression with exogenous variables.
%   XREGARX(ORDER) or XREGARX('DynamicOrder',ORDER), where ORDER is a vector of 
%   non-negative integers is an ARX model. The number of input factors is 
%   infered from the length of ORDER. There must be one more element in the 
%   vector ORDER than there are numbers of factors. The last element of ORDER 
%   is the dynamic order of the fedback model output.
%   XREGARX('NFactors',N), where N is a positive integer sets up an ARX model 
%   with N inputs factors and the dynamic order all zeros. With no inputs, 
%   XREGARX is an ARX model with one input factor.
%
%   An input X gets expanded to X(K-Q), X(K-P-1), ..., X(K-Q-P+1), where Q is 
%   the delay and P the dyanmic order for that variable. Note that X 
%   contributes P terms. An input corresponding to the current timestep is only 
%   used in the model if the delay for that input is zero. If the dynamic input 
%   for an input is zero, then that input is not used at all in the model. The 
%   delay for the output (feedback) must be greater than zero.
%
%   XREGARX is a child of XREGMODEL.
%
%   See also 
%     XREGMODEL   Base class for all MBC models
%     XREGARX/CHAR   Convert XREGARX object to character array
%     XREGARX/COMPLETECOPYMODEL   Model copy completion 
%     XREGARX/DIAGNOSTICSTATS   Diagnostic statistics for dynamic ARX models
%     XREGARX/DOUBLE   Parameters of model
%     XREGARX/DYNAMICDIAGNOSTICS   Diagnostic tools for dynamic modeling
%     XREGARX/EVAL   Evaluation of a dynamic ARX model at a sequence of points
%     XREGARX/GET   Implements the get method for the XREGARX object
%     XREGARX/GLOBALBUTTONS   Global model buttons for XREGLOLIMOT
%     XREGARX/GUI_GLOBALMODSETUP   gui for altering XREGARX settings
%     XREGARX/NAME   Name function for XREGARX objects
%     XREGARX/RESETSTATICMODEL   Reset the static model embedded in an ARX 
%        dynamic model
%     XREGARX/SET   Implements the set method for the XREGARX object
%     XREGARX/SETCODE   Set the coding of the overall and the embedded model
%     XREGARX/SPECIALPLOTS  Diagnostic plots particular to dynamic ARX modeling
%     XREGARX/STATICLIST   List of static models avalible for use with ARX 
%        models
%     XREGARX/STATS   Statistics for dynamic ARX models
%     XREGARX/STR_FUNC   Formatted function description 
%     XREGARX/UPDATE   Coefficient update for dynamic ARX objects
%     XREGARX/VIEW   View the ARX model in a figure
%     XREGARX/XINFO   Input variable information structure set/get method
%     XREGARX/YINFO   Output variable information structure set/get method
%     XREGMODEL/DYNEVAL   Parallel mode evaluation for dynamic models
%     XREGMODEL/FEEDBACKEVAL   Model evaluation with feedback
%     XREGLINEAR/DYNX2FX   Parallel mode regression matrix for dynamic models
%     XREGLINEAR/FEEDBACKX2FX   Regression matrix with feedback
%
%     XREGARX/__PARALLELFIT   Fits a dynamic ARX model using output error
%     XREGARX/__SERIESPARALLELFIT   Fits a dynamic ARX model using equation error

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:45:49 $


%
% Parse inputs
if nargin == 0,
    nf = 1;
    dynamicorder = ones( 1, 2 );
    
elseif nargin == 1,
    if isa( varargin{1}, 'xregarx' ),
        m = varargin{1};
        return
    else
        % varargin{1} is the vector of dynamic orders
        dynamicorder = varargin{1};
        nf = length( varargin{1} ) - 1;
    end
    
elseif nargin == 2,
    if ~isa( varargin{2}, 'double' ),
        error( 'Second argument must be a vector of doubles' );
    end
    switch lower( varargin{1} ),
        %  varargin{1} is intialization option
    case 'dynamicorder',
        if length( varargin{2} ) < 2, 
            error( 'Dyanmic order must have at least 2 terms' );
        end
        dynamicorder = varargin{2};
        nf = length( varargin{2} ) - 1;
        
    case 'nfactors',
        nf = varargin{2};
        dynamicorder = ones( 1, nf + 1 );
        
    otherwise
        error( sprintf( 'Unknown intialization option ''%s''.', varargin{1} ) );
    end
    
else
    error( 'Too many input arguments' );
end

% check the non-negativity of the dynamic order 
dynamicorder = floor( dynamicorder );
if any( dynamicorder < 0 ),
    error( 'Dyanmic order must be non-negative' );
elseif all( dynamicorder < 1 ),
    error( 'Dyanmic order must have at least one term greater than zero' );
end

% for the moment, the delay will be zeros, except for the feedback
delay = zeros( size( dynamicorder ) );
delay(end) = 1;

%
% Setup parent model
parent = xregmodel( 'nfactors', nf );
set( parent, 'FitAlg', 'seriesparallelfit' );

% 
% Expand inputs 
staticxinfo = expandxinfo( xinfo( parent ), yinfo( parent ), ...
    dynamicorder, delay );

%
% Stup static model
staticmodel = xregdynlolimot( [ dynamicorder; delay ] );
staticmodel = xinfo( staticmodel, staticxinfo );

%
% Setup ARX structure
m = struct( ...
    'Version', 1.0, ...
    'Frequency', 1.0, ...
    'DynamicOrder', dynamicorder, ...
    'Delay', delay, ...
    'StaticModel', staticmodel );

%
% Turn the struct into a class object
m = class( m, 'xregarx', parent );

return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
