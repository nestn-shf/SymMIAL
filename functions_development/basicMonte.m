function monteScenario = basicMonte(system, param, samples, inputs_to_test, elements_to_test)

   %% Generate random number matrix
   % input vector length - (10)
   % N samples
   
   inputs = length(inputs_to_test);
   elements = length(elements_to_test);
   variables = inputs+elements;
   N = samples;

   %quasi-random set [0, 1]
   set = sobolset(2*variables);
   totaldata_unit = net(set,N);
   
   monteScenario.totaldata_unit = totaldata_unit;

   %% Map random set based on distribution of value
   scaleVal = @(x, min, max, a, b) ( ((b-a)*(x-min))/(max-min) + a);
   tt = 1e-6;
   y = (0: tt: 1-tt);
   %estcdf = zeros(length(y), variables);
   totaldata_val = zeros(N, 2*variables);
   jj = 1;
   for kk = 1:2
      for ii = 1:inputs
         whichInput = inputs_to_test(ii);
         currcdf = icdf(param.u(whichInput).pdf , y)';
         index = (totaldata_unit(:,jj)/tt);
         index = floor(scaleVal(index, min(index), max(index), 1, 1/tt));
         totaldata_val(:, jj) = currcdf(index);
         jj = jj + 1;
      end
      for ii = 1:elements
         whichInput = elements_to_test(ii);
         currcdf = icdf(param.el(whichInput).pdf , y)';
         index = (totaldata_unit(:,jj)/tt);
         index = floor(scaleVal(index, min(index), max(index), 1, 1/tt));
         totaldata_val(:, jj) = currcdf(index);
         jj = jj + 1;
      end
   end
   monteScenario.totaldata_val = totaldata_val;
   clear currcdf y tt set ii curr_el totaldata_unit estcdf jj kk index whichElement whichInput scaleVal ans;

   %% split data
   sampA = totaldata_val(:, 1 : variables );
   monteScenario.sampA = sampA;


   %% compute the steady-state (initial conditions)
   scn_u_A = zeros(N, system.numberof.systemInputs);
   scn_el_A = zeros(N, system.numberof.elements);
   ss_ic_A = zeros(N, system.numberof.states);
   ss_y_A = zeros(N, length(system.ident.output));
   exitflags_A = zeros(N, 1);

   systemFunction = system.equation.anonDifferential;
   options = optimoptions('fsolve','Display','none');

   %find steady-state for the nominal case, and update the guess
   reducedFunction = @(y) systemFunction(y, [param.u(:).val], [param.el(:).val]);
   x_ss = fsolve(reducedFunction, [param.x.guess], options)';

   tic
   for ii = 1:N
      [scn_u, scn_el] = buildVectorMonte(sampA(ii,:), inputs_to_test, elements_to_test, [param.u(:).val], [param.el(:).val]);
      reducedFunction = @(y) systemFunction(y, scn_u, scn_el);
      scn_u_A(ii,:) = scn_u;
      scn_el_A(ii,:) = scn_el;
      [temp1,~,temp2,~] = fsolve(reducedFunction, x_ss, options);
      ss_ic_A(ii,:) = temp1;
      exitflags_A(ii) = temp2;
      ss_y_A(ii,:) = system.equation.anonOutput(temp1', scn_u', scn_el');
      
      monteScenario.A.scn_u(ii,:) = scn_u;
      monteScenario.A.scn_el(ii,:) = scn_el;
      monteScenario.A.scn_ss_ic(ii,:) = temp1;
      monteScenario.A.exitflag(ii) = temp2;
   end

   %{
   for ii = 1:N
      [scn_u, scn_el] = buildVectorMonte(sampB(ii,:), inputs_to_test, elements_to_test, [param.u(:).val], [param.el(:).val]);
      reducedFunction = @(y) systemFunction(y, scn_u, scn_el);
      scn_u_B(ii,:) = scn_u;
      scn_el_B(ii,:) = scn_el;
      [temp1,~,temp2,~] = fsolve(reducedFunction, x_ss, options);
      ss_ic_B(ii,:) = temp1;
      exitflags_B(ii) = temp2;
      ss_y_B(ii,:) = system.equation.anonOutput(temp1', scn_u', scn_el');
      
      monteScenario.B.scn_u(ii,:) = scn_u;
      monteScenario.B.scn_el(ii,:) = scn_el;
      monteScenario.B.scn_ss_ic(ii,:) = temp1;
      monteScenario.B.exitflag(ii) = temp2;
   end
   %}
%{
   for jj = 1:variables
      scn_u_C{jj} = zeros(N, system.numberof.systemInputs);
      scn_el_C{jj} = zeros(N, system.numberof.elements);
      ss_ic_C{jj} = zeros(N, system.numberof.states);
      ss_y_C{jj} = zeros(N, length(system.ident.output));
      exitflags_C{jj} = zeros(N, 1);
   end
   for jj = 1:variables
      for ii = 1:N
         [scn_u, scn_el] = buildVectorMonte(sampC{jj}(ii,:), inputs_to_test, elements_to_test, [param.u(:).val], [param.el(:).val]);
         reducedFunction = @(y) systemFunction(y, scn_u, scn_el);
         scn_u_C{jj}(ii,:) = scn_u;
         scn_el_C{jj}(ii,:) = scn_el;
         [temp1,~,temp2,~] = fsolve(reducedFunction, x_ss, options);
         ss_ic_C{jj}(ii,:) = temp1;
         exitflags_C{jj}(ii) = temp2;
         ss_y_C{jj}(ii,:) = system.equation.anonOutput(temp1', scn_u', scn_el');
         
         monteScenario.C{jj}.scn_u(ii,:) = scn_u;
         monteScenario.C{jj}.scn_el(ii,:) = scn_el;
         monteScenario.C{jj}.scn_ss_ic(ii,:) = temp1;
         monteScenario.C{jj}.exitflag(ii) = temp2;
      end
   end
%}
   toc
   
   
   
end