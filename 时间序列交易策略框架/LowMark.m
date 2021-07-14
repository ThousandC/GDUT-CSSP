function  [ lowmark , nlow ]  =  LowMark( OHLC , N , hl_c )
%% obtain lowmark and new-low flag time series
% hl_c: select lowmark type (1(HL) or 2(C))
% lowmark (T by 1 vector): recording N-period lowmark price
% nlow (T by 1 vector): indicating N-bar new low (1) or not (0)



%%
% flag indicating c or hl
if  hl_c == 1
    flag = 3;
elseif  hl_c == 2
    flag = 4;
end



%%
T = size(OHLC,1);
lowmark = nan(T,1);
nlow = zeros(T,1);
for i = max(N,2) : T
    lowmark(i) = min( OHLC(i-N+1:i, flag) );
    if OHLC(i,4) < lowmark(i-1)
        nlow(i) = 1;
    end
end

