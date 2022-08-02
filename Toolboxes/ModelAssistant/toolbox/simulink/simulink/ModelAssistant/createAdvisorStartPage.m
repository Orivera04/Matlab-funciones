function createAdvisorStartPage

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:12 $

htmlSource = fileread(HTMLattic('AtticData', 'AdvisorTemplatePage'));
javascript = fileread([HTMLattic('AtticData', 'cmdRoot') filesep 'Advisortranslate.js']);
startPage = HTMLattic('AtticData', 'AdvisorStartPage');
f=fopen(startPage, 'w');
htmlSource = strrep(htmlSource, '<!--Insert Javascript template-->', javascript);
htmlSource = strrep(htmlSource, '<!--start system template-->', HTMLattic('AtticData', 'StartInSystemTemplate'));
fprintf(f, '%s', htmlSource);
fclose(f);
