function varargout=aeroimage(varargin)
%AEROIMAGE function for the icon images of Aerospace Blockset.
%

%   Copyright 1990-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/06 01:03:54 $

if nargin==0
    error('aeroblks:aeroimage:invalidusage',...
        'AEROIMAGE is a function for Aerospace Blockset to render block images.');
end
action = varargin{1};
p={};

blk = gcb;
pos = get_param(blk,'Position');
lenx = pos(3)-pos(1);
leny = pos(4)-pos(2);

orient = get_param(blk,'Orientation');

if (lenx < leny)
    sfy = lenx/leny;
    sfx = 1.0;
elseif ( leny < lenx)
    sfx = leny/lenx;
    sfy = 1.0;
else
    sfx = 1.0;
    sfy = 1.0;
end
switch action
    % Icons for aerolib blocks:
    case 'anim'
        persistent anim_xp anim_yp
        
         if isempty(anim_xp)
            % create camera patch
            anim_xp = [0.42 0.42 0.40 0.40 0.42 0.42 0.46 0.42 0.44 0.49 0.51 ...
                    0.56 0.58 0.54 0.58 0.58  0.62 0.62 0.58  0.58 0.55 0.5854 ...
                    0.6 0.5854 0.55 0.5146 0.5 0.5146 0.55 0.55 0.54 0.55 0.56 ...
                    0.57  0.56  0.57  0.58  0.57  0.56 0.55 0.55 0.45 0.4854 0.5 ...
                    0.4854 0.45 0.4146 0.4 0.4146  0.45 0.45 0.44 0.45 0.46 ...
                    0.47  0.46  0.47  0.48  0.47  0.46 0.45 0.45 0.42]*1.5;
            anim_yp = [0.55 0.53 0.53 0.5  0.5  0.45 0.45 0.37 0.37 0.45 0.45 ...
                    0.37 0.37 0.45 0.45 0.495 0.45 0.55 0.505 0.55 0.55 0.5646 ...
                    0.6 0.6354 0.65 0.6354 0.6 0.5646 0.55 0.56 0.57 0.58 0.57 ...
                    0.575 0.585 0.595 0.585 0.575 0.57 0.56 0.55 0.55 0.5646 0.6 ...
                    0.6354 0.65 0.6354 0.6 0.5646  0.55 0.56 0.57 0.58 0.57 ...
                    0.575 0.585 0.595 0.585 0.575 0.57 0.56 0.55 0.55]*1.5;
        end 
        
        xp = sfx*(anim_xp-0.75)+0.5;
        yp = sfy*(anim_yp-0.75)+0.5;
        
        if (lenx < 75) || (leny < 80)
            xp = NaN;
            yp = NaN;
        end            
        
        p = {xp; yp};
        
    case 'atmosphere'
        persistent atmos_x atmos_y
        
        if isempty(atmos_x)
            % create clouds for atmosphere blocks
            atmos_x = [0.30   0.50   0.50   0.48   0.48   0.46   0.46   0.45 ...
                    0.45   0.43   0.43   0.40   0.40   0.39   0.39   0.37   ...
                    0.37   0.35   0.35   0.33   0.33   0.30   0.30   NaN    ...
                    0.55   0.65   0.65   0.64   0.64   0.63   0.63   0.625  ...
                    0.625  0.615  0.615  0.60   0.60   0.595  0.595  0.585  ...
                    0.585  0.575  0.575  0.565  0.565  0.55   0.55   NaN    ...
                    0.745  0.595  0.595  0.61   0.61   0.625  0.625  0.6325 ...    
                    0.6325 0.6475 0.6475 0.67   0.67   0.6775 0.6775 0.6925 ...
                    0.6925 0.7075 0.7075 0.7225 0.7225 0.745  0.745  NaN    ...
                    0.75   0.57   NaN    0.56   0.55   NaN    0.54   0.45   ...
                    NaN    0.39   0.25   NaN    0.25   0.35   NaN    0.48   ...
                    0.65   NaN    0.66   0.67   NaN    0.68   0.75   NaN    ...
                    0.75   0.6775 NaN    0.6325 0.50   NaN    0.30   0.25   ...
                    NaN    0.25   0.26   NaN    0.27   0.28   NaN    0.29 ...
                    0.61   NaN    0.46   0.48   NaN    0.49   0.5    NaN   ...
                    0.51   0.54   NaN    0.55   0.65];
            atmos_y = [0.45   0.45   0.47   0.47   0.50   0.50   0.52   0.52   ...
                    0.54   0.54   0.55   0.55   0.53   0.53   0.52   0.52   ...
                    0.51   0.51   0.48   0.48   0.47   0.47   0.45   NaN    ...
                    0.545  0.545  0.555  0.555  0.57   0.57   0.58   0.58   ...
                    0.59   0.59   0.595  0.595  0.585  0.585  0.58   0.58   ...
                    0.575  0.575  0.56   0.56   0.555  0.555  0.545  NaN    ...
                    0.4025 0.4025 0.4175 0.4175 0.44   0.44   0.455  0.4550 ...   
                    0.47   0.47   0.4775 0.4775 0.4625 0.4625 0.4550 0.4550 ...
                    0.4475 0.4475 0.425  0.425  0.4175 0.4175 0.4025 NaN    ...
                    0.525  0.525  NaN    0.525  0.525  NaN    0.525  0.525  ...
                    NaN    0.525  0.525  NaN    0.5    0.5    NaN    0.5    ...
                    0.5    NaN    0.5    0.5    NaN    0.5    0.5    NaN    ...
                    0.46   0.46   NaN    0.46   0.46   NaN    0.46   0.46   ...
                    NaN    0.42   0.42   NaN    0.42   0.42   NaN    0.42 ...
                    0.42   NaN    0.37   0.37   NaN    0.37   0.37   NaN  ...
                    0.37   0.37   NaN    0.37   0.37];
        end
        
        x = sfx*(atmos_x-0.5)+0.5;
        y = sfy*(atmos_y-0.5)+0.5;
        
        miny=min(y);
        
        if strcmp('Atmosphere Model',get_param(blk,'MaskType')) % COESA & NS Day
            spec = get_param(blk,'spec');
            if strcmp(spec,'1976 COESA-extended U.S. Standard Atmosphere')
                txt = 'COESA';
            elseif strcmp(spec,'MIL-HDBK-310')
                txt = 'NS 310';
            else
                txt = 'NS 210C';
            end
        else % ISA and Lapse Rate
            spec = get_param(blk,'custom');
            if strcmp(spec,'off')
                txt = 'ISA';
            else
                txt = 'Lapse Rate';
            end
        end
        
        if (strcmp(orient,'up')||strcmp(orient,'down'))
            if (lenx < 60) || (leny < 130)
                x = NaN;
                y = NaN;
                txt = '';
            end            
        elseif (strcmp(orient,'left')||strcmp(orient,'right'))
            if (lenx < 110) || (leny < 50)
                x = NaN;
                y = NaN;
                txt = '';
            end
        end
        
        p = {x; y; miny; txt};

    case 'cg'
        persistent cg_x cg_y cg_xp cg_yp
        
        if isempty(cg_xp)
            % create white patches
            cg_x = [0.5 0.7 0.6932 0.6732 0.6414 0.6    0.5518 0.5 0.5 0.5 ...
                    0.4482 0.4    0.3586 0.3268 0.3068 0.3]*.9;
            cg_y = [0.5 0.5 0.5518 0.6    0.6414 0.6732 0.6932 0.7 0.5 0.3 ...
                    0.3068 0.3268 0.3586 0.4    0.4482 0.5]*.9;
            % create black circle patch            
            cg_xp = [0.5 0.4482 0.4    0.3586 0.3268 0.3068 0.3 0.3068 0.3268 ...
                    0.3586 0.4    0.4482 0.5 0.5518 0.6    ...
                    0.6414 0.6732 0.6932 0.7 0.6932 0.6732 0.6414 0.6    ...
                    0.5518 0.5];
            cg_yp = [0.3 0.3068 0.3268 0.3586 0.4    0.4482 0.5 0.5518 0.6    ...
                    0.6414 0.6732 0.6932 0.7 0.6932 0.6732 ...
                    0.6414 0.6    0.5518 0.5 0.4482 0.4    0.3586 0.3268 ...
                    0.3068 0.3];
        end
        
        x = sfx*(cg_x-0.45)+0.5;
        y = sfy*(cg_y-0.45)+0.5;
        xp = sfx*(cg_xp-0.5)+0.5;
        yp = sfy*(cg_yp-0.5)+0.5;

        if (lenx < 70) || (leny < 35)
            x  = NaN;
            y  = NaN;
            xp = NaN;
            yp = NaN;
        end
        
        p = {x; y; xp; yp};
    
    case 'dynpres'
        persistent Qstr
        
        if isempty(Qstr)
            Qstr = '^1/_2 \rhoV^2';
        end
        
        if (lenx < 60) || (leny < 40)
            str = '';
        else 
            str = Qstr;
        end

        p = {str};

    case 'inertia'
        persistent inertia_xp2 inertia_yp2 inertia_xp inertia_yp 
        
        if isempty(inertia_xp)
            % create vector arrow
            inertia_xp2 = [0.35 0.65 0.55 0.57 0.35 0.35];
            inertia_yp2 = [0.7  0.7  0.85 0.75 0.75 0.7];
            % create letter I            
            inertia_xp = [0.35 0.65 0.65 0.55 0.55 0.65 0.65 0.35 0.35 0.45 ...
                    0.45 0.35 0.35];
            inertia_yp = [0.3  0.3  0.35 0.35 0.6  0.6  0.65 0.65 0.6  0.6  ...
                    0.35 0.35 0.3];
        end
        xp2 = sfx*(inertia_xp2-0.5)+0.5;
        yp2 = sfy*(inertia_yp2-0.5)+0.5;
        xp = sfx*(inertia_xp-0.5)+0.5;
        yp = sfy*(inertia_yp-0.5)+0.5;

        if (lenx < 80) || (leny < 45)
            xp2  = NaN;
            yp2  = NaN;
            xp = NaN;
            yp = NaN;
        end
        
        p = {xp; yp; xp2; yp2};

    case 'mach'
        persistent mach_x mach_y mach_V mach_a
        
        if isempty(mach_x)
            mach_x = [.45 .55];
            mach_y = [0.5 0.5];
            mach_V = 'V';
            mach_a = 'a';
        end

        x = sfx*(mach_x-0.5)+0.5;
        y = sfy*(mach_y-0.5)+0.5;
        strV = mach_V;
        stra = mach_a;
        
        if (strcmp(orient,'left')||strcmp(orient,'right'))
            if (lenx < 75) || (leny < 35)
                x = NaN;
                y = NaN;
                strV = '';
                stra = '';
            end
        else % down or up
            if (lenx < 25) || (leny < 105)
                x = NaN;
                y = NaN;
                strV = '';
                stra = '';
            end
        end
        p = {x;y;{strV};{stra}};
        
    case 'momcg'
        persistent momcg_xpw momcg_ypw momcg_xp momcg_yp momcg_x momcg_y

        if isempty(momcg_xp)
            % create white patches
            momcg_xpw = [0.5 0.7 0.6932 0.6732 0.6414 0.6    0.5518 0.5 0.5 ...
                    0.5 0.4482 0.4    0.3586 0.3268 0.3068 0.3]*.8;
            momcg_ypw = [0.5 0.5 0.5518 0.6    0.6414 0.6732 0.6932 0.7 0.5 ...
                    0.3 0.3068 0.3268 0.3586 0.4    0.4482 0.5]*.8;
            % create black circle patch            
            momcg_xp = [0.5 0.4482 0.4    0.3586 0.3268 0.3068 0.3 0.3068 ...
                    0.3268 0.3586 0.4    0.4482  0.5 0.5518 0.6    ...
                    0.6414 0.6732 0.6932 0.7 0.6932 0.6732 0.6414 0.6    ...
                    0.5518 0.5]*.9;
            momcg_yp = [0.3 0.3068 0.3268 0.3586 0.4    0.4482 0.5 0.5518 ...
                    0.6    0.6414 0.6732 0.6932  0.7 0.6932 0.6732 ...
                    0.6414 0.6    0.5518 0.5 0.4482 0.4    0.3586 0.3268 ...
                    0.3068 0.3]*.9;
            % create lines and arrow heads                        
            momcg_x = [0.32 0.2 0.2102 0.2402 0.2879 0.3500  0.2879 0.3500 0.3500 NaN ...
                    0.68 0.8 0.7879 0.7589 0.7121 0.6500 0.7121 0.6500 0.6500];
            momcg_y = [0.5  0.5 0.4224 0.3500 0.2879 0.2404  0.2404 0.2879 0.2404 NaN ...
                    0.5  0.5 0.5776 0.6500 0.7121 0.7589 0.7589 0.7121 0.7589];
        end
    
        xpw = sfx*(momcg_xpw-0.4)+0.5;
        ypw = sfy*(momcg_ypw-0.4)+0.5;
        xp = sfx*(momcg_xp-0.45)+0.5;
        yp = sfy*(momcg_yp-0.45)+0.5;
        x = sfx*(momcg_x-0.5)+0.5;
        y = sfy*(momcg_y-0.5)+0.5;

        if (lenx < 70) || (leny < 60)
            xpw  = NaN;
            ypw  = NaN;
            xp = NaN;
            yp = NaN;
            x = NaN;
            y = NaN;
        end
        
        p = {xpw; ypw; xp; yp; x; y};
        
    case 'sixdofbody'
        persistent sdofb_x sdofb_y sdofb_xp sdofb_yp
        
        if isempty(sdofb_xp)
            % create axis and rotation lines
            sdofb_x=[0.32 0.325 0.35 0.32 0.5 0.5 0.52 0.48 ...
                    0.5 NaN 0.5 0.75 0.725 0.725 0.75 NaN ...
                    0.475 0.46 0.475 0.475 0.46 0.475 ...
                    0.5 0.525 0.54 0.525 NaN ...
                    0.625 0.625 0.61 0.625 0.605 0.575 ...
                    0.57 0.575 0.6 0.625 NaN ...
                    0.36 0.375 0.4 0.425 0.44 ...
                    0.425 0.4 0.4 0.42 0.4];
            
            sdofb_y=[0.42 0.45 0.425 0.42 0.6 0.35 0.375 0.375 ...
                    0.35 NaN 0.6 0.6 0.58 0.62 0.6 NaN ...
                    0.475 0.475 0.46 0.475 0.45 0.425 ...
                    0.42 0.425 0.45 0.475 NaN ...
                    0.575 0.555 0.575 0.575 0.56 0.575 ...
                    0.6 0.625 0.64 0.625 NaN ...
                    0.51 0.485 0.48 0.485 0.51 ...
                    0.535 0.54 0.52 0.545 0.54];
            % create circle patch
            sdofb_xp = [0.525 0.518 0.5 0.483 0.475 0.483 0.5 0.518 0.525];
            sdofb_yp = [0.59 0.608 0.615 0.608 0.59 0.573 0.565 0.573 0.59];
        end
        
        x = sfx*(sdofb_x-0.5)+0.5;
        y = sfy*(sdofb_y-0.6)+0.62;
        xp = sfx*(sdofb_xp-0.5)+0.5;
        yp = sfy*(sdofb_yp-0.59)+0.61;
        
        miny=min(y);
        maxy=max(y);
        
        rep = get_param(blk,'rep');
        mtype = get_param(blk,'mtype');
        
        highstr = rep;
        lowstr = [mtype '\nMass'];
        
        if strcmp(orient,'down')
            if (leny < 250)
                x = NaN;
                y = NaN;
                xp =NaN;
                yp=NaN;
                highstr = [rep '\n' mtype '\nMass'];
                lowstr = ' ';
                maxy=0.4;
            end
            if (lenx < 130) || (leny < 140)
                x = NaN;
                y = NaN;
                xp =NaN;
                yp=NaN;
                lowstr = ' ';
                highstr = ' ';
            end    
        elseif strcmp(orient,'up')
            if (leny < 250)
                x = NaN;
                y = NaN;
                xp =NaN;
                yp=NaN;
                highstr = [rep '\n' mtype '\nMass'];
                lowstr = ' ';
                maxy=0.5;
            end
            if (lenx < 130) || (leny < 140)
                x = NaN;
                y = NaN;
                xp =NaN;
                yp=NaN;
                lowstr = ' ';
                highstr = ' ';
            end    
        elseif (strcmp(orient,'left')||strcmp(orient,'right'))
            if (lenx < 200)
                x = NaN;
                y = NaN;
                xp =NaN;
                yp=NaN;
                highstr = [rep '\n' mtype '\nMass'];
                lowstr = ' ';
                maxy=0.4;
            end
            if (lenx < 170) || (leny < 115)
                x = NaN;
                y = NaN;
                xp =NaN;
                yp=NaN;
                lowstr = ' ';
                highstr = ' ';
            end    
        end
        
        p = {x; y; xp; yp; {highstr}; {lowstr}; maxy; miny};
        
    case 'threedofbody'
        persistent tdofb_x tdofb_y tdofb_xp tdofb_yp
        
        if isempty(tdofb_xp)
            %create axis and rotation lines
            tdofb_x=[0.5 0.5 0.52 0.48 ...
                    0.5 NaN 0.5 0.75 0.725 0.725 0.75 NaN ...
                    0.455 0.46 0.5 0.535 0.54 ...
                    0.525 0.5 0.5 0.52 0.5];
            
            tdofb_y=[0.6 0.35 0.375 0.375 ...
                    0.35 NaN 0.6 0.6 0.58 0.62 0.6 NaN ...
                    0.61 0.57 0.55 0.57 0.61 ...
                    0.635 0.645 0.63 0.645 0.645];
            % create circle patch
            tdofb_xp = [0.525 0.518 0.5 0.483 0.475 0.483 0.5 0.518 0.525];
            tdofb_yp = [0.59 0.608 0.615 0.608 0.59 0.573 0.565 0.573 0.59];
        end
        
        x = sfx*(tdofb_x-0.5)+0.5;
        y = sfy*(tdofb_y-0.6)+0.57;
        xp = sfx*(tdofb_xp-0.5)+0.5;
        yp = sfy*(tdofb_yp-0.59)+0.57;
        
        miny=min(y);
        maxy=max(y);
        
        mtype = get_param(blk,'mtype');
        
        highstr = mtype;
        lowstr = 'Mass';
        
        if strcmp(orient,'down')
            if (leny < 190)
                x = NaN;
                y = NaN;
                xp =NaN;
                yp=NaN;
                highstr = [mtype '\nMass'];
                lowstr = ' ';
                maxy=0.4;
            end
            if (lenx < 85)||(leny < 140)
                x = NaN;
                y = NaN;
                xp =NaN;
                yp=NaN;
                lowstr = ' ';
                highstr = ' ';
            end
        elseif strcmp(orient,'up')
            if (leny < 215)
                x = NaN;
                y = NaN;
                xp =NaN;
                yp=NaN;
                highstr = [mtype '\nMass'];
                lowstr = ' ';
                maxy=0.5;
            end
            if (lenx < 85)||(leny < 140)
                x = NaN;
                y = NaN;
                xp =NaN;
                yp=NaN;
                lowstr = ' ';
                highstr = ' ';
            end
        elseif (strcmp(orient,'left')||strcmp(orient,'right'))
            if (leny < 90)
                x = NaN;
                y = NaN;
                xp =NaN;
                yp=NaN;
                highstr = [mtype '\nMass'];
                lowstr = ' ';
                maxy=0.5;
            end
            if (lenx < 170)
                x = NaN;
                y = NaN;
                xp =NaN;
                yp=NaN;
                lowstr = ' ';
                highstr = ' ';
            end
        end
        
        p = {x; y; xp; yp; {highstr}; {lowstr}; maxy; miny};
        
    case 'unitconv'
        persistent unit_xp unit_yp
        
        if isempty(unit_xp)
            % create arrow patch
            unit_xp = [0.3  0.65 0.65 0.75 0.65 0.65 0.3  0.3];
            unit_yp = [0.575 0.575 0.475 0.6 0.725 0.625 0.625 0.575];
        end
        
        xp = sfx*(unit_xp-0.5)+0.5;
        yp = sfy*(unit_yp-0.6)+0.5;
        
        if (strcmp(orient,'left')||strcmp(orient,'right'))
            if (lenx < 90)||(leny < 30)
                xp = NaN;
                yp = NaN;
            end
        elseif (strcmp(orient,'down')||strcmp(orient,'up'))
            if (leny < 150)||(lenx < 40)
                xp = NaN;
                yp = NaN;
            end
        end
        
        p = {xp; yp};
        
    case 'wind'
        persistent wind_x wind_y
        
        if isempty(wind_x)
            wind_x = [0.3  0.3  0.4   0.45 0.5 0.55 0.6  0.65 0.7  NaN ...
                    0.32 0.65 0.62 0.62 0.65 NaN ...
                    0.32 0.62 0.59 0.59 0.62 NaN ...
                    0.32 0.58 0.55 0.55 0.58 NaN ...
                    0.32 0.5  0.47 0.47 0.5  NaN ...
                    0.25 0.75];
            wind_y = [0.75 0.25 0.255 0.27 0.3 0.35 0.42 0.55 0.75 NaN ...
                    0.71 0.71 0.73 0.69 0.71 NaN ...
                    0.59 0.59 0.61 0.57 0.59 NaN ...
                    0.47 0.47 0.49 0.45 0.47 NaN ...
                    0.35 0.35 0.37 0.33 0.35 NaN ...
                    0.25 0.25];
        end
        
        x = sfx*(wind_x-0.5)+0.5;
        y = sfy*(wind_y-0.5)+0.6;

        miny=min(y);
        maxy=max(y);
        
        if nargin < 2
            error('aeroblks:aeroimage:invalidusagewind',...
                'Number of inputs is too few for a wind model.');
        elseif nargin == 3 % wind turbulence models
            lowstr = varargin{2};
            highstr = varargin{3};
            if (strcmp(orient,'left')||strcmp(orient,'right'))
                if (lenx < 160)||(leny < 60)
                    x = NaN;
                    y = NaN;
                    highstr = ' ';
                    lowstr = ' ';
                elseif (lenx < 175)||(leny < 70)
                    x = NaN;
                    y = NaN;
                    highstr = [highstr '\n' lowstr ];
                    lowstr = ' ';
                    maxy=0.4;
                end
            elseif strcmp(orient,'down')
                if (leny < 145)
                    x = NaN;
                    y = NaN;
                    highstr = ' ';
                    lowstr = ' ';
                elseif (leny < 185)||(lenx < 80)
                    x = NaN;
                    y = NaN;
                    highstr = [highstr '\n' lowstr ];
                    lowstr = ' ';
                    maxy=0.5;
                end
            else % strcmp(orient,'up')
                if (leny < 145)
                    x = NaN;
                    y = NaN;
                    highstr = ' ';
                    lowstr = ' ';
                elseif (leny < 230)||(lenx < 80)
                    x = NaN;h
                    y = NaN;
                    highstr = [highstr '\n' lowstr ];
                    lowstr = ' ';
                    maxy=0.4;
                end
            end            
        else
            lowstr = varargin{2};
            highstr = ' ';
            if (strcmp(orient,'left')||strcmp(orient,'right'))
                if lenx < 150
                    x = NaN;
                    y = NaN;
                    lowstr = ' ';
                elseif leny < 50
                    x = NaN;
                    y = NaN;
                    miny=0.5;
                end
            elseif strcmp(orient,'down')
                if (leny < 125)||(lenx < 65)
                    x = NaN;
                    y = NaN;
                    lowstr = ' ';
                elseif (leny < 170)
                    x = NaN;
                    y = NaN;
                    miny=0.6;
                end
            else % strcmp(orient,'up')
                if (leny < 125)||(lenx < 65)
                    x = NaN;
                    y = NaN;
                    lowstr = ' ';
                elseif (leny < 170)
                    x = NaN;
                    y = NaN;
                    miny=0.5;
                end
            end
        end

        p = {x; y; highstr; lowstr; maxy; miny};

    otherwise
        error('aeroblks:aeroimage:invalidblock',...
            'AEROIMAGE is a function for Aerospace Blockset to render block images');  
end

if ~isempty(p)
    for i=1:nargout,
        varargout(i)={p{i}};
    end
else
    % return dummy values
    for i=1:nargout,
        varargout(i)={0};
    end
end
