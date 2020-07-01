function [vect1, vect2] = buildVectorMonte(sampleRow, inputs_to_test, elements_to_test, param_u, param_el)

   %copy vector
   vect1 = param_u;
   vect2 = param_el;
   
   for ii = 1:length(inputs_to_test)
      val = inputs_to_test(ii);
      vect1(val) = sampleRow(ii);
   end
   
   for ii = 1:length(elements_to_test)
      val = elements_to_test(ii);
      vect2(val) = sampleRow( length(inputs_to_test) + ii);
   end   
      
   %vect1 = %u
   %vect2 = %el
end
