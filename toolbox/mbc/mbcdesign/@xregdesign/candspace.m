function out=candspace(des,tp,varargin);
% DESIGN/CANDSPACE   Set and get the point generation method
%   D=CANDSPACE(D,METHOD,PARAMLIST) set the candidate generation
%   method to METHOD and sets up the parameters in PARAMLIST.
%   Current options are:
%      METHOD     |    PARAMS
%   -------------------------------------------------------
%    'continuous' | cell array of vectors containing min and
%                 | max of candidate space dimensions.
%    'fullgrid'   | cell array of vectors containing factor
%                 | levels for each dimension.
%    'lattice'    | cell array containing min/max, vector of
%                 | primes (g), value for N.
%    'grid/lattice| {dims for grid, dims for lattice}, cell array
%                 | of vectors of factor levels for each grid dim,
%                 | cell array of [min max] for each lattice dim,
%                 | vector of g values for each lattice dim,
%                 | value of N for lattice.
%    'userdef'    | matrix of points.
%    'lhs'        | cell array containing min/max, value for N, 
%                 | string indicating choosing method
%
%   S=CANDSPACE(D) returns a structure containing the fields
%   'method' and 'parameters' which defines the current settings.
%
%
%  alternatively, METHOD may be a valid CandidateSet object type

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:06:13 $


if nargin==1;
   out=des.candset;
else
   if ischar(tp)
      switch lower(tp)
      case 'continuous'
         warning('Continuous candidate sets are no longer supported.  A Grid is being used.');
         for n=1:length(varargin{1})
            lvls{n}=linspace(min(varargin{1}),max(varargin{1}),21);
         end
         des.candset=cset_grid(lvls);
      case 'fullgrid'
         des.candset=cset_grid(varargin{1});
      case 'lattice'
         des.candset=cset_lattice(varargin);
      case 'grid/lattice'
         des.candset=cset_grdlatt(varargin);
      case 'userdef'
         % take limits from model, or data if data exceeds model limits
         c=getcode(model(des))';
         mn=min(varargin{1},[],1);
         mn=min(mn,c(1,:));
         mx=max(varargin{1},[],1);
         mx=max(mx,c(2,:));
         lims=[mn(:) mx(:)];
         cs=candidateset(lims);
         des.candset=cset_userdef(cs,varargin{1});
      case 'lhs'
         des.candset=cset_lhs([varargin {'random',1}]);
      end
   else
      % assume that tp is a candidate set
      des.candset = tp;
   end
   % fix any inconsistencies
   des=fixcandspace(des);
   
   % Also need to zero out all current design indices since they 
   % refer to a different generation scheme
   if ~isempty(des.designindex)
      des.designindex(:)=0;
   end
   des.candstate=des.candstate+1;   
   
   % need to re-eval constraints since all the points have changed
   if ~isempty(des.constraints)
      des.constraints=reset(des.constraints);
      des=EvalConstraints(des);   
   end
   
   if ~nargout
      nm=inputname(1);
      assignin('caller',nm,des);
   else
      out=des;
   end
end
return




