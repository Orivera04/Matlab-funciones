function m= exportmodel(mdev,View)
% MODELDEV/EXPORTMODEL  prepares a model for export 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 08:10:16 $



if mdev.BestModel==0 & ~isempty(children(mdev))
   % model not validated and some kids are present
   m=[];
else
   if isa(mdev.Model,'xregtwostage')
      m= mdev.Model;
      if ~pevcheck(m)
         plocal= mdev.BestModel;
         plocal.InitStore;
         m= plocal.BestModel;
      end
      if get(m,'datumtype')
         % export the datum model separately
         pdatum= datumlink(mdev);
         if pdatum~=0
            dmodel= pdatum.exportmodel;
            m= {m,dmodel};
         end
      end
   else
      % pack all model PEV data into model
      m= model(mdev);
      if ~pevcheck(m)
         mdev= InitStore(mdev);
         % Make sure all the model info is packed into the model
         m= model(mdev);
      end
   end
end