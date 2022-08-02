function slide=DTdemo
%DTDEMO slideshow of Decision Theory Methods: MAVT, HYEA, ELECTRE III
%   It is only meant to give  users a feeling of what these functions can achieve and how they
%   perform in terms of input and output data; it is not meant to cover any theoretical aspect
%   related to the Decision Theory area. A minimal theoretical background is therefore
%   required to take full advantage of the capabilities of these methods.
%
%   Please refer to the help of the specific functions to explore in greater details the options
%   available.
%
%   See also: MAVT, HYEA, ELECTRE3
%
% This is a slideshow file for use with playshow.m and makeshow.m
% To see it run, type 'playshow DTdemo', or simply DTdemo. 

% Author:      Francesco di Pierro        Dep. of Electronics and Computer Science (DEI),
%                                          Politecnico di Milano
%                                          f_dipierro@yahoo.com

if nargout<1,
  playshow DTdemo
else
  %========== Slide 1 ==========

  slide(1).code={
   'cla reset',
   'load DTTLOGO',
   'image(DTTLOGO)',
   'axis off',
   'movegui(gcf,''center'')'};
  slide(1).text={
   'This demo will present the algorithms herein implemented:',
   '',
   '- Multi Attribute Value Theory (MAVT);',
   '- Hierarchical Analysis (HYEA);',
   '- Electre III (ELECTRE3);',
   '',
   'They are historically nested in the Decision Theory area; these days, they are broadly applied to a variety of fields to help with the assessment of alternative performances.',
   '',
   ''};

  %========== Slide 2 ==========

  slide(2).code={
   'axis off',
   'load mavt_dat',
   'out = evalc(''disp(A(1:6,1:5))'');',
   'xptext(''>> A = '','' '','' '','' '','' '','' '',out)' };
  slide(2).text={
   'Let''s start with the MAVT...',
   'The first thing we need is an impact matrix, which, from now on, will be referred to as A (Environmental Impact Matrix).',
   'Data extracted from a real application can be loaded from:',
   '',
   '>> load mavt_dat',
   '',
   'A small portion of the EIA matrix is visualized; column index represents different alternatives whilst row index represents indicators used to assess the alternative performances.'};

  %========== Slide 3 ==========

  slide(3).code={
   'cla',
   'plot(I1(:,1),I2(:,2),''Color'',''b'',''Marker'',''d'',''MarkerEdgeColor'',''r'',''LineWidth'',1.5)',
   'title(''Example of Utility Function'')',
   'ylabel(''dimensionless'')',
   'legend(''U(I1)'')'};
  slide(3).text={
   'The next thing we need is a set of Utility Functions to convert dimensional values of performances associated to each indicator into dimensionless values, scaled to be within the range [0,1].',
   '',
   'This graph represents the Utility Function associated to the first indicator provided.',
   '',
   'The last thing we need is a weight factor associated to each indicator in order to aggregate the information carried by the set of indicators into a scalar representing the global performance of a particular alternative.'};

  %========== Slide 4 ==========

  slide(4).code={
   'cla reset',
   'axis off',
   'CCM = diag(ones(5,1));',
   'CCM(~CCM) = NaN;',
   'out = evalc(''disp(CCM);'');',
   'xptext(''CCM ='',''   '',''   '',''   '',out,''   '',''   '',''To set the element i,j to val, type CCM(i,j) = val:'')'};
  slide(4).text={
   'The weight vector (a weight factor for each indicator) can be directly provided or derived by interactively filling a couples-comparison matrix (CCM).',
   'Should the user choose the latter option, he/she would be prompted to set CCM upper triangular values, one at a time, by specifying a degree of preference between a row index alternative and a column index alternative.',
   '',
   'Linked preferences will be automatically computed to ensure consistency through the following chain rule:',
   '',
   'CCM(i,j) = CCM(i,k) * CCM(j,k)'};
%========== Slide 5 ==========

  slide(5).code={
   'cla reset',
   'axis off',
   'CCM(1,2) = 3;',
   'out = evalc(''disp(CCM);'');',
   'xptext(''CCM ='',''   '',''   '',''   '',out,''   '',''   '',''To set the element i,j to val, type CCM(i,j) = val:'')'};
  slide(5).text={
   'Suppose you chose to interactively derive the weight vector...',
   'Let''s say that the alternative 2 is preferred to the alternative 1 by a factor of 3; you should then set the element CCM(1,2) as it follows:',
   '',
   '>> CCM(1,2) = 3',
   '',
   'The matrix CCM now looks different and you are still prompted to set a new element.'
   'Let''s now say that the alternative 3 is preferred to the alternative 2 by a factor of 4...'};


%========== Slide 6 ==========

  slide(6).code={
   'cla reset',
   'axis off',
   
% ======= users of matlab 5 can uncomment the following lines  ====   
%    'if ichange==-1',
%    'nextslidears=slideData.param(SlideShowi+1).vars;',
%    'strvec = nextslidears(:,1);',
%    'ind = strcmp(''hnpmavt'',strvec);',
%    'if ~isempty(ind)',
%    'hndl = nextslidears{ind,2};',
%    'if ishandle(hndl(1))',
%    'delete(hndl(1))',
%    'end',
%    'if ishandle(hndl(2))',
%    'delete(hndl(2))',
%    'end',
%    'end',
%    'end',
% =================================================================

   'CCM(2,3) = 4;',
   'CCM(1,3) = 12;'
   'out = evalc(''disp(CCM);'');',
   'xptext(''CCM ='',''   '',''   '',''   '',out,''   '',''   '',''To set the element i,j to val, type CCM(i,j) = val:'')'
   'movegui(gcf,''center'')'};
  slide(6).text={
   '...and set the element CCM(2,3) to 4 as you did before.'
   '',
   'The element CCM(2,3) is now set to 4, but the element CCM(1,3) has also been set; this is due to the consistency chain:',
   '',
   'CCM(i,j) = CCM(i,k) * CCM(j,k)'
   '',
   'Proceeding in this way you will fill out the CCM matrix, which will then have proportional rows due to the consistency chain; a row normalized to one is the weight vector we are looking for.'};
  

  %========== Slide 7 ==========

  slide(7).code={
   'cla reset',
   'load DTTLOGO',
   'image(DTTLOGO)',
   'axis off',
   'movegui(gcf,''west'')',
   '[ORD,U,w,hnpmavt] = mavt(A,w,I1,I2,I3,I4,I5,I6);',
   'movegui(hnpmavt(1),''northeast'')',
   'movegui(hnpmavt(2),''southeast'')',
   'figure(gcf)'};
  slide(7).text={
   'Let''s now invoke the routine to get the final order of the alternatives considered; assume that the weight vector w has been derived through the iterative procedure shown above.',
   '',
   '>> [ORD,U,w,hnp] = mavt(A,w,I1,I2,I3,I4,I5,I6);',
   '',
   'The routine automatically produces a figure with the representation of the computed utility functions and a figure showing the alternatives sorted in descending order.',
   'You can click on a particular alternative to see the utility value associated to it.'};

  %========== Slide 8 ==========

  slide(8).code={
   'cla reset',
   'load DTTLOGO',
   'image(DTTLOGO)',
   'axis off', 
   
% ======= users of matlab 5 can uncomment the following lines  ====   
%    'if ichange==1 & ishandle(hnpmavt)',
%    'delete(hnpmavt)',
%    'end',
% =================================================================

   'movegui(gcf,''center'')'};
  slide(8).text={
   'The information required to carry out a multi attribute value analysis is quite extensive but easy to provide.',
   '',
   'Let''s now consider another method to sort alternatives on the basis of a set of indicators: the hierarchical analysis (HYEA).',
   '',
   'To following will load the data extracted from a real application:',
   '',
   '>> load hyea_dat'};

  %========== Slide 9 ==========

  slide(9).code={
   'cla reset',
   
% ======= users of matlab 5 can uncomment the following lines  ====
%    'if ichange==-1',
%    'nextslidevars=slideData.param(SlideShowi+1).vars;',
%    'strvec = nextslidevars(:,1);',
%    'ind = strcmp(''hnphyea'',strvec);',
%    'if ~isempty(ind) & ishandle(nextslidevars{ind,2})',
%    'delete(nextslidevars{ind,2})',
%    'end',
%    'end',
% =================================================================
    
   'load hyea_dat',
   'cellplot(hy)',
   'movegui(gcf,''center'')'};
  slide(9).text={
   'The structure of the input data required by the HYEA routine is quite complex (the plot is a graphical representation of the input data: see the command CELLPLOT) and it is fully documented within the hyea function specific help, which can be accessed by typing at the command line.',
   '',
   '>> help hyea',
   '',
   'The routine is launched by typing',
   '',
   '>> [ORD,PERFPAR,W,hnp] = hyea (hy)'};

  %========== Slide 10 ==========

  slide(10).code={
   'cla reset',
   'load DTTLOGO',
   'image(DTTLOGO)',
   'axis off',
   'movegui(gcf,''west'')',
   '[ORD,PERFPAR,W,hnphyea] = hyea (hy);'
   'movegui(hnphyea,''east'')',
   'figure(gcf)'};
  slide(10).text={
   'The hierarchy obtained graphically represents the structure provided as input.',
   ''
   'The order has bee obtained assuming the standard Saaty scaling criterion to define preferences amongst elements of the hierarchy when compared through an element belonging to a higher level of the hierarchical structure (please refer to the help of the hyea function to have a more detailed explanation of input/output data structure.)',
   '',
   'By clicking on a particular element you can visualize the partial performance of alternatives obtained up to that element.'};

  %========== Slide 11 ==========

  slide(11).code={
   'cla reset',
   'load DTTLOGO',
   'image(DTTLOGO)',
   'axis off',    
   
% ======= users of matlab 5 can uncomment the following lines  ====   
%    'if ichange==1 & ishandle(hnphyea)',
%    'delete(hnphyea)',
%    'end',
%    'if ichange==-1',
%    'nextslidevars=slideData.param(SlideShowi+1).vars;',
%    'strvec = nextslidevars(:,1);',
%    'ind = strcmp(''hnpel'',strvec);',
%    'if ~isempty(ind) & ishandle(nextslidevars{ind,2})',
%    'delete(nextslidevars{ind,2})',
%    'end',
%    'end',
% =================================================================

   'load electre3_dat',
   'movegui(gcf,''center'')' };
  slide(11).text={
   'The last routine still to be presented is ELECTRE III.',
   'The information required by this method is quite extensive: to have a detailed explanation of the necessary input data, type at the command line',
   '',
   '>> help electre3',
   '',
   'The following will load data extracted from a real application',
   '',
   '>> load electre3_dat',
   ''};

  %========== Slide 12 ==========

  slide(12).code={
   'cla reset',
   'load DTTLOGO',
   'image(DTTLOGO)',
   'axis off',   
   'movegui(gcf,''west'')',
   '[ORD, hnpel] = electre3 (A,q,p,v,w,s1,s2);',
   'movegui(hnpel,''east'')',
   'figure(gcf)'};
  slide(12).text={
   'Let''s now invoke the routine:',
   '',
   '>> [ORD, hnp] = electre3 (A,q,p,v,w,s1,s2);',
   '',
   'The output of the routine is simply a matrix, which is the minimal information required to draw the ordering graph associated to the problem considered: for instance, from the first row you can infer that the first alternative (A1) dominates the second (A2), from the second row you can tell that A2 dominates A6...and from the fourth row that A4 dominates A3 and A7...and so on.'};

%========== Slide 13 ==========

  slide(13).code={
   'delete(hnpel)',
   'cla reset',
   'load DTTORD',
   'image(DTTORD)',
   'axis off',   
   'movegui(''center'')'};
  slide(13).text={
   'The final graph associated to the matrix shown before is presented above.',
   '',
   'All these methods, MAVT, HYEA and ELECTRE III can be positively applied to a broad variety of situations.',
   '',
   'The level of interaction with the decision makers, the amount of information at disposal and the drawbacks of each algorithm (Rank Reversal,...), should be carefully taken into account when selecting the analysis method most suitable to tackle a particular issue.'};
end