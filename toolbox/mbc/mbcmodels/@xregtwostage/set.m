function varargout= set(TS,Property,Value)
%SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 08:00:14 $


switch lower(Property)
case 'local'
   TS.Local=Value;
case 'global'
   if iscell(Value)		% Passing in cell array of models
      % Make global models equal new models
      TS.Global=Value;	
   elseif isa(Value,'xregmodel')
      if iscell(TS.Global)
         % If old global is a cell array and new global is a model
         % overwrite all old ones with a copy of the new one
         [TS.Global{:}]=deal(Value);	
      else
         % Special case of the above where old global is just a single model
         TS.Global=Value;
      end
   end
case 'datum'
   TS.datum=Value;
   if ~isa(Value,'xregmodel') 
      isd= get(TS.Local,'isdatum');
      if isd(1) 
         % response feature is also datum model
         m1 = TS.Global{1};
			m2= xregcubic('nfactors',nfactors(m1));
         m2= update(m2,zeros(size(m2)));
         m2= copymodel(m1,m2);
			set(m2,'ytrans','');
         TS.Global{1}=m2;
         TS.datum    =m2;
      end
		% change coding range of model
      % [Bnd,g,Tgt]= getcode(TS);
		% Bnd(1,:)= Bnd(1,:)- mean(Bnd(1,:));
		% Tgt(1,:)= [-Inf Inf];
		% TS= setcode(TS,Bnd,g,Tgt);
		TS.Local= set(TS.Local,'DatumType',0);
	end
otherwise
   try
      TS.xregmodel= set(TS.xregmodel,Property,Value);
      if nargout==1
         varargout{1}=TS;
      else
         assignin('caller',inputname(1),TS);
      end
   catch
      error(['TWOSTAGE/SET - Invalid Property ',Property])
   end
end   

if nargout==1
   varargout{1}=TS;
else
   assignin('caller',inputname(1),TS);
end