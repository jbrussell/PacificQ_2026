function [] = test_kernel_forward(frech_S,forward,grv,ifig)

q_est = [];
periods = [];
for ip = 1:length(frech_S)
    periods(ip) = frech_S(ip).per;
    dr = abs(diff(frech_S(ip).rad));
    dr = [0; dr];
    K_qmu = frech_S(ip).K_qmu;
    K_qkappa = frech_S(ip).K_qkappa;
    qmu = frech_S(1).qmu;
    qkappa = frech_S(1).qkappa;
    
    qinv = sum( (K_qmu./qmu + K_qkappa./qkappa).* dr ) ;
    q_est(ip) = 1./qinv;
end

figure(ifig); clf;
subplot(1,2,1); box on;
hold on;
% plot(T,q,'-k','linewidth',3);
plot(forward.sper,forward.sqinv,'-k','linewidth',2);
plot(periods,1./q_est,'or','linewidth',2);
legend('True','Predicted')
xlabel('Period (s)');
ylabel('Q^{-1}');
xlim([min(periods)-5 max(periods)+5]);

alpha_est = (2*pi./periods) ./ (2.*grv.*q_est);
subplot(1,2,2); box on;
hold on;
plot(forward.sper,forward.salpha,'-k','linewidth',2);
plot(periods,alpha_est,'or','linewidth',2);
xlabel('Period (s)');
ylabel('\alpha (km^{-1})');
xlim([min(periods)-5 max(periods)+5]);

end

