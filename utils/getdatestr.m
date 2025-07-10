function [datestr] = getdatestr()
%GETDATESTR Summary of this function goes here
%   Detailed explanation goes here
datestr =  string(datetime('now'));
datestr = regexprep(datestr,'[^a-zA-Z0-9]','');
end

