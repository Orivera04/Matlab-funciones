function hInfo = generatePropertyPages(obj, hPropDialog)
%GENERATEPROPERTYPAGES Generate standard property pages for the expression
%
%  HINFO = GENERATEPROPERTYPAGES(OBJ, HDIALOG) creates property pages that
%  plug into the standard xregGui.propertyDialog framework

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.1 $    $Date: 2004/04/04 03:27:39 $ 

hInfo = [propPageGeneral(obj, hPropDialog); ...
    propPageInputs(obj, hPropDialog); ...
    propPageModel(obj, hPropDialog); ...
    propPageInfo(obj, hPropDialog)];
