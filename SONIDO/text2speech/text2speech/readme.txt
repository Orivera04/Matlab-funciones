Version 1.0
Summary:
Converts text to speech.
 
Matlab Release: V7 R14 SP2
 
Required Products: 
Microsoft SAPI
 
Description: 
Any text is spoken.
 
Get started...
1. Make sure SAPI is installed on your computer
   a) get the Speech SDK 5.1 (86MB) for free from Microsoft:
http://www.microsoft.com/downloads/details.aspx?FamilyId=5E86EC97-40A7-453F-B0EE-6583171B4530&displaylang=en
   b) test your default computer voice
Start->Control Panel-> Sounds,Speech...->Speech->Text To Speech->Preview Voice
2. add the text2speech folder to your Matlab path
3. Test your new function: text2speech('This is a test.')

I would like to thank "Desmond Lang" for his Text-To-Speech tutorial
and my wife for letting me play with the computer ;).

You can find Desmond's tutorial at:
http://www.gamedev.net/reference/articles/article1904.asp

Example:
Casual chat.
text2speech({'Hello. How are you?','It is nice to speak to you.','regards SAPI.'})

Emphasising
text2speech('You can <EMPH> emphasis </EMPH> text.');

Silence
text2speech('There will be silence now <SILENCE MSEC=''500''/> and speech again.');

text2speech('You can <pitch middle=''-10''/> drop the pitch.');
text2speech('But you can make it <pitch middle=''+10''/> jump as well.');


Other related work:
Just before I put this text2speech into the file exchange, I noticed something 
pretty similar, written by Fahad Al Mahmood called speak:
http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=4769&objectType=file

 
This work is free software; 
you can redistribute it and/or modify it under the terms of the 
GNU General Public License as published by the Free Software Foundation; 
either version 2 of the License, or (at your option) any later version. 
This work is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty 
of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
See the GNU General Public License for more details.

