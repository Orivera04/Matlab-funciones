% PCGLIMS   ���Y�W���̍ŏ��z���ʁA�ő�z���ʂɑ΂���ꎟ�s�������o��
%
% ���Y�W���ɑ΂���ŏ��z���ʁA�ő�z���ʂ��w�肵�܂��BNASSETS �̐�����
% ���݂��铊���̕����W������Ȃ�C�ӂ̐� NGROUPS ���݂���W���̃y�A��
% ���ď���A������ݒ肷�邱�Ƃ��ł��܂��B
% 
% [A,b] = pcglims(Groups, GroupMin, GroupMax)
%
% ����:
%    Groups : �e�W���ɂǂ̎��Y�������Ă���̂����w�肷��NGROUPS�sNASSETS
%             ��̍s��ł��B�e��̒l�́A����W���ɂǂ̎��Y�����蓖�Ă��
%             �Ă��邩���w�肵�Ă��܂��BGroup(i,j) = 1�̏W���A�W�� i ��
%             ���Y j ���܂�ł��܂��B���̏ꍇ�AGroup(i,j) = 0 �ƂȂ�܂��B
%    GroupMin, GroupMax : �e�W���ւ̍ŏ��y�эő匋���z���ʂ������X�J���l
%             �܂��́ANGROUPS �̒����̃x�N�g���ł��BNaN �����͂����ƁA
%             ���Y���Y�ɑ΂��ĉ��琧�񂪉ۂ����Ȃ����Ƃ��Ӗ����܂��B
%             �X�J���Őݒ肵���͈͂́A�S�Ă̏W���ɑ΂��ēK�p����܂��B
%
% �o��:
% A*Pwts' <= b �Ƃ�������֌W����������s�� A �y�уx�N�g�� b ���o�͂���
% ���B�����ŁAPwts �́A���Y�z����1 �s NASSETS ��̃x�N�g���ł��B
%
% �ʂ̎g�p�@�F
% 2�ȉ��̏o�͈����𔺂��`�ł��̊֐����R�[�������ꍇ�AA �y�� b �́A�݂�
% �ɘA������邱�ƂɂȂ�܂��B
% 
%       Cons = [A, b]; Cons =  pcglims(Groups, GroupMin, GroupMax)
% 
% �Q�l : PORTOPT, PCPVAL, PCALIMS, PCGCOMP, PORTCONS.


%   Author(s): J. Akao, M. Reyes-Kattar, 03/20/98
%   Copyright 1995-2002 The MathWorks, Inc. 
