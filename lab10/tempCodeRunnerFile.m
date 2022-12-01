alpha = optimvar("alpha", m, 1);
prob.Objective = sum(alpha) - sum(sum((repmat(alpha, 1, 2) .* tmp) * (repmat(alpha, 1, 2) .* tmp)'));

prob.Constraints.con1 = alpha >= 0;
prob.Constraints.con2 = alpha <= C;
prob.Constraints.con3 = sum(alpha .* data(:, 3)) == 0;
