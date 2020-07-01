
function X_actual = mappingUnitToReal(X, elements_to_test, inputs_to_test, param)

% map values [0,1] to required range
   variables = length(elements_to_test);
   num_scenarios = length(X);
   
   tt = 1e-6;
   y_val = (0: tt: 1-tt);
   X_actual = zeros(num_scenarios, variables);
   for kk = 1:variables
     whichEl = elements_to_test(kk);
     currcdf = icdf(param.el(whichEl).pdf , y_val)';
     for ii = 1:num_scenarios
        index = floor((X(ii,kk)/tt))+1;
        X_actual(ii, kk) = currcdf(index);
        if (X_actual(ii, kk) == 0)
           X_actual(ii, kk) = 1e-9;
        end
     end
   end

end