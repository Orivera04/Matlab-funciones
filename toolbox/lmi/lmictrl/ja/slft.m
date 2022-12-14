% sys=slft(sys1,sys2,udim,ydim)
%
% 2つのシステムSYS1とSYS2の線形分数相互接続を構成します。
%
%		       _________
%          w1 -------->|       |-------> z1
%		       |  SYS1 |
%            +-------->|_______|-------+
%            |	 	               |
%         u  |                         | y
%            |         _________       |
%            +---------|       |<------+
%		       |  SYS2 |
%         z2 <---------|_______|-------- w2
%
% 結果のシステムSYSは、(w1,w2)を(z1,z2)に写像します。
%
% UDIMとYDIMは、ベクトルuとyの長さです。省略したときは、デフォルト値に設
% 定されます。
% 
%  * SYS1の入力/出力がSYS2よりも多い場合
%        UDIM = SYS2の出力数
%        YDIM = SYS2の入力数
%  * SYS2の入力/出力がSYS1よりも多い場合
%        UDIM = SYS1の入力数
%        YDIM = SYS1の出力数
%
% 参考：    SLOOP, SCONNECT, LTISYS.



% Copyright 1995-2002 The MathWorks, Inc. 
