function  [ highmark , nhigh ]  =  HighMark( OHLC , N , hl_c )
%% obtain highmark and new-high flag time series
% hl_c: select highmark type (1(HL) or 2(C))
% highmark (T by 1 vector): recording N-period highmark price
% nhigh (T by 1 vector): indicating N-bar new high (1) or not (0)



%%
% flag indicating c or hl
if  hl_c == 1
    flag = 2;
elseif  hl_c == 2
    flag = 4;
end



%%
T = size(OHLC,1);
highmark = nan(T,1);
nhigh = zeros(T,1);
for i = max(N,2) : T
    highmark(i) = max( OHLC(i-N+1:i, flag) );
    if OHLC(i,4) > highmark(i-1)
        nhigh(i) = 1;
    end
end