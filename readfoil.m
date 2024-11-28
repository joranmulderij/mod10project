function [ret] = readfoil(path)

ret = table2array(readtable(path,'NumHeaderLines',1));

end

