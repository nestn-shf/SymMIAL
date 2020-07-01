function numerical_diff = diffPertubation(matrixAFunction, u, el, ssic, elementOrStateOrInput, index, pertubationFactor)

   values_nominal = num2cell([u'; el'; ssic']);

   if (elementOrStateOrInput == 1) %element

      el(index) = el(index) + el(index)*pertubationFactor;
      values_perturb = num2cell([u'; el'; ssic']);
      delVal = el(index);


   elseif (elementOrStateOrInput == 2) %state


   elseif (elementOrStateOrInput == 3) %input


   else %error

   end

   numerical_diff = (matrixAFunction(values_perturb{:}) - matrixAFunction(values_nominal{:}))/delVal;
   
end

