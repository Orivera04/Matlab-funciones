% [MU,LOGD] = SSV(A,B,C,D,W)
% SSV(A,B,C,D,W,K) 、または、
% (A,B,C,D,W,K,OPTION)
% [MU,LOGD] = SSV(SS_,...)
% ssvは、実ベクトルw内の各々の周波数での
%        G(jw) = C * inv(jwI-A) * B + D
% の構造化特異値(ssv)の上界を含む行ベクトルMUを作成します。
% 入力:
%     A,B,C,D  -- p行q列の伝達関数行列G(s)の状態空間行列
%     W        -- MUが作成される周波数のベクトル
% オプション入力:
%     K  -- 不確かさのブロックサイズ -- デフォルトは、K=ones(q,2)です。
%           Kは、n行1列またはn行2列行列で、その行はssvが評価される
%           不確かさのブロックサイズです。K は、sum(K) == [q,p]を
%           満足しなければなりません。i番目の不確かさが実数の場合、
%           K(i,:) = [-1 -1]と設定します。Kの1番目の列のみが与えられた場合、
%           不確かさブロックはK(:,2)=K(:,1)のように正方になります。
%
%     OPTION  -- MUの計算法で、'psv'(最適対角スケーリングされたPerron、
%                デフォルト)、'osborne', 'perron', 'muopt'(実数のみ、
%                複素数のみ、混在した不確かさに対する乗数アプローチ)
%                のうちのいずれかです。
% 出力:
%     MU      -- MUのbodeプロット
%     LOGD    -- 最適対角スケーリングされたD (値は、exp(LOGD)です)



% Copyright 1988-2002 The MathWorks, Inc. 
