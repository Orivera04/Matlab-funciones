function D= usertransient(varargin);
%XREGTRANSIENT Constructor for transient model
%
%  MDL = XREGTRANSIENT('name',NM) creates a transient model object, MDL,
%  with the name NM.
%
%  Example usage:
%
%    m = xregtransient('name','fuelpuddle');
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:59:08 $


if nargin==1 && isa(varargin{1},'xregtransient')   
   D = varargin{1};             
   return
end


%% ============= DEFAULTS ===================
p= [];
simName= 'functemplate'; %% = funcName
init_simVars = {'tau','x'};
init_state0=0;
nf=2;
funcName= '';
%% ===========================================
%% Delete all of this?? It should be in 'set'??

if nargin>=2
   for i=1:2:nargin-1
       switch lower(varargin{i})
           case {'funcname','simname','name'}
               simName= varargin{i+1};
               funcName = varargin{i+1};
           case 'nfactors'
               nf= varargin{i+1};
               [list, f] = getmodellist(xregtransient, nf);
               if isempty(list)
                   error('No transient models available for %d factors.\n', nf);
               else
                   simName = list{1};
                   funcName = list{1};
               end
           case 'param'
               p= varargin{i+1};
           case 'state0'
               init_state0= varargin{i+1};
           case 'simvars'
               init_simVars= varargin{i+1};
       end %%switch
   end %% loop for each pair of argin
end
%% ===============================================

%% check if input is a structure
if nargin==1 && isa(varargin{1},'struct')
   %% D is a structure. Check for each field
   
	[D,u]= i_Update(varargin{1});
	
else
   u= xregusermod;   
   u = set(u, 'nfactors', nf);
   D.simName= simName;
   if isempty(funcName)
      funcName= [simName,'M'];
   end
   
   %% ensure funcName==simName for xregusermod methods
   
   D.state0= init_state0;
   D.simVars = init_simVars;
end
%% Now we have that m = localmod, u = xregusermod;

%% SET UP INHERITANCE
D= class(D,'xregtransient',u);

%% set fields from inputs
D= funcinit(D,simName);
D = simvars(D);
[null,D] = state0(D);
if ~isempty(p)
   D= update(D,p);
end


function [D,u]= i_Update(D);

if ~isfield(D,'xregusermod')
    u= xregusermod;
    u = set(u, 'nfactors', nf);
else
	u = xregusermod(D.xregusermod);
	D= rmfield(D,'xregusermod');
end
if ~isfield(D,'simName')
	D.simName= simName;
end

%% ensure funcName==simName for xregusermod methods

if ~isfield(D,'state0')
	D.state0= state0;
end
if ~isfield(D,'simVars')
	D.simVars = simVars;
end
%% set order of fields
tmp.simName=D.simName;
tmp.state0= D.state0;
tmp.simVars= D.simVars;
D = tmp;

