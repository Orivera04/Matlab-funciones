function out = get(SF,property);
%GET Get function for Features
%
%  GET(SF,'equation') returns a pointer to the subfeature equation.
%  GET(SF,'model') returns a pointer to the Sub Feature model cgexpr.
%  GET(SF,'values') returns list of the values involved in the model 
%  and the equation.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:10:35 $


if nargin==1
   out.equation = 'ptr to cgexpr representing equation';
   out.equationName = 'NameString of equation cgexpr';
   out.model = 'ptr to cgexpr representing comparison model.';
   out.modelName = 'NameString of model';
   out.oppoint = 'ptr to operating point object.';
   out.oppointName = 'NameString of oppoint';
   out.om = 'ptr to OptimMgr object.';
   out.history = 'Cell array of history structures';
   out.historyindex = 'Current revision level of the history';
   out.type = 'Description of Object, for gui purposes';
else
   switch lower(property)
   case 'type'
      out = 'Feature';
   case 'equation'
      out = SF.eqexpr;
   case 'comment'
      out = SF.comment;
   case 'equationname'
      if ~isempty(SF.eqexpr)
         out=SF.eqexpr.getname;
      end
      
   case 'model'
      out = SF.modelexpr;
   case 'modelname'
      if ~isempty(SF.modelexpr)
         out=SF.modelexpr.getname;
      end
   case 'oppoint'
      out = SF.oppoint;
   case 'oppointname'
      if ~isempty(SF.oppoint)
         out=SF.oppoint.getname;
      end
   case 'om'
      out = SF.om;
   case 'history'
      out = SF.history;
   case 'historyindex'
      out = length(SF.history);
   case 'values'
      out = i_getvalues(SF);
   otherwise
      error('SubFeature\get:Unrecognised property');
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_getvalues            %
%%%%%%%%%%%%%%%%%%%%%%%%%%

function out = i_getvalues(SF);

V = values(SF);

for i = 1:length(V.equation)
   out.equation{i} = getname(V.equation(i).info);
end
for j = 1:length(V.model)
   out.model{j} = getname(V.model(j).info);
end