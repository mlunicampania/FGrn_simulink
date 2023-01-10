function [bX,fY,H] = oneinoneoutML3(fX,bY,L,Hin,Nit)
%ONEINONEOUT implements message propagation for a block 
%with one input X ---> one output Y.
%It learns from the examples, indicated by the learning mask L,
%the conditional probability matrix H.
%It return backward X and forward Y using the  learnt matrix H 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SUN, September 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%INPUT:
%fX  N realizations of forward X  (NxMX matrix)
%bY  N realizations of backward Y (NxMY matrix)
%L  learning mask (Nx1 array) L(i)=1 learn, L(i)=0 do not learn
%Hin (MXxMY row-stochastic array) initial value for H
%Nit number of iterations for learning H
%OUTPUT:
%bX N realizations of backward X (NxMX) with the learnt H
%fY N realizations of forward Y (NxMY) with the learnt H
%H (MXxMY row-stochastic array) learnt H
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%get parameters from the input%%%%%%%%%%%%%%%%%%%%%%%%
[N MX]=size(fX); %N number of realizations; MX alphabet size for X
[N MY]=size(bY); %N number of realizations; MY alphabet size for Y
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%get initial value for matrix H 
H=Hin;

%[MX, MY] = size(Hin);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%Learn H%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eps=0.0000000000000001; %small value 
internalEps = 1e-6;
H_back = H;
fXave = ones(1,MX)*eps;
if (Nit > 0)
    % compute average fX
    fXave=ones(1,MX)*eps; %initialize to small value
    for n=1:N    
        fXave=fXave+fX(n,:)*L(n);
    end
    H_back=H;    
end


for itH=1:Nit
%               uv' / u'Hv
%
    %s = (ones(MX,MY) * eps) / MY; %initialize to small value
    s = zeros(MX,MY);
    for n = 1:N
        s = s + L(n)*(fX(n,:)'*bY(n,:))/(fX(n,:)*H_back*bY(n,:)' + internalEps);
        %the algorithm maximizes the Likelihood
    end    
    Htemp= H_back .* s;
    parfor i=1:MX
        dist=Htemp(i,:) / (fXave(i) + internalEps) ;
        H(i,:)= dist / sum(dist + eps);
    end
    H_back=H;
end

%%%%%propagate the values on the learnt matrix 
distr = (H * bY')';
bX = transformStochastic(distr,2);

distr = (H' * fX')';
fY = transformStochastic(distr,2);

end %return 