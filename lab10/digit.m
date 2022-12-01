[Y, X] = strimage(100);

[m, n] = size(X);

prob = optimproblem('ObjectiveSense', 'max');
alpha = optimvar("alpha", size(X, 1), 1, 'LowerBound', 0);
tmp = (Y * Y') .* (X * X') .* (alpha * alpha');
prob.Objective = sum(alpha) - 0.5 * sum(sum(tmp));
prob.Constraints.con = sum(alpha .* Y) == 0;

prob.Constraints.con1 = alpha <= 10;

[s, f] = solve(prob);

w = zeros(1, n);
for i = 1 : size(X, 1)
    w = w + s.alpha(i) * Y(i) * X(i, :);
end

ys = 0;
xs = zeros(1, n);
for i = 1 : size(X, 1)
    if (s.alpha(i) > 1e-6)
        ys = Y(i);
        xs = X(i, :);
        break;
    end
end

b = ys;
for i = 1 : size(X, 1)
    b = b - s.alpha(i) * Y(i) * X(i, :) * xs';
end

[test_label, test_set] = strimage_test(1500);
pred = sign(test_set(:, 1 : n) * w' + b);
acc = sum(pred == test_label) / 1500
% C = 0, 99.67%
% C = 1, 99.8%
% C = 2, 99.8%
% C = 3, 99.8%
% C = 10, 99.8%