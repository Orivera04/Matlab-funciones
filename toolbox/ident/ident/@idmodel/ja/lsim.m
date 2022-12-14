% LSIM  は、与えられたダイナミックシステムをシミュレーションします。
% 
%   Y = LSIM(MODEL,UE)
%
%  MODEL: IDMODEL フォーマット、IDSS, IDPOLY, IDARX, GREYBOX のいずれか
%         で記述されたモデルのパラメータを含みます。
%
%    UE : 入力 - 出力データ、UE = [U E]。ここで、U は、(入力として定義さ
%         れている信号を含む)IDDATA オブジェクトとして与えられるものか、
%         または、k 番目の入力が列ベクトル Uk の中に含まれている行列 U =
%         [U1 U2 ..Un] とする入力データです。同様に、E もノイズ入力の 
%         IDDATA オブジェクトか、または、(出力チャンネル数と同じ列数の)
%         行列のどちらかです。E を省略すると、ノイズのないシミュレーショ
%         ンが得られます。ノイズの影響は、MODEL の中に含まれる分散情報で
%         スケーリングされています。
%
%      Y：シミュレーション出力。U が IDDATA オブジェクトの場合、Y も 
%         IDDATA オブジェクトとして出力されますが、それ以外の場合、k 番
%         目の出力チャンネルが k 列に対応する行列となります。
%
% UE が複数の実験の IDDATA オブジェクトの場合、Y の IDDATA オブジェクト
% になります。
%
% MODEL が連続時間である場合、まず、入力 U の中の情報('Ts' と 'InterSa-
% mple' プロパティ)に従ってサンプリングされ、その後、IDDATA オブジェクト
% にします。
%
% [Y,YSD] = LSIM(MODEL,UE) を使って、シミュレーション出力の推定される標
% 準偏差 YSD も計算されます。YSD は、Y と同じ書式をしています。
%
% Y = LSIM(MODEL,UE,INIT) は、つぎの初期状態のいずれかにアクセスします。
%       INIT = 'm' (デフォルト) は、モデルの初期状態を使用します。
%       INIT = 'z' は、ゼロ初期条件を使用します。
%       INIT = X0 (列ベクトル)。初期状態として、X0 を使用します。
%
% シミュレーションやモデル作成の詳細は、IDINPUT, IDMODEL を参照してくだ
% さい。
% モデルの評価は、COMPARE と PREDICT を参照してください。

% $Revision: 1.2 $ $Date: 2001/03/01 22:55:02 $
%   Copyright 1986-2001 The MathWorks, Inc.
