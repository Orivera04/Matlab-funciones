% BLKPRICE   Blackのオプション価格決定
%
%   [C, P] = BLKPRICE(F, X, R, T, SIG)
%
% 詳細： 
% この関数は、与えられたフォワード価格、権利行使価格、安全利子率、満期
% までの期間、ボラティリティに基づいて、先物商品のコール及びプット
% オプションの価値をBlackのモデルを用いて決定します。
%
% 入力: 　
%   F   - ゼロ時における原資産のフォワード価格
%   X   - コール、プットオプションの権利行使価格の価値
%   R   - 安全利子率の価値(＋貯蔵経費 - 便宜収益)
%   T   - 満期、または、オプションの満了までの時間の価値
%   SIG - 原資産価格のボラティリティの価値
%
%   Outputs: C - コールオプションの価格
%            P - プットオプションの価格
%
% 注意： 
% R と T が同じ期間に基づいていることを確かめてください。すなわち、
% R が年率の場合、T は年表示でなければなりません。
%
% Blackモデルを拡張して、つぎのようにフォワード価格を導出することに
% より、金利デリバティブを債券に組み込まれたコール、プットオプション
% の型に変換することができます。
%
%       f = (B - I)* exp(R*t)
%
% ここで、
%                    
%         B - 債券の額面価値
%         I - オプションの全期間 (ゼロ時からオプションの満了まで)
%             のクーポンの現在価値 
%         R - 安全利子率 (＋貯蔵経費 - 便宜収益)
%         t - ゼロ時からオプションの満了までの時間
%
% 例題：
%       [c, p] = blkprice(95, 98, 0.11, 3, 0.025)
%
% この結果、つぎの値が出力されます。
%
%       c = 0.4162 (または、$0.42)
%       p = 2.5729 (または、$2.57)
%
% 参考 : BINPRICE, BLSPRICE.
%
% 参考文献 : 1) John C. Hull, Options, Futures, and Other Derivative 
%               Securities, 2nd edition.  Formulas 15.7 and 15.8.
%            2) F. Black, "The Pricing of Commodity Contracts," Journal 
%               of Financial Economics, March 3, 1976, pp. 167-79.


%   Author(s): C.F. Garvin and M. Reyes-Kattar, 12-26-95
%   Copyright 1995-2002 The MathWorks, Inc. 
