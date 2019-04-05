%{
Parameters
----------
ranking: array
    array of 0,1 where the nth element states if the nth element was of the
    to-be predicted class or not.

Return
map: double
    mean Average Precision
----------
%} 

function [mAP] = get_map(ranking)
[length, ~] = size(ranking);
%length
%sum(ranking)
sums = 0;
fc_val = 0;
for i = 1:length
    fc_val = fc_val + ranking(i);
    sums = sums + (fc_val*ranking(i)/i);
end
mAP = sums/(sum(ranking));

end