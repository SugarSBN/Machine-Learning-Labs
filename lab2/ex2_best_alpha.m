X = load("ex2Data/ex2x.dat");
Y = load("ex2Data/ex2y.dat");
[m, n] = size(X);
X = [ones(m, 1), X];
sigma = std(X);
mu = mean(X);
X(:, 2) = (X(:, 2) - mu(2)) ./ sigma(2);
X(:, 3) = (X(:, 3) - mu(3)) ./ sigma(3);
alpha = 1;

J = zeros(50, 1);
theta = [0, 0, 0]';

for num_iterations = 1 : 50
    J(num_iterations) = 1 / (2 * m) * sum((X * theta - Y) .* (X * theta - Y));

    for j = 1 : length(theta)
        sums = 0;
        for i = 1 : size(X, 1)
            sums = sums + (X(i, :) * theta - Y(i)) * X(i, j);
        end
        theta(j) = theta(j) - alpha / m * sums;
    end
end

theta

pre_X = [1, 1650, 3];
pre_X(2) = (pre_X(2) - mu(2)) / sigma(2);
pre_X(3) = (pre_X(3) - mu(3)) / sigma(3);
pre_X * theta

