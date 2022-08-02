righthand = '^^4.1G#AG#GG#^C#ED#C#D#C#_B#^C#EG#._G#AG#GG#^C#ED#C#D#C#_B#^C#EG#._A^C#D#F#A^C#D#BAG#F#ED#F#C#_B#^D#_AG#F#AED#F#C#_B#^D#_AG#B2A1G#AG#GG#^C#ED#C#D#C#_B#^C#EG#._G#A#G#GG#^C#ED#C#D#C#_B#^C#EG#D#ED#DD#BA#G#G^ED#C#_BA#G#GA#G#BDED#G#_A#^C#_B^D#_GA#G#GG#';
lefthand  = '^^3C#G#^C#EC#_G#C#G#^C#EC#_G#C#G#^C#EC#_G#C#G#^C#EC#_G#C#G#^C#EC#_G#EG#^C#EC#_G#C#G#^C#EC#_G#EG#^C#EC#_G#D#A^C#F#C#_AF#^C#D#AD#C#__G#^D#F#B#F#D#_G#^D#F#B#F#D#C#G#^C#EC#_G#EG#^C#EC#_G#C#G#A#^E_A#G#EG#A#^C#_A#G#D#G#B^D#_BG#D#A#^C#GC#_A#_G#^D#G#BG#D#_G^D#G#BG#D#';

cb  = [1,2,4/3,32];
cfr = [1 1; 1.505 0.33; 1.495 0.33; 2.5025 0.33; 2.4975 0.33];
cfl = [1 1; 0.99 0.33; 1.01 0.33];
xr  = playtune(righthand,cfr,cb);
xl  = playtune(lefthand,cfl,cb);
u   = min(length(xr),length(xl));
soundsc(xr(1:u)+xl(1:u),2^13);
