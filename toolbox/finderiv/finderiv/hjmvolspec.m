function VolSpec = hjmvolspec(varargin)
%HJMVOLSPEC Specify a HJM forward rate volatility process.  
%   Specifies the volatility process sigma(t,T) where t is the
%   observation time and T is the starting time of a forward rate.  In a
%   stationary process the volatility Term is T-t.  Multiple factors can
%   be specified sequentially.  Each factor is specified with one of the
%   following functional forms: 
%
%   Constant volatility (Ho-Lee): sigma(t,T) = Sigma_0
%   VolSpec = hjmvolspec('Constant', Sigma_0)
%
%   Stationary volatility: sigma(t,T) = Vol( T - t ) = Vol( Term )
%   VolSpec = hjmvolspec('Stationary', CurveVol , CurveTerm)
%   
%   Exponential: sigma(t,T) = Sigma_0*exp(- Lambda * (T-t) )
%   VolSpec = hjmvolspec('Exponential', Sigma_0, Lambda)
%
%   Vasicek, Hull-White: sigma(t,T) = Sigma_0*exp(- Decay(T-t) )
%   VolSpec = hjmvolspec('Vasicek', Sigma_0, CurveDecay , CurveTerm)
%
%   Nearly proportional stationary: 
%   sigma(t,T) = Prop( T - t ) * max( SpotRate(t) , MaxSpot )
%   VolSpec = hjmvolspec('Proportional', CurveProp , CurveTerm, MaxSpot )
%
% Inputs:
%   Sigma_0    - Scalar base volatility over a unit time.
%   Lambda     - Scalar decay factor.
%   CurveVol   - NCURVE x 1 vector of Vol values at sample points.
%   CurveDecay - NCURVE x 1 vector of Decay values at sample points.
%   CurveProp  - NCURVE x 1 vector of Prop values at sample points.
%   CurveTerm  - NCURVE x 1 vector of term sample points T-t.
%
% Output:
%   VolSpec - Structure specifying the volatility model for HJMTREE.
%
% Notes:
%   The time values T, t, and Term are in coupon interval units specified
%   by the Compounding input of HJMTIMESPEC.  For instance if Compounding
%   is 2, Term = 1 is a semi-annual period (6 months).
%
% Examples:
%   %Single-factor proportional
%   CurveProp = [0.11765; 0.08825; 0.06865];
%   CurveTerm = [   1   ;    2   ;    3   ];
%   VolSpec = hjmvolspec('Proportional', CurveProp, CurveTerm, 1e6)
%
%   % Two-factor, exponential and constant
%   VolSpec = hjmvolspec('Exponential', 0.1, 1, 'Constant', 0.2)
%
% See also HJMTREE, HJMTIMESPEC, HJMVOLPROC.
%

%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.14 $  $Date: 2002/04/14 16:38:16 $

% Catch shift usage
if isafin(varargin{1},'HJMVolSpec')
  VolSpec = hjmvolspecshift(varargin{:});
  return
end

FactorModelLoc = find( cellfun('isclass', varargin, 'char') );
NumFactors = length(FactorModelLoc);

% Pull off the factor tags
FactorModels = varargin(FactorModelLoc);

% Pull off the factor data
FactorArgs = cell(1,NumFactors);
FactorModelLoc = [FactorModelLoc, nargin+1];
for iFactor=1:NumFactors,
  FactorArgs{ iFactor } = varargin( ...
      (FactorModelLoc(iFactor)+1):(FactorModelLoc(iFactor+1)-1) );
end
  
%-----------------------------------------------------------------
% Check validity of tags and data
%-----------------------------------------------------------------
ValidateFactors(FactorModels, FactorArgs)
        
%-----------------------------------------------------------------
%-----------------------------------------------------------------

% Store data for each factor
VolSpec = classfin('HJMVolSpec');
VolSpec.FactorModels = FactorModels;
VolSpec.FactorArgs   = FactorArgs;
VolSpec.SigmaShift   = 0;

% Factor handling
VolSpec.NumFactors = NumFactors;
VolSpec.NumBranch = VolSpec.NumFactors + 1;
switch VolSpec.NumFactors
 case 1
  
   VolSpec.PBranch     = [0.5 0.5];
   VolSpec.Fact2Branch = [ -1  1 ];
    
 case 2
  
   VolSpec.PBranch =     [ 0.25     0.25   0.5  ];
   VolSpec.Fact2Branch = [  -1       -1     1   ; 
                           -sqrt(2) sqrt(2)  0   ];
    
 case 3   
   VolSpec.PBranch =     [ 0.125    0.125   0.25    0.5 ];
   VolSpec.Fact2Branch = [  -1       -1      -1      1  ; 
                          -sqrt(2) -sqrt(2) sqrt(2)  0  ; 
                            -2        2       0      0  ];
 otherwise
   error( sprintf(['HJMVOLSPEC, HJMVOLPROC  do not support' ...
   ' %d factors\n'], VolSpec.NumFactors) )
end



return

function VolSpecUp = hjmvolspecshift(VolSpec, SigmaShift)

VolSpecUp = VolSpec;

for i=1:VolSpecUp.NumFactors
  switch VolSpecUp.FactorModels{i}
   case 'Constant'
    % Sigma_0 + Shift
    VolSpecUp.FactorArgs{i}{1} = VolSpecUp.FactorArgs{i}{1} + SigmaShift;
     
   case 'Stationary'
    % F + Shift
    VolSpecUp.FactorArgs{i}{1} = VolSpecUp.FactorArgs{i}{1} + SigmaShift;
     
   case 'Exponential'
    % Sigma_0 + Shift
    VolSpecUp.FactorArgs{i}{1} = VolSpecUp.FactorArgs{i}{1} + SigmaShift;
     
   case 'Vasicek'
    % Sigma_0 + Shift
    VolSpecUp.FactorArgs{i}{1} = VolSpecUp.FactorArgs{i}{1} + SigmaShift;
    
   case 'Proportional' 
    % F + Shift
    VolSpecUp.FactorArgs{i}{1} = VolSpecUp.FactorArgs{i}{1} + SigmaShift;

   case 'Spot'
    % F + Shift
    VolSpecUp.FactorArgs{i}{1} = VolSpecUp.FactorArgs{i}{1} + SigmaShift;
     
%-----------------------------------------------------------------
% Customizable region: shift new models
%-----------------------------------------------------------------
  end
end
return




function ValidateFactors(FactorModels, FactorArgs)

for iFactor = 1:length(FactorModels)
    switch lower(FactorModels{iFactor})
    	case 'constant'
             Sigma_0 = FactorArgs{iFactor}{1};
             if(prod(size(Sigma_0))~=1)
        		error('Sigma_0 must be a scalar')
    		 end
             
    	case 'stationary'
            [CurveVol, CurveTerm] = deal(FactorArgs{iFactor}{:});
            if(length(CurveVol) ~= length(CurveTerm))
                error('CurveVol and CurveTerm must be of equal lengths')
            end
            
    	case 'exponential'
            [Sigma_0, Lambda] = deal(FactorArgs{iFactor}{:});
            if(prod(size(Sigma_0))~=1)
        		error('Sigma_0 must be a scalar')
    		end
            if(prod(size(Lambda))~=1)
        		error('Lambda must be a scalar')
    		end
            
    	case 'vasicek'
            [Sigma_0, CurveDecay, CurveTerm] = deal(FactorArgs{iFactor}{:});
            if(prod(size(Sigma_0))~=1)
        		error('Sigma_0 must be a scalar')
    		end
            if(length(CurveDecay) ~= length(CurveTerm))
                error('CurveDecay and CurveTerm must be of equal lengths')
            end

    	case 'proportional'
        	[CurveProp , CurveTerm, MaxSpot] = deal(FactorArgs{iFactor}{:});
    	otherwise
        	error(sprintf('Unknown factor type ''%s''',FactorModels{iFactor}));
    end
end

