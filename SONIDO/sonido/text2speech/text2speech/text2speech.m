function text2speech( text )
% This function converts text into speech.
% You can enter any form of text (less than 512 characters per line) into
% this function and it speaks it all.
%
% Note: It requires that the Microsoft SAPI is installed. The speech SDK
% 5.1 can be obtained from:
% http://www.microsoft.com/downloads/details.aspx?FamilyId=5E86EC97-40A7-453F-B0EE-6583171B4530&displaylang=en
%
% I would like to thank "Desmond (Dez) Lang" for his Text-To-Speech tutorial
% and my wife for letting me play with the computer ;).
%
% You can find Desmond's tutorial at:
% http://www.gamedev.net/reference/articles/article1904.asp
% All I did, was to make use of this fantastic tutorial and put it into a
% little DLL.
%
% Input:
% * text ... text to be spoken (character array, or cell array of
% characters)
%
% Output:
% * spoken text
%
% Example:
% Casual chat.
% Speak({'Hello. How are you?','It is nice to speak to you.','regards SAPI.'})
%
% Emphasising
% text2speech('You can <EMPH> emphasis </EMPH> text.');
%
% Silence
% text2speech('There will be silence now <SILENCE MSEC=''500''/> and speech again.');
%
% text2speech('You can <pitch middle=''-10''/> drop the pitch.');
% text2speech('But you can make it <pitch middle=''+10''/> jump as well.');
%
% See also: initSpeech, unloadSpeechLibrary
%
%% Signature
% Author: W.Garn
% E-Mail: wgarn@yahoo.com
% Date: 2006/06/04 22:20:00 
% 
% Copyright 2006 W.Garn
%

if nargin<1
    text = 'Please call this function with text';
end
try
    if ~isa(text,'cell')
        text = {text};
    end
    for k=1:length(text)
        calllib('wgText2Speech','Speak',text{k});
    end
catch
    loadlibrary('wgText2Speech','Speak.h');
    text2speech( text );
end
    
