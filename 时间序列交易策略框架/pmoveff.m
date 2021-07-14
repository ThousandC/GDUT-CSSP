function  eff  =  pmoveff( S , N )
%% indicator: 价格波动效率系数
% S: 价格序列
% N: 窗口长度



%%

T = numel(S);
eff = nan(T,1);
for i = N : T
    moves  =  abs( S(i-N+2:i) - S(i-N+1:i-1) );
    movpath = sum(moves);
    movdist = abs( S(i) - S(i-N+1) );
    eff(i) = movdist / movpath;
end


