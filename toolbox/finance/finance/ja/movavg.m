% MOVAVG   ���[�h/���O�ړ����σ`���[�g
%
% [SHORT,LONG] = MOVAVG(ASSET,LEAD,LAG,ALPHA) �́A���[�h�^���O�ړ�����
% �`���[�g���v���b�g���܂��BASSET �͗L���،��̃f�[�^�ALEAD �̓��[�h���ς�
% �v�Z�Ɏg�p����T���v�����ALAG �̓��O���ς̌v�Z�Ɏg�p����T���v�����ł��B
% ALPHA �͈ړ����ς̎�ނ����肷�鐧��p�����[�^�ł��B
% 
%       ALPHA = 0 (�f�t�H���g)�́A�P���Ȉړ����ς��v�Z���܂��B
%       ALPHA = 0.5 �́A���������d�ړ����ρAALPHA =1�́A���`�ړ����ρA
%  �@   ALPHA = 2 �́A�����d�ړ����ϓ��X���v�Z���܂��B�w���ړ����ς��v
%               �Z���邽�߂ɂ́AALPHA = 'e'�Ƃ��܂��B 
% 
% MOVAVG(ASSET,3,20,1) �́A���`��3�T���v���̃��[�h�ړ����ς�20�T���v����
% ���O�ړ����ς��v���b�g���܂��B 
% 
% [SHORT,LONG] = MOVAVG(ASSET,3,20,1) �́A���[�h�ړ����σf�[�^�ƃ��O�ړ�
% ���σf�[�^���o�͂��܂����A�v���b�g�͍s���܂���B
% 
% �Q�l : BOLLING, HIGHLOW, CANDLE, POINTFIG.


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
