function [ output_args ] = myfsolve()

   options = optimoptions('fsolve','Display','off');
   
   x_ss = fsolve(reducedFunction, [param.x.guess], options)';

end

