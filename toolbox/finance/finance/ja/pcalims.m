% PCALIMS   �X�̎��Y�̍ŏ��z���ʁA�ő�z���ʂɑ΂���ꎟ�s����
%
% ���̊֐��́ANASSETS�̎g�p�\�Ȏ��Y�����̂��ꂼ��ɂ�����|�[�g�t�H
% ���I�z���̉����A������w�肵�܂��B
%
%    [A,b] = pcalims(AssetMin, AssetMax, NumAssets) 
% 
% ����:
% AssetMin, AssetMax : �e���Y�ɂ�����ŏ��z���ʁA�ő�z���ʂ̃X�J���l�A
%                      �܂��́ANASSETS �̒��������x�N�g���ł��BNaN ��
%                      ���͂����ƁA���̕����ւ̎��Y�z���ɂ́A���琧��
%                      ���ۂ����Ă��Ȃ��Ɖ��߂���܂��B�X�J���ɂ���
%                      �͂̐ݒ�͑S�Ă̎��Y�ɓK�p����܂��B
% NumAssets          : (�I�v�V����)���Y�̐� NASSETS �ł��B���Y�̐����w��
%                      ���Ȃ��ꍇ�ANumAssets �́AAssetMin�A�܂��́A
%                      AssetMax �̒����ƂȂ�܂��B 
%
% �o��:
% A*Pwts' <= b �Ƃ�������֌W����������s�� A �y�уx�N�g�� b ���o�͂���
% ���B�����ŁAPwts �́A���Y�z����1�sNASSETS��̃x�N�g���ł��B
%
% �ʂȎg�p�@�F2�ȉ��̏o�͈����𔺂��`�ŁA���̊֐����R�[�������ꍇ�AA 
% �y�� b �́A�݂��ɘA������邱�ƂɂȂ�܂��B
% 
%    Cons = [A, b]; Cons = pcalims(AssetMin, AssetMax, NumAssets)
% 
% �Q�l : PORTOPT, PCPVAL, PCGLIMS, PCGCOMP, PORTCONS.


%   Author(s): J. Akao, M. Reyes-Kattar, 03/11/98
%   Copyright 1995-2002 The MathWorks, Inc. 
