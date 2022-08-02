%111111111111111111111111111111111111111111111111111111111111111111111112
% SND_INI initialized soundcard (sets all levels to zero
% and mutes unused channels)
% No arguments required. No return value.
% Supported soundcards: ,Gina' by Echo, 'Pinnacle' by Turtle Beach and
% 'Crystal Mixer-MMX® Technology'.
% Get the control IDs and ranges by using SND_MIXER_INFO.DLL.
% SND_INI is part of the AUDIO toolbox (by Torsten Marquardt)

function snd_ini

name = snd_mixer_info(0);
if (strcmp(name ,'Gina Mixer'))
    snd_control(0,[0,0]);
    snd_control(1,[0,0]);
    snd_control(2,[0,0]);
    snd_control(5,[0,0]);
    snd_control(6,[0,0]);
    snd_control(7,[0,0]);
    snd_control(10,[0,0]);
    snd_control(11,[0,0]);
    snd_control(12,[0,0]);
    snd_control(15,[0,0]);
    snd_control(16,[0,0]);
    snd_control(17,[0,0]);
    snd_control(22,[0,0]);
    snd_control(23,[0,0]);
    snd_control(24,[0,0]);
    for(n=29:58)
        snd_control(n,[0,0]);
    end
    for(n=30:3:58)
        snd_control(n,[1,1]);
    end
    
elseif (strcmp(name ,'Pinnacle'))
    snd_control(5,[0,0]);
    snd_control(12,0);
    snd_control(8,1);
    snd_control(2,[65535,65535]);
    snd_control(9,0);
    snd_control(10,1);
    snd_control(11,1);
    snd_control(29,1);
    snd_control(0,1);
    snd_control(0,1);
    snd_control(0,1);
    snd_control(6,[65535,65535]);
    snd_control(17,-115);
    
elseif (strcmp(name ,'Crystal Mixer-MMX® Technology'))
    snd_control(2048,[65535,65535]);
    snd_control(2049,0);
    snd_control(2086,1);
    snd_control(2054,[65535,65535]);
    snd_control(2057,0);
    snd_control(2059,[0,0]);
    snd_control(2061,1);
    snd_control(2063,[0,0]);
    snd_control(2064,1);
    snd_control(2067,[0,0]);
    snd_control(2068,1);
    snd_control(2072,[0,0]);
    snd_control(2073,1);
    snd_control(2076,1);
    snd_control(2077,0);
    snd_control(2078,[0,0]);
    snd_control(2079,1);
    snd_control(2083,[0,0]);
    snd_control(2084,1);
    snd_control(2050,[65535,65535]);
    snd_control(2056,1);
    snd_control(2058,[0,0]);
    snd_control(2060,1);
    snd_control(2062,[0,0]);
    snd_control(2065,1);
    snd_control(2066,[0,0]);
    snd_control(2071,[0,0]);
    snd_control(2074,1);
    snd_control(2082,[0,0]);
    snd_control(2084,1);
    snd_control(2052,[0,0]);
    snd_control(2053,1);
          
else
    msgbox(strvcat('ERROR snd_ini.m:',...
        'Type of soundcard not supported or no soundcard installed!')),
end
