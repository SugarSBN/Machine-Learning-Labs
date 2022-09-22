X = load("ex2Data/ex2x.dat");
Y = load("ex2Data/ex2y.dat");
[m, n] = size(X);
X = [ones(m, 1), X];

theta = inv(X' * X) * X' * Y

[1, 1650, 3] * theta