% dispersion solves the linear dispersion relation
% given frequency, w = 2 pi/Period [1/sec], 
% and water depth, h [meters] the dispersion routine returns the 
% wavenumber, k = 2 pi/Wavelength [1/m],
% n = ratio of group speed to phase speed, and 
% c = phase speed [m/s]
% [k n c] = dispersion (w,h)

function [k,n,c] = dispersion (w,h,showflag)
if nargin<3;showflag = 1;end
if find(h<=0)>0&showflag;
  disp('WARNING: water depth should be > 0');
  disp('A wavenumber of 10^10 will be returned for all depths <= 0 ');end
ind = find(h<=0);h(ind)= 1;

g = 9.81;
k=w./sqrt(g*h);diff=max(max(w.^2-g*k.*tanh(k.*h)));
while abs(diff) > 1*10^-8
  knew = k -(w.^2-g*k.*tanh(k.*h))./(-g*tanh(k.*h)-g*k.*h.*sech(k.*h).^2);
  k = knew;
  diff=max(max(w.^2-g*k.*tanh(k.*h)));
end
c=w./k;
k(ind) = 10^10;
n = .5*(1+(2*k.*h)./sinh(2*k.*h));
n(ind) = 1;
c(ind) = 0;