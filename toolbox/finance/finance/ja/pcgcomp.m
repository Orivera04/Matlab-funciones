% PCGCOMP   ���Y�W�����m�̔�r����ɑ΂���ꎟ�s�������o��
%
% ���鎑�Y�W�����̔z���Ƒ��̎��Y�W�����̔z���̔䗦���A�ŏ��l�� AtoBmin�A
% �ő�l�� AtoBmax �Őݒ肵�܂��B��r�́ANASSETS �̗��p�\�ȓ����̕�
% ���W������\�������C�Ӑ� NGROUPS �Ԃōs�����Ƃ��ł��܂��B
% 
%   [A,b] = pcgcomp(GroupA, AtoBmin, AtoBmax, GroupB)
% 
% ����:
%   GroupA, GroupB  : ��r����W�����w�肷�� NGROUPS �s NASSETS ��̒l�B
%                     �e�s�̒l�́A����W���ɂǂ̎��Y�����蓖�Ă��Ă���
%                     �����w�肵�Ă��܂��BGroup(i,j)=1�̏ꍇ�A�W�� i ��
%                     ���Y j ���܂�ł��܂��B���̑��̏ꍇ�AGroup(i,j)= 0
%                     �ƂȂ�܂��B
%
%   AtoBmin, AtoBmax�F�W�� A �ւ̎��Y�z���ƏW�� B �ւ̎��Y�z���Ƃ̍ŏ�
%                     �䗦�E�ő�䗦���܂ރX�J���l�A�܂��́ANGROUPS ��
%                     �����̃x�N�g���ł��BNaN �����͂��ꂽ�ꍇ�A���̕���
%                     �ւ�2�̏W���Ԃ̎��Y�z���ɂ͉��琧�񂪂Ȃ����Ƃ�
%                     �Ӗ����܂��B�X�J���Őݒ肳�ꂽ�͈͂́A�S�Ă̏W����
%                     �y�A�ɓK�p����܂��BNGROUPS �̐��������݂���W��
%                     �̃y�A�̂��ꂼ��ɂ��āA���̎����������܂��B
% 
%          GroupA total >= GroubB total * AtoBmin
%          GroupA total <= GroubB total * AtoBmax
% 
% �o��:
% A*Pwts' <= b �Ƃ�������֌W����������s�� A �y�уx�N�g�� b ���o�͂�
% �܂��B�����ŁAPwts �� ���Y�z����1�sNASSETS��̃x�N�g���ł��B
%
% �ʂ̎g�p�@�F
% 2�ȉ��̏o�͈����𔺂��^�ŁA���̊֐����R�[�������ꍇ�AA �y�� b ��
% �݂��ɘA������邱�ƂɂȂ�܂��B 
% 
%    Cons = [A, b]; Cons = pcgcomp(GroupA, AtoBmin, AtoBmax, GroupB)
% 
% �Q�l : PORTOPT, PCALIMS, PCPVAL, PCGLIMS, PORTCONS


%   Author(s): J. Akao, M. Reyes-Kattar, 03/11/98
%   Copyright 1995-2002 The MathWorks, Inc. %
