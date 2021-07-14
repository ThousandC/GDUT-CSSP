function  S0  =  fillstock2index( S , sn0 , T , inivalue , flag )
%% fill the stock data (S) to make sure the length of stock data matches with index data length (T)
% flag: 0 (用固定值inivalue); 1 (用前值)



%%
if size(S,1) > size(S,2) % 列向量
    S0 = nan(T,1);
else % 列向量
    S0 = nan(1,T);
end
S0(sn0) = S;



%% 补全数据点（两种方法）
if isnan( S0(1) )
    S0(1) = inivalue;
end
for i = 2 : T
    if isnan( S0(i) )
        S0(i) = S0(i-1)*flag + inivalue*(1-flag);
    end
end


