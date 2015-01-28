clc; clear; clc;

a = importdata('test.txt', ',');
a = regexp(a, ',', 'split');
p = cell(size(a, 1), 2);
for i = 1:size(p, 1)
    p{i, 1} = a{i}{1, 1};
    p{i, 2} = a{i}{1, 2};
end
fluxg(p, '10.1.255.255');