% YLDTBILL   財務省証券の利回りを出力
%
% Y = YLDTBILL(SD,MD,RV,PRICE)は、財務省証券の利回りを出力します。 SD は
% 決済日、MD は満期日、RV は額面価格、PRICE は財務省証券の価格です。決済
% 日と満期日は、シリアル日付番号、または、日付文字列で入力します。
% 
% 例題：
% ある財務省証券の決済日が1992年2月10日、満期日が1992年8月6日、償還価額
% が$1,000、価格が$981.36とします。このデータを使用すると、
% 
% y = yldtbill('2/10/1992', '8/6/1992', 1000, 981.36) は、
% y = 0.0384、すなわち、3.84%を出力します。
% 
% 参考 : BEYTBILL, PRTBILL.
%
% 参考文献: Bodie, Kane, and Marcus, Investments, pages 41-43. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
