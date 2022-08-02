% BLSLAMBDA   Black-Scholesの弾性値
%
% [LC,LP] = BLSLAMBDA(SO,X,R,T,SIG,Q) は、オプションの弾性値を出力します。
% 弾性値(あるオプションのポジションのレバレッジ)は、基礎株価の1%の変化ごと
% のオプション価格の変化率の尺度です。SO は現行株価、X は権利行使価格、
% R は安全利子率 、T はオプションの満期までの年数、SIG は株式の年間連続
% 複利収益率の標準偏差(ボラティリティとも言います)、Q は配当率です。
% Q のデフォルトは0です。LC はコールオプションの弾性値すなわちレバレッジ
% 係数、LP はプットオプションの弾性値、すなわち、レバレッジ係数です。
%        
% 注意： 
% この関数は、Statistics Toolboxの正規累積分布関数 normcdf を使用します。
%  
% たとえば、[c,p] = blslambda(50,50,.12,.25,.3) は、c = 8.1274 と 
% p = -8.6466 を出力します。
%  
% 参考 : BLSPRICE, BLSDELTA, BLSGAMMA, BLSRHO, BLSTHETA, BLSVEGA.  
%  
% 参考文献： Advanced Options Trading, Daigler, Chapter 4  


%       Author(s): C.F. Garvin, 2-23-95  
%       Copyright 1995-2002 The MathWorks, Inc.   
