% BOLLING   Bollinger�o���h�`���[�g 
%
% BOLLING(ASSET,SAMPLES,ALPHA) �́AASSET�f�[�^���^����ꂽ���ɁABollinger
% �o���h�`���[�g���v���b�g���܂��BSAMPLES �́A�ړ����ς̌v�Z�Ɏg�p����
% �T���v�������w�肵�܂��BALPHA �́A�ړ����ς̗v�f���d�l���v�Z���邽�߂�
% �g�p����w���ł��B���̊֐��́A�o�̓f�[�^�������܂���B
%       
% [MAV,UBAND,LBAND] = BOLLING(ASSET,SAMPLES,ALPHA) �́AMAV �� ASSET 
% �f�[�^�̈ړ����ς��AUBAND �ɏ���̃o���h�̃f�[�^���ALBAND �ɉ�����
% �o���h�̃f�[�^���o�͂��܂��B���̏ꍇ�ɂ́A�ǂ̃f�[�^���v���b�g����
% �܂���B
% 
% BOLLING(ASSET,20,1) �́A���`��20���Ԉړ�����Bollinger�o���h���v���b�g
% ���܂��B
% 
% [MAV,UBAND,LBAND] = BOLLING(ASSET,20,1) �́A���`��20���Ԉړ�����
% Bollinger�o���h���v���b�g���邽�߂̃f�[�^���o�͂��܂����A���̏ꍇ�A
% ���̊֐����g�ł́A�f�[�^�̃v���b�g�͍s���܂���B
%
% ���͈����̃G���[�`�F�b�N���s���ĉ������B�d�݃x�N�g�����v�Z�A���[�v��
% �p���āA�ړ����σx�N�g�����v�Z���Ă��������B
% 
% �Q�l : MOVAVG, HIGHLOW, CANDLE, POINTFIG.


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
