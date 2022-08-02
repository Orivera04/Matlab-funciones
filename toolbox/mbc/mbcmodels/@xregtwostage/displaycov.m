function displaycov(TS,ProgTable);
% TWOSTAGE/DISPLAYCOV display covariance Matrix in a table

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:59:35 $

if ~isempty(TS.covmodel)
   % display covariance matrix
   Nf= length(TS.Global);
   set(ProgTable{2},'string','Covariance Matrix')
   set(ProgTable{1},...
      'rows.number',Nf+1,...
      'cols.number',Nf,...
      'cells.rowselection',[1 Nf+1],...
      'cells.colselection',[1 Nf],...
      'cells.type','uitext');
   ProgTable{1}.redraw;
   ProgTable{1}(0,:).String= RespFeatName(TS.Local)';
   ProgTable{1}(1:Nf,:).horizontalalignment= 'right';
   
   ProgTable{1}(1:Nf,:)= unstruct(TS.covmodel);
   ProgTable{1}(1:Nf,:).cells.format= '%.4g';
   ProgTable{1}(triu(ones(Nf),1)~=0).visible= 'off';
end