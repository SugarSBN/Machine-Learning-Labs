X = load("ex2Data/ex2x.dat");
Y = load("ex2Data/ex2y.dat");
[m, n] = size(X);
X = [ones(m, 1), X];
sigma = std(X);
mu = mean(X);
X(:, 2) = (X(:, 2) - mu(2)) ./ sigma(2);
X(:, 3) = (X(:, 3) - mu(3)) ./ sigma(3);

learning_range = [0.001, 10];

alpha = [0.01, 0.3, 0.5, 0.7, 1, 2];

J = zeros(50, 6);
for t = 1 : 6
    theta = [0, 0, 0]';
    for num_iterations = 1 : 50
        J(num_iterations, t) = 1 / (2 * m) * sum((X * theta - Y) .* (X * theta - Y));

        for j = 1 : length(theta)
            sums = 0;
            for i = 1 : size(X, 1)
                sums = sums + (X(i, :) * theta - Y(i)) * X(i, j);
            end
            theta(j) = theta(j) - alpha(t) / m * sums;
        end
    end
end

figure ;
plot (0 : 49 , J(1 : 50, 1), '-' );
hold on;
plot (0 : 49 , J(1 : 50, 2), '-' );
plot (0 : 49 , J(1 : 50, 3), '-' );
plot (0 : 49 , J(1 : 50, 4), '-' );
plot (0 : 49 , J(1 : 50, 5), '-' );
plot (0 : 49 , J(1 : 50, 6), '-' );
legend("\alpha=0.1","\alpha=0.3","\alpha=0.5","\alpha=0.7","\alpha=1","\alpha=2");
xlabel("number of iterations");
ylabel("Cost J");

