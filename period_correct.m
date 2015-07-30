function outs = period_correct(X,upper)

for i = 1:length(X(:,1))

        if X(i,1) < 0                  
            X(i,1) = upper - mod(abs(X(i,1)),upper);
        end
        
        if X(i,2) < 0
            X(i,2) = upper - mod(abs(X(i,2)),upper);
        end

        if X(i,1) > upper
           X(i,1) = 0 + mod(abs(X(i,1)),upper);
        end

        if X(i,2) > upper
           X(i,2) = 0 + mod(abs(X(i,2)),upper);
        end
end

outs = X;        
end
