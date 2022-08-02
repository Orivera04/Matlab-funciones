function  varargout = set(varargin)
%SET
%
% Set function for SubFeature objects.
%
% SF = set(SF,'equation',[p,eq]) sets the equation field to
% the expression pointed to by eq. p should be a pointer to the 
% Subfeature SF which is used to update the SF lists in the 
% tables contained in the expression eq.info so that these tables 
% know they are involved in this Subfeature.
%
% SF = set(SF,'model',mod) sets the model field to the model 
% pointed to by mod. mod must be a model expression.
%
% SF = set(SF , 'comment' , CommentString) sets the comment field
% within the SubFeature.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:10:52 $

if nargin == 1
   
   varargout{1} = i_ShowFields;
   
else
   
   SF = varargin{1};
   if nargin < 3
      error('SubFeature::set: Insufficient arguments.');
   end
   for i = 2:2:nargin
      property = lower(varargin{i});
      new_value = varargin{i+1};
      if ~isa(property , 'char')
         error('SubFeature::set: Non character array property name.');
      end
      
      switch property  
      case 'equation'
         SF = i_seteq(SF,new_value);
         
      case 'model'
         SF = i_setmodel(SF,new_value);
         
      case 'oppoint'
         SF = i_setoppoint(SF,new_value);
         
      case 'om'
         SF = i_setom(SF,new_value);
         
      case 'comment'
         if ischar(new_value)
            SF.comment = new_value;
         end
      case 'history'
         if iscell(new_value)
            SF.history = new_value;
         elseif isstruct(new_value)
            SF.history = [SF.history {new_value}];
         end
      end  
   end
   if nargout > 0
      varargout{1} = SF;
   elseif ~isempty(inputname(1))
      assignin('caller' , inputname(1) , SF);
   end

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_showfields                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function out = i_ShowFields;
out.equation = '[ptr to this subfeature, ptr to cgexpr representing equation]';
out.model = 'ptr to cgexpr representing comparison model.';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_seteq                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function SF = i_seteq(SF,eq);

% eq should be a 1 by 2 vector of pointers. The first should 
% point to this object since it will then be added to the 
% SFlist in the table objects contained in the equation.
% the second pointer should point to this equation.

% check first pointer points to this SF.

if ~isequal(getname(SF),getname(eq(1).info))
   error('First entry must be a pointer to the SF');
end

if prod(size(eq)) == 2
   if ~isa(eq(2).info,'cgexpr')
      error('error:: Expression object required for expression field');
   elseif isa(eq(2).info,'cgmodexpr')
      error('error:: Equation field cannot take a model');
   end
end

r = SF.eqexpr;
% remove references to this feature from old equation expression objects
if ~isempty(r)
   U = [r;r.getptrsnosf];
   for i = 1:length(U)
      if isa(U(i).info,'Lookup');
         U(i).info = UpdateSFlist(U(i).info,eq(1),0);
      end
   end
end

if prod(size(eq)) == 2
   SF.eqexpr = eq(2);
   % now update the table SFlists.
   V = [eq(2);eq(2).getptrsnosf];
   for i = 1:length(V)
      if isa(V(i).info,'cglookup')
         V(i).info = UpdateSFlist(V(i).info,eq(1),1);
      end
   end
else
   SF.eqexpr = [];
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_setmodel                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function SF = i_setmodel(SF,model);

% sets the model in a SubFeature.

%First check we have a modelexpr.

if isempty(model)
   SF.modelexpr = [];   
else      
   SF.modelexpr = model;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_setoppoint                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function SF = i_setoppoint(SF,oppoint);

%First check we have an oppoint
if isempty(oppoint)
    SF.oppoint = [];   
else
    if ~isvalid(oppoint) | ~isa(oppoint.info,'cgoppoint')
        error('SubFeature:: set: cgoppoint object needed to set oppoint');
    else
        SF.oppoint = oppoint;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_setom                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function SF = i_setom(SF,om);

% sets the OptimMgr in a SubFeature.

%First check we have an oppoint

if isempty(om)
   SF.om = [];   
else
    if ~isa(om,'optimMgr')
        error('SubFeature:: set: optimMgr object needed to set om');
    else
       SF.om = om;
    end
end