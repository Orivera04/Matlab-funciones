function v=mmodeini(varargin)
%MMODEINI Initialize ODE Parameters for MMODESS.
% MMODEINI(Name,Value, . . .) sets ODE parameters described by
% Name/Value pairs. Available pairs and default values are
%
%  Name         Value    Limits       Description
% 'RelTol'      1e-3      >0          Relative Error Tolerance
% 'AbsTol'      1e-6      >0          Absolute Error Tolerance
% 'MinStep'     1e-10     >1e-12      Minimum Stepsize
% 'MaxStep'       1       >=Hmin      Maximum Stepsize
% 'NextStep'     []       >=Hmin      Next (or Initial) Stepsize
% 'SafetyFactor' 0.9     (0.75,.95)   Stepsize Safety Factor
% 'GrowthLimit'    5     (2,20)       Stepsize Growth Limit Ratio
% 'ShrinkLimit'  0.1     (.05,.5)     Stepsize Shrink Limit Ratio
% 'FallBack'     'on'    ('on','off') Enable Fall Back on Step Failure
%
% Changes are cummulative from one call to the next.
% Only the first two characters of each Name is required.
% MMODEINI default  sets above parameters to their default settings.
% MMODEINI(Name) returns the value of the parameter given by Name.
% MMODEINI with no input arguments displays all parameter values.
%
% See also MMODESS, MMODE45, MMODE45P, MMODECHI.

% Calls: mmempty mmonoff

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 7/8/96, revised 11/1/96, 12/14/96, 6/12/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

global MMODE_Rtol MMODE_Atol MMODE_Hmin MMODE_Hmax
global MMODE_SF MMODE_GL MMODE_SL MMODE_FB
global MMODE_A MMODE_B MMODE_H
global MMODE_5 MMODE_5E MMODE_3 MMODE_3E MMODE_2 MMODE_2E MMODE_CHI

Rtol=1e-3; % define defaults
Atol=1e-6;
Hmin=1e-10;
Hmax=1;
SF=0.9;
GL=5;
SL=0.1;
FB=1;
tol=100*eps;

if nargin==0 & isempty(MMODE_Rtol)
   help mmodeini
elseif nargin==0 & ~isempty(MMODE_Rtol)
   fprintf('\tRelTol = %.4g\n',MMODE_Rtol)
   fprintf('\tAbsTol = %.4g\n',MMODE_Atol)
   fprintf('\tMinStep = %.4g\n',MMODE_Hmin)
   fprintf('\tMaxStep = %.4g\n',MMODE_Hmax)
   if ~isempty(MMODE_H)
      fprintf('\tNextStep = %.4g\n',MMODE_H)
   end
   fprintf('\tSafetyFactor = %.4g\n',MMODE_SF)
   fprintf('\tGrowthLimit = %.4g\n',MMODE_GL)
   fprintf('\tShrinkLimit = %.4g\n',MMODE_SL)
   fprintf('\tFallBack = %s\n',mmonoff(MMODE_FB))
   return
elseif nargin==1
   p1=varargin{1};
   if ~ischar(p1), error('Parameter Names Must be Strings.'), end
   name=lower(p1(isletter(p1)));
   switch name(1:2)
   case 're', v=MMODE_Rtol; return
   case 'ab', v=MMODE_Atol; return
   case 'mi', v=MMODE_Hmin; return
   case 'ma', v=MMODE_Hmax; return
   case 'ne', v=MMODE_H; return
   case 'sa', v=MMODE_SF; return
   case 'gr', v=MMODE_GL; return
   case 'sh', v=MMODE_SL; return
   case 'fa', v=mmonoff(MMODE_FB); return
   case 'de'
      MMODE_Rtol=Rtol; MMODE_Atol=Atol; MMODE_Hmin=Hmin; MMODE_Hmax=Hmax;
      MMODE_SF=SF; MMODE_GL=GL; MMODE_SL=SL; MMODE_FB=FB; MMODE_H=[];
   otherwise
      error('Unkown Parameter Requested.')
   end
elseif rem(nargin,2)
   error('Names and Values Must be Entered in Pairs.')
else % set parameter values
   for i=1:2:nargin-1
      name=varargin{i};
      if ~ischar(name), error('Parameter Names Must be Strings.'), end
      name=lower(name(isletter(name)));
      value=varargin{i+1};
      switch name(1:2)
      case 're'
         MMODE_Rtol=mmempty(value(1),Rtol);
         if MMODE_Rtol<=tol
            MMODE_Rtol=Rtol;
            disp('Reltol set to default.');
         end
      case 'ab'
         MMODE_Atol=mmempty(value(:),Atol);
         i=find(MMODE_Atol<=tol);
         if ~isempty(i)
            MMODE_Atol(i)=Atol(ones(1,length(i)));
            disp('Abstol set to default.');
         end
      case 'mi'
         MMODE_Hmin=mmempty(value(1),Hmin);
         if MMODE_Hmin<tol
            MMODE_Hmin=Hmin;
            disp('MinStep set to default.');
         end
      case 'ma'
         MMODE_Hmax=mmempty(value(1),Hmax);
         if MMODE_Hmax<MMODE_Hmin
            MMODE_Hmax=Hmin;
            disp('MaxStep set to MinStep.');
         end
      case 'ne'
         MMODE_H=value(1);
         if ~isempty(MMODE_H) & MMODE_H<Hmin
            MMODE_H=Hmin;
            disp('NextStep set to MinStep.');
         end
      case 'sa'
         MMODE_SF=mmempty(value(1),SF);
         if MMODE_SF<.75
            MMODE_SF=.75;
            disp('SafetyFactor set to 0.75.');
         end
         if MMODE_SF>.95
            MMODE_SF=.95;
            disp('SafetyFactor set to 0.95.');
         end
      case 'gr'
         MMODE_GL=mmempty(value(1),GL);
         if MMODE_GL<2
            MMODE_GL=2;
            disp('GrowthLimit set to 2.');
         end
         if MMODE_GL>20
            MMODE_GL=20;
            disp('GrowthLimit set to 20.');
         end
      case 'sh'
         MMODE_SL=mmempty(value(1),SL);
         if MMODE_SL<.05
            MMODE_SL=.05;
            disp('ShrinkLimit set to 0.05.');
         end
         if MMODE_SL>.5
            MMODE_SL=.5;
            disp('ShrinkLimit set to 0.5.');
         end
      case 'fa'
         MMODE_FB=mmonoff(value);
         MMODE_FB=mmempty(MMODE_FB,FB);
      otherwise
         disp(['Unknown Parameter Name --> ' name])
      end % switch
   end % for
end % if
if isempty(MMODE_A) % Establish Integration Parameters
   MMODE_A=[1/5 3/10 3/5 1 7/8];  % 1 by 5, time increments
   MMODE_B=[1/5        0       0         0            0        0
      3/40       9/40    0         0            0        0
      3/10       -9/10   6/5       0            0        0
      -11/54     5/2     -70/27    35/27        0        0
      1631/55296 175/512 575/13824 44275/110592 253/4096 0]';  % 5 by 6
   
   MMODE_5=[37/378;0;250/621;125/594;0;512/1771];  % 6 by 1
   MMODE_5E=MMODE_5-[2825/27648;0;18575/48384;13525/55296;277/14336;1/4];
   MMODE_3=[1/10;0;2/5;1/10;0;0];
   MMODE_3E=[1;0;-2;1;0;0];
   MMODE_2=[1;1;0;0;0;0]/10;
   MMODE_2E=[-1;1;0;0;0;0];
   MMODE_CHI=[2 1 -2 1;-3 -2 3 -1;0 1 0 0;1 0 0 0];
end
