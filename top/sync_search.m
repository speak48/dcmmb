function [cto] = SYNC_Search(din);

global sync_param;

if sync_param.SYNC_Search_enable == 1
    for i=1:100000
    cor = din .* din(2049:);
    
