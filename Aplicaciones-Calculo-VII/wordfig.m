function wordfig(filespec,popt)
%WORDFIG Open a MSWord document and paste the current figure into it.
% WORDFIG Paste the current Figure window into a word document.
% WORDFIG(FILE) Past the current Figure window into the document FILE.
% WORDFIG(FILE,POPT) Paste a Figure window into the document FILE using
%  the print options POPT (e.g. -f2 to select Figure window #2).
%  If the FILE argument is missing or empty, the file dialog box is used
%  to select a file name.

% Create or verify a valid file name.
if nargin < 1 | isempty(filespec) | ~ischar(filespec)
  [fname,dname]=uiputfile('*.doc','Modify or create the file:');
  if isequal(fname,0), return, end
  filespec=fullfile(dname,fname);
end
[dname,fname,fext]=fileparts(filespec);
if isempty(dname), dname=pwd; end
if isempty(fext), fext='.doc'; end
filespec=fullfile(dname,[fname,fext]);

% Copy the current Figure window onto the clipboard.
if nargin < 2
  print('-dmeta');
else
  print('-dmeta',popt);
end

% Start a session with MSWord.
wrd=actxserver('Word.Application');
wrd.Visible=1;  % Watch the action...

% Open or create a document.
if ~exist(filespec,'file')
  doc=invoke(wrd.Documents,'Add');
else
  doc=invoke(wrd.Documents,'Open',filespec);
end

% Insert some text at the end of the document.
myrange=doc.Content;
myrange.InsertParagraphAfter;
invoke(myrange,'InsertAfter','---Figure Top Caption Goes Here---');
myrange.InsertParagraphAfter;
% Paste AFTER the existing text.
invoke(myrange,'Collapse',0);
% Paste with "Picture Format" (1) and "Float Over Text" (3) options.
invoke(myrange,'PasteSpecial',0,0,1,0,3);
myrange.InsertParagraphAfter;
invoke(myrange,'InsertAfter','---Figure Bottom Caption Goes Here---');
myrange.InsertParagraphAfter;

% Save and close the document.
if ~exist(filespec,'file')
  invoke(doc,'SaveAs',filespec,1);
else
  doc.Save;
end
doc.Close;

% Quit Word and close the server connection.
wrd.Quit;
delete(wrd);
return
