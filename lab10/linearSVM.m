data = load("./data5/training_2.txt");
pos = [];
neg = [];
[m, n] = size(data);
m = 100;

for i = 1 : m
    if data(i, n) == 1
        pos = [pos; data(i, 1 : n - 1)];
    else
        neg = [neg; data(i, 1 : n - 1)];
    end
end

plot(pos(:, 1), pos(:, 2), '+');
hold on;
plot(neg(:, 1), neg(:, 2), 'o');

prob = optimproblem('ObjectiveSense', 'max');
 

X = data(1 : m, 1 : n - 1);
Y = data(1 : m, n);
clear data;

alpha = optimvar("alpha", size(X, 1), 1, 'LowerBound', 0);
tmp = (Y * Y') .* (X * X') .* (alpha * alpha');
prob.Objective = sum(alpha) - 0.5 * sum(sum(tmp));
prob.Constraints.con = sum(alpha .* Y) == 0;

[s, f] = solve(prob);

w = zeros(1, n - 1);
for i = 1 : size(X, 1)
    w = w + s.alpha(i) * Y(i) * X(i, :);
end

ys = 0;
xs = zeros(1, n - 1);
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

xs = 20 : 1 : 180;
ys = (-w(1) * xs - b) / w(2);
plot(xs, ys, 'b-');
ys = (1 - w(1) * xs - b) / w(2);
plot(xs, ys, 'k--');
ys = (-1 - w(1) * xs - b) / w(2);
plot(xs, ys, 'k--');
title('training data 2');

test_set = load("./data5/test_2.txt");
pred = sign(test_set(:, 1 : 2) * w' + b);
acc = sum(pred == test_set(:, 3)) / size(test_set, 1)
% training data 1 acc = 99.6
% training data 2 acc = 99.6