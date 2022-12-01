data = load("./data5/training_3.txt");

X = data(:, 1 : 2);
Y = data(:, 3);
xplot = linspace(min(X(:, 1)), max(X(:, 1)), 100)';
yplot = linspace(min(X(:, 2)), max(X(:, 2)), 100)';
[Xs, Ys] = meshgrid(xplot, yplot);

prob = optimproblem('ObjectiveSense', 'max');
alpha = optimvar("alpha", size(X, 1), 1, 'LowerBound', 0);

K = zeros(size(X, 1), size(X, 1));
for i = 1 : size(X, 1)
    for j = 1 : size(X, 1)
        K(i, j) = exp(-100 * norm(X(i, :) - X(j, :))^2);
    end
end
tmp = (Y * Y') .* (alpha * alpha') .* K;
prob.Objective = sum(alpha) - 0.5 * sum(sum(tmp));
prob.Constraints.con = sum(alpha .* Y) == 0;

[s, f] = solve(prob);

ys = 0;
xs = zeros(1, 2);
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

vals = zeros(size(xplot, 1), size(yplot, 1));
for i = 1 : 100
    for j = 1 : 100
        x = [xplot(i); yplot(j)];
        vals(i, j) = b;
        for k = 1 : size(X, 1)
            vals(i, j) = vals(i, j) + s.alpha(k) * Y(k) * exp(-100 * norm(X(k, :) - x)^2);
        end
    end
end

pos = [];
neg = [];
for i = 1 : size(X, 1)
    if (Y(i) == 1)
        pos = [pos; X(i, :)];
    else
        neg = [neg; X(i, :)];
    end
end
plot(pos(:, 1), pos(:, 2), 'r+', neg(:, 1), neg(:, 2), 'bo');
hold on;
colormap bone
contour(Xs, Ys, vals, -20 : 0.1 : 0);
title('Non Linear training 3');