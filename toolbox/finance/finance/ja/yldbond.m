% YLDBOND   債券の満期までの利回りを出力
%
% Yield = yldbond(Settle, Maturity, Face, Price, CouponRate, .....
%             Period, Basis, MaxIterations, EndMonthRule)
% 詳細：
% 標準の債券パラメータが入力として与えられると、この関数は、
% Newton-Ralphson 反復法を用いてクーポン債及びゼロクーポン債の双方に
% ついて満期までの利回りを計算します。
%
% 入力:
%    Settle (必須)  - 当該債券の決済日をシリアル日付番号で示す N 行1列、
%                     または、1行 N 列のベクトル
%    Maturity (必須)- 当該債券の満期日をシリアル日付番号で示す N 行1列、
%                     または、1行 N 列のベクトル
%    Face  (必須)   - 当該債券の額面価値を示す値の N 行1列、または、1行 
%                     N 列のベクトル
%    Price          - (必須)当該債券の価格を示す値の N 行1列、または、1
%                     行 N 列のベクトル
%    CouponRate     - (オプション)当該債券のクーポンレートを示す値の N 
%                     行1列、または、1行 N 列のベクトル。デフォルトは0で
%                     す。
%    Period         - (オプション)当該債券のクーポン支払いの頻度を示す値
%                     の N 行1列、または、1行 N 列のベクトル。取り得る値
%                     は、つぎの通りです。
%              Period =  0 - ゼロクーポン債
%              Period =  1 - 年払いクーポン
%              Period =  2 - 半年払いクーポン (デフォルト)
%              Period =  3 - 年3回払いクーポン
%              Period =  4 - 年4回払いクーポン
%              Period =  6 - 隔月払いクーポン
%              Period = 12 - 月払いクーポン
%     Basis          - 当該債券に対して適用される日数カウント基準を示す 
%                      N 行1列、または、1行 N 列のベクトル取り得る値は、
%                      つぎの通りです。
%              1)Basis = 0 - actual/actual(デフォルト)
%              2)Basis = 1 - 30/360
%              3)Basis = 2 - actual/360
%              4)Basis = 3 - actual/365
%     MaxIterations  - 当該債券の満期までの利回りを導出する際に、Newton 
%                      法で使用する反復回数を示すスカラ値です。デフォル
%                      トは5です(注意：デフォルト値を使用したいが、月末
%                      規則のフラグをこの関数に受け渡す操作も行いたいと
%                      いうケースでは、引数 MaxIteration の入力を空行列
%                      を入力することによって省略できます)。
%     EndMonthRule   - 当該債券について月末規則を適用するかしないかを指
%                      定する N 行1列、または、1行 N 列のベクトル、また
%                      は、スカラ値。取り得る値は、つぎの通りです。
%               1)EndMonthRule = 1(デフォルト)債券に対する月末規則は有効
%                                です(すなわち、月の末日にクーポン利払い
%                                を行う債券は、常に月の末日に支払いを
%                                行います)。
%               2)EndMonthRule = 0 
%                           月末規則は債券に対して無効となっています。
% 例題: 
%       Settle = '01-Jan-1960';
%       Maturity = '01-Jan-1990';
%       Face = 1000;
%       Price = 1276.76;
%       CouponRate = 0.08;
%       Period = 2;
%       Basis = 0;
%       EndMonthRule = 1;
%       Yield = yldbond(Settle, Maturity, Face, Price, ...
%                   CouponRate, Period, Basis)
%       
% この結果、つぎの値が出力されます。
%
%       Yield = 0.0599
%
% 参考 : PRBOND, YLDDISC, YLDMAT.


%	Author: C. Garvin, J. Akao, and C. Bassignani, 11/25/97 
%   Copyright 1995-2002 The MathWorks, Inc. 
