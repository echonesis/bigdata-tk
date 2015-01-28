function fluxg(SIn, varargin)
%FLUXG

if nargin > 1
    SrcName = varargin{1};
else
    SrcName = 'Src:Host';
end

% for each Dst graph
UDst = unique(SIn(:, 1));
for DstCnt = 1:length(UDst)
    DstName = UDst{DstCnt};
    TmpTime = datenum(SIn(strcmp(SIn(:, 1), UDst{DstCnt}), 2));
    AccArray = accgen(TmpTime);
    
    h = figure;
    pngname = strcat(SrcName, '-', DstName, '.png');
    stem(AccArray(:, 1), AccArray(:, 2));
    print(h, '-dpng', pngname);
    close(h);
end