% PCPVAL   �Œ肳�ꂽ�|�[�g�t�H���I�̑����l�ɑ΂���ꎟ�s�������o��
%
% NumAssets �̎��Y����Ȃ�|�[�g�t�H���I�̑����l���APortValue ��
% �X�P�[�����O���܂��BExpReturn �� ExpCovariance (PORTOPT���Q��)������
% �|�[�g�t�H���I�̉��d�l�A�͈͎��v�A�댯�l�S�Ă� PortValue �̍��ŃX�P�[
% �����O����܂��B
%  
%       [A,b] = pcpval(PortValue, NumAssets)
%
% ����:
%   PortValue : �|�[�g�t�H���I�̑����l(�X�J��)�BPortValue �́A�S���Y��
%               ������z���ʂ̑��a�ł��BPortValue =1�Ɠ��͂���ƁA����
%               �l�Ɋւ�炸�A���d�l�̓|�[�g�t�H���I�̒[��(fraction)��
%               ���āA���v�Ɗ댯���́A���[�g�Ƃ��Ďw�肳��܂��B
%   NumAssets : ���p�\�Ȏ��Y�����̐�
%
% �o��:
% A*Pwts' <= b �̊֌W�ɂ���s�� A �y�уx�N�g�� b ���o�͂��܂��B�����ŁA
% Pwts �́A���Y�z����1�sNASSETS��̃x�N�g���ł��B
%
% �ʂ̎g�p�@�F
% 2�ȉ��̏o�͈����𔺂��`�ł��̊֐����R�[�������ꍇ�AA �y�� b �݂͌���
% �A������邱�ƂɂȂ�܂��B
% 
%        Cons = [A, b]; Cons = pcpval(PortValue, NumAssets)
% 
% 
% �Q�l : PORTOPT, PCALIMS, PCGLIMS, PCGCOMP, PORTCONS.


%   Author(s): J. Akao, M. Reyes-Kattar, 03/11/98
%   Copyright 1995-2002 The MathWorks, Inc. 
