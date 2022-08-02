function varargout = v3d_getcolormap(varargin)
% Select/import colormaps
%
% Adaptation of function "v3d_getcolormap" by Robert Barsch; the original
% version is available at The Matlab Central File Exchange, File ID 2255.
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=2255&objectType=file
%
% Modified by E. Rietsch: October 15, 2006
%
% v3d_getcolormap
%   Provides a list of all available standard colormaps, all user-defined
%   colormaps in folder "Color", and all user-defined colormap functions
%
%   Known user-specific formats
% 
%       Programm    | file extension | subfunction
%       ------------+----------------+-----------
%       Slicer      | .cmp           | importcmp
%       Pulse Ekko  | .tbl           | importtbl
%
% 
% v3d_getcolormap(filename) 
%   Farbpalettenwerte werden aus filename importiert und zurückgeben 
%
% v3d_getcolormap(function) 
%   Farbpalettenwerte werden generiert und zurückgeben 


%	User-defined colormaps
% Format: 'path/*.extension'
usrmap={'color/*.cmp';...
        'color/*.tbl';};

% Benutzerdefinierte Funktionen
% Format: 'name' 'function'
fctmap={'hotgray' 'hot.*gray';...
        'hotjet'  'hot.*jet';};

% Standard colormaps
% Format: 'Name' 'Funktion'
stdmap={'autumn' 'autumn';...
        'bone'   'bone';...
        'cool'   'cool';...
        'copper' 'copper';...
        'gray'   'gray';...
        'hot'    'hot';...
        'hsv'    'hsv';...
        'jet'    'jet';...
        'pink'   'pink';...
        'spring' 'spring';...
        'summer' 'summer';...
        'winter' 'winter';};

% Separator
% Format: 'Name' Funktion
delimiter={'---' 'jet'};


% Wenn Parameter vorhanden -> Dateiname oder Funktion wurde angegeben
if nargin==1
    % Testen ob Standartfarbpalette
    if any(strcmp(stdmap(:,1),varargin{1}))
        pos=strmatch(varargin{1},stdmap,'exact');
        varargout={stdmap{pos(1),2}};
    else
        % Testen ob Benutzerdefinierte Funktion
        if any(strcmp(fctmap(:,1),varargin{1}))
            pos=strmatch(varargin{1},fctmap,'exact');
            varargout={fctmap{pos(1),2}};
        else
            % Testen ob Trennlinie ausgewählt
            if any(strcmp(delimiter(1,1),varargin{1}))
                varargout=delimiter(1,2);
            else
                % Ansonsten Benutzerdefinierte Farbpalette importieren
                % Übergabe des Dateinamens filename und Rückgabe der Farbpalette
                varargout={num2str(v3d_importcolormap(varargin{1}))};
            end
        end
    end
else
    % Kein Parameter -> Auflisten aller verfügbaren Farbpaletten
    % Namen der Standardpaletten und Funktionen zusammenfügen
    cmaplist=[  stdmap(:,1);...
                delimiter(:,1);...
                fctmap(:,1);...
                delimiter(:,1);];

    % Dateinamen der Benutzerdefinierten Farbpaletten finden
    % und zur Farbpalettenliste hinzufügen
    for k=1:length(usrmap)
        path = fileparts(usrmap{k});
        files=dir(usrmap{k});
        for i=1:length(files)
            cmaplist(length(cmaplist)+1)={strcat(path,'/',files(i).name)};    
        end
    end
    
    % Rückgabe der Zeichenkettenliste aller verfügbaren Farbpaletten 
    varargout={cmaplist(:)};
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function cmap = v3d_importcolormap(filename)
% Farbpalette importieren
% --------------------------------------------------------------------
%   bekannte benutzerspezifische Formate:
% 
%       Programm    | Dateiendung   | Unterfunktion
%       ------------+---------------+--------------
%       Slicer      | .cmp          | importcmp
%       Pulse Ekko  | .tbl          | importtbl
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Test ob angegebene Datei vorhanden
fid = fopen(filename,'rt');
if fid ~= -1  &&  length(filename) >4 
    endung=filename(length(filename)-3:length(filename));
    switch (endung)
        case '.cmp'
            cmap=importcmp(filename);
        case '.tbl'
            cmap=importtbl(filename);
        otherwise
            error(['Fehler: Dateityp ' filename ' wird nicht unterstützt!']);
    end    
else
    error(['Fehler: Konnte Datei ' filename ' nicht öffnen!']);
end
fclose(fid);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function cmap = importcmp(filename)
% Slicer Farbpalette importieren
% --------------------------------------------------------------------
%
% Format of a .cmp file:
%
% 10 lines: comments 
% n  lines: Alpha R G B ; n  
%
% Color values range from 0 to 1

% Einlesen 
[r g b] = textread(filename,'%*f %f %f %f ; %*d','headerlines',10);

% möglicherweise Testen ob < 128 -> Performancegründe

% Rückgabe an Hauptfunktion
cmap=[r g b];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function cmap = importtbl(filename)
% Pulse Ekko Farbpalette importieren
% --------------------------------------------------------------------
%
% Format of a .tbl file:
%
% 1 line : Comment
% n lines: black cyan magenta tellow 
%
%   Color values range from 0 bis 255

%   Einlesen und Übergabe an Hauptfunktion
[c m y] = textread(filename,'%*f %f %f %f','headerlines',1);

%   Convert to RGB
r=((m(:)+y(:))/2)/255;
g=((c(:)+y(:))/2)/255;
b=((c(:)+m(:))/2)/255;

%   Return to calling function
cmap=[r(:),g(:),b(:)];
