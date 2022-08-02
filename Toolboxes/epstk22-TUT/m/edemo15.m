%%
%% Routine: Font list
%% (see demo15.png) 
%%
eopen('demo15.eps');
eglobpar;

%a few global parameter
eTextFontSize=4;
Space=2;

%titel
etext('Font List of epsTk',eWinWidth/2,230,9,0,1);

% text
for i=1:32
  text=sprintf('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz Font No.: %d',i);
  etext(text,1,eWinHeight-30-i*(eTextFontSize+Space),eTextFontSize,1,i);
end

eclose;
ebbox(5);
if ~exist('noDemoShow')
  eview                                   % start ghostview with eps-file
end
