function contact3
%CONTACT3 How to reach international distributors for The MathWorks, Inc.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

str1= ... 
[' BAUSCH-GALL GmbH                  '  
 ' Federal Republic of Germany       '  
 ' Phone: +49-89-99-59-01-0          '  
 ' Fax: +49-89-99-59-01-11           '];

str2= ... 
[' Cambridge Control Limited         '  
 ' Cambridge, United Kingdom         '  
 ' Phone: +44-223-421-920            '  
 ' Fax: +44-223-421-921              '];

str3= ...       
[' CEANET Pty., Ltd.            '  
 ' North Sydney, Australia      '  
 ' Phone: +61-2-922-6311        '  
 ' Fax: +61-2-922-5118          '];  

str4= ...
[' Computer Solutions Europe AB'  
 ' Stockholm, Sweden           '  
 ' Phone: +46-8-15-30-22       '  
 ' Fax: +46-8-15-76-35         '];

str5= ...
[' COMSOL AG                      '  
 ' Bern, Switzerland              '  
 ' Phone: +41-31-998-44-11        '  
 ' Fax: +41-31-998-44-18          '];

str6= ...
[' Cranes Software International'  
 ' Bangalore India              '  
 ' Phone: +91-80-260-260        '  
 ' Fax: +91-80-216-165          '];

str7= ...
[' Cybernet Systems Co., Ltd.          '  
 ' Tokyo, Japan                        '  
 ' Phone: +81-3-3982-4641              '  
 ' Fax: +81-3-3980-7490                '];

str8= ...
[' Green Hills Technology, Inc.     '  
 ' Taipei, Taiwan, Republic of China'  
 ' Phone: +886-2-501-8787           '  
 ' Fax: +886-2-502-4478             '];

str9= ...
[' Kimhua Technologies, Inc.            '  
 ' Seoul, Korea                         '  
 ' Phone: +82-2-517-1257                '  
 ' Fax: +82-2-517-1259                  '];

str10= ...
[' Omikron Delta (1927) Ltd.   '  
 ' Tel-Aviv, Israel            '  
 ' Phone: +972-3-561-5151      '  
 ' Fax: +972-3-561-2962        '];  

str11= ...
[' OpenCADD Computacao Grafica         '  
 ' Sao Paulo, Brasil                   '  
 ' Phone: +55-11-816-3144              '  
 ' Fax: +55-11-816-7864                '];

str12= ...
[' Rapid Data Ltd.                    '  
 ' West Sussex, United Kingdom        '  
 ' Phone: +44-903-821-266             '  
 ' Fax: +44-903-820-762               '];  

str13= ...
[' Scientific Software Group'  
 ' Sevres, France           '  
 ' Phone: +33-1-45-34-23-91 '  
 ' Fax: +33-1-45-07-08-06   '];

str14= ...
[' Teoresi s.r.l.         '  
 ' Turin, Italy           '  
 ' Phone: +39-11-24-85-332'  
 ' Fax: +39-11-24-84-698  '];

str15= ...
[' AddLink Software Cientifico'
 ' Barcelona, Spain           '
 ' Phone: +34-3-415-49-04     '
 ' Fax: +34-3-415-72-68       '];

infoStr= ...    
    [' Use this information to reach the most convenient       '  
     ' international distributor for you. Also be sure to look '
     ' at the Distributors World Map, also in this area.       ' ];

txtStr1=str2mat(' ',infoStr,' ',str15,' ',str1,' ',str2);
txtStr2=str2mat(' ',str3,' ',str4,' ',str5,' ',str6);
txtStr3=str2mat(' ',str7,' ',str8,' ',str9,' ',str10);
txtStr4=str2mat(' ',str11,' ',str12,' ',str13,' ',str14);

ttlStr='International Distributors for The MathWorks';
xppage(ttlStr,txtStr1,txtStr2,txtStr3,txtStr4);
