function [SOut] = ewma(SIn, varargin)

lambda = 0.3;
SOut = SIn;
for Cnt = 2:length(SIn)
    SOut(Cnt) = lambda * SIn(Cnt) + (1 - lambda) * SOut(Cnt-1);
end