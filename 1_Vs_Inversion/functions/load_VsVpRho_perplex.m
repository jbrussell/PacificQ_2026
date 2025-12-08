function [vs,vp,rho,depth,T_C] = load_VsVpRho_perplex(z,zh2o,Nsmooth,age_myr,Tp_C,modeltype,path2perlextab_vs,path2perlextab_vp,path2perlextab_rho,isplot)
% Load vp and vs from perplex and form vp/vs ratio
    
    % Remove water layer (will add it back at the end)
    Ih2o = find(z==zh2o);
    z = z(Ih2o(end):end)-zh2o;
    
    t_Myr = age_myr+1e-12;
    if strcmpi(modeltype,'hsc')
        [ HF.z_m,HF.T_K,HF.P_GPa,HF.rho_kgm3 ] = calc_HSC( Tp_C+273,t_Myr, z*1000 );
    elseif strcmpi(modeltype,'plate')
        z_plate_km = 90;
        [ HF.z_m,HF.T_K,HF.P_GPa,HF.rho_kgm3 ] = calc_platecooling( Tp_C+273,t_Myr,z_plate_km, z*1000 );
    end
    HF.T_C = HF.T_K - 273;
    HF.z_km = HF.z_m/1000;

    % Extract Perple_X Density Profiles
    % Load tab data
    [x,y,z,~,~,~,~,~,~,~,~] = load_perple_x_tab(path2perlextab_rho);
    T_perplex=x; P_perplex=y/10000; Z_perplex=z;
    % Extract property along the defined T-P path
    [ ~,~,Z,depth ] = extract_PTpath( HF.P_GPa,HF.T_K,HF.z_m,P_perplex,T_perplex,Z_perplex );
    rho = Z/1000;
    depth = depth/1000;
    
    % Extract Perple_X Vs Profiles
    % Load tab data
    [x,y,z,~,~,~,~,~,~,~,~] = load_perple_x_tab(path2perlextab_vs);
    T_perplex=x; P_perplex=y/10000; Z_perplex=z;
    % Extract property along the defined T-P path
    [ ~,~,Z,~ ] = extract_PTpath( HF.P_GPa,HF.T_K,HF.z_m,P_perplex,T_perplex,Z_perplex );
    vs = Z;
    
    % Extract Perple_X Vp Profiles
    % Load tab data
    [x,y,z,~,~,~,~,~,~,~,~] = load_perple_x_tab(path2perlextab_vp);
    T_perplex=x; P_perplex=y/10000; Z_perplex=z;
    % Extract property along the defined T-P path
    [ ~,~,Z,~ ] = extract_PTpath( HF.P_GPa,HF.T_K,HF.z_m,P_perplex,T_perplex,Z_perplex );
    vp = Z;
    
    % Smooth the profiles
    rho = smooth(rho,Nsmooth);
    vs = smooth(vs,Nsmooth);
    vp = smooth(vp,Nsmooth);
    
    depth = [0; zh2o; depth+zh2o];
    vs = [0; 0; vs];
    vp = [1.5; 1.5; vp];
    rho = [1.03; 1.03; rho];
    T_C = [0; 0; HF.T_C];

    if isplot
        figure(1000); clf;
        set(gcf,'position',[163         324        1387         566*1.5],'color','w');
        sgtitle('Perple_X','interpreter','none','fontsize',20,'fontweight','bold');

        subplot(2,3,1); box on; hold on;
        plot(T_C,depth,'-','color',[0 0 0],'linewidth',3);
        set(gca,'fontsize',16,'linewidth',1.5,'ydir','reverse');
        xlabel('T ({\circ}C)');
        ylabel('Depth (km)');

        subplot(2,3,2); box on; hold on;
        vp_vs = vp ./ vs;
        plot(vp_vs,depth,'-','color',[0 0 1],'linewidth',3);
        set(gca,'fontsize',16,'linewidth',1.5,'ydir','reverse');
        xlabel('Vp/Vs');
        ylabel('Depth (km)');

        subplot(2,3,3); box on; hold on;
        rho_vs = rho ./ vs;
        plot(rho_vs,depth,'-','color',[0 0 1],'linewidth',3);
        set(gca,'fontsize',16,'linewidth',1.5,'ydir','reverse');
        xlabel('\rho/Vs');

        subplot(2,3,4); box on; hold on;
        plot(vs,depth,'-','color',[1 0 0],'linewidth',3);
        set(gca,'fontsize',16,'linewidth',1.5,'ydir','reverse');
        xlabel('Vs');

        subplot(2,3,5); box on; hold on;
        plot(vp,depth,'-','color',[1 0 0],'linewidth',3);
        set(gca,'fontsize',16,'linewidth',1.5,'ydir','reverse');
        xlabel('Vp');

        subplot(2,3,6); box on; hold on;
        plot(rho,depth,'-','color',[1 0 0],'linewidth',3);
        set(gca,'fontsize',16,'linewidth',1.5,'ydir','reverse');
        xlabel('\rho');
    end
    
end

