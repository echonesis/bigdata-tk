function [SOut] = accgen(SIn, varargin)
%ACCGEN

InputVec = sort(SIn);
if isa(SIn, 'double')
    IdxArray = cat(1, 1, InputVec(2:end) - InputVec(1:end-1));
    SOut = nan(sum(IdxArray ~= 0), 2);
    SOut(:, 1) = InputVec(IdxArray ~= 0);
    Idx = cat(1, find(IdxArray ~= 0), length(SIn)+1);
    SOut(:, 2) = Idx(2:end) - Idx(1:end-1);
    
else
    % for cell array
    UVec = unique(InputVec);
    SOut = cell(length(UVec), 2);
    SOut(:, 1) = UVec;
    for Cnt = 1:length(UVec)
        SOut(Cnt, 2) = sum(strcmp(InputVec, UVec{Cnt}));
    end
end