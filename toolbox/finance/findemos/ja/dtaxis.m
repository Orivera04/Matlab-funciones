% DTAXIS   �f�[�^�Ɠ������������t�����x��
%
% �g�p�@�Fdtaxis(XYZ, DateForm, StartDate, TickDateSpace)
%
% ���́F
% XYZ           : 'x', 'y', 'z' �̂����ꂩ�̕�����B�f�t�H���g: 'x'
% DateForm      : ���t������̓��t�����t���O�B�f�t�H���g: 6  -> 'mm/dd'
% StartDate     : ���̍ŏ����t�B              �f�t�H���g: data-min
% TickDateSpace : �ڐ���ԂɊ��蓖�Ă邱�Ƃ̂ł���ŏ������ł��B
%    
% ���F 
%   dates = cfdates(today, today+3*365, 2);
%   plot( dates, rand(size(dates)))
%   dtaxis('x',2,[],180)


% Example utility J. Akao 11/08/97
% Copyright 1995-2002 The MathWorks, Inc.  
