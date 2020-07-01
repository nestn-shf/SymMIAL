function newEigenset = selectWindowEigenvalues(eigenset, x1, x2, y1, y2)
   newEigenset = zeros(size(eigenset,1),1);
   for ii = 1:size(eigenset,1)
      hasFound = 0;
      for jj = 1:size(eigenset,2)
         if ((real(eigenset(ii,jj)) >= x1) && (real(eigenset(ii,jj)) <= x2) && (imag(eigenset(ii,jj)) >= y1) && (imag(eigenset(ii,jj)) <= y2))
            newEigenset(ii,1) = eigenset(ii,jj);
            hasFound = 1;
         end
      end
      if (hasFound == 0)
         sprintf('y');
      end
   end
end