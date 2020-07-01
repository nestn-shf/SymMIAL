function newEigenset = selectWindowEigenvaluesLargest(eigenset, x1, x2, y1, y2)

   newEigenset = zeros(size(eigenset.metrics,2),1);
   
   for ii = 1:size(eigenset.metrics,2)
      kk = 1;
      %largestEigen = [];
      for jj = 1:size(eigenset.metrics(1).eigs,1)
         eigenvalue = eigenset.metrics(ii).eigs(jj);
         if ((real(eigenvalue) >= x1) && (real(eigenvalue) <= x2) && (imag(eigenvalue) >= y1) && (imag(eigenvalue) <= y2))
            largestEigen(kk) = eigenvalue;
            kk = kk + 1;
         end
      end
      [M,I] = max(real(largestEigen));
      newEigenset(ii) = largestEigen(I);
   end
   
end
