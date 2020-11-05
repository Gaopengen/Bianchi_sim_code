function F = myfun2(x)

global Wmin m n

D1 = 0;
for k = 0 : m - 1
    D1 = D1 + (2 * x(1)).^k;
end
%test
global D;

D = 1 + Wmin + x(1) * Wmin .* D1;

F = [ 1 - (1 - x(2)).^(n-1) - x(1);
    2 / D - x(2)];
end