function newEigenset = averageEigenvalues(eigenset, ignore)

   newEigenset = zeros(length(eigenset),1);
   for ii = 1:size(eigenset,1)
      sum = 0;
      tally = 0;
      for jj = 1:size(eigenset,2)
         if (real(eigenset(ii,jj)) ~= ignore)
            sum = sum + real(eigenset(ii,jj));
            tally = tally + 1;
         end
      end
      if tally > 0
         newEigenset(ii) = sum/tally;
      else
         newEigenset(ii) = 0;
      end
   end

end