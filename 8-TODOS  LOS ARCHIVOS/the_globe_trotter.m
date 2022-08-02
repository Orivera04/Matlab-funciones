righthand = '2^^GA4B2B^E_4B2B^E_BAGABGAB^4C2CF#4C2CF#C_BAB^C_AB^C4D2DG4D#2D#G4E2EGF#EDC_B^D_GBA^C_F#A9G2GG#A^D_AAbGF#GG#A^E_AAbGF#GG#AA#B^G_BBbA^F_AAbG^F4E_2GG#A^F_AAbGF#GG#A^E_AAbGF#GG#A^F_AAbG^E_GGbF^D_AB^4C_2GA4B2B^E_4B2B^E_BAGABGAB^4C2CF#4C2CF#C_BAB^C_AB^C4D2DG4D#2D#G4E2EGF#EDC_B^D_GBA^C_F#A9G^2GB9A2F#A9G2_GB9A2F#A4G.G.G';
lefthand  = '^4.G^D_D^D_G^D_D^D_A^D_D^D_A^D_D^D_B^G_B^GCGG._G^D_D^C_GDG.DGB.CG^C_.DGB.CG^C_.DGB.CG^C_.8FGG4^C._G^D_D^D_G^D_D^D_A^D_D^D_A^D_D^D_B^G_B^GCGG._G^D_D^C_GDG.^F#DF#.GDG._F#DF#.G.G.G';

cb = [1:8,12];
cf = [1 1; 1.505 0.33; 1.495 0.33];
xr = playtune(righthand,cf,cb);
xl = playtune(lefthand,[],cb);
u  = min(length(xr),length(xl));
soundsc(xr(1:u)+xl(1:u),2^13);
