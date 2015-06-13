%%  A Script demonstrating the basic functionalities of the FmapLib (Work in progress).
    clr;
    gitdir;
    cd FmapLib/src

%% Load a Mesh and calculate basic quantities.
    meshfile  = '../data/kid_rodola/0001.isometry.1.off';
    inmesh    = Mesh(meshfile, 'rodola_1_1');
    inmesh.set_triangle_angles();
    inmesh.set_vertex_areas('barycentric');
    inmesh

    % Calculate the first 100 spectra, based on barycentric vertex areas.
    % LB             = Laplace_Beltrami(inmesh);
    % [evals, evecs] = LB.get_spectra(100, 'barycentric');
    % save('../data/output/mesh_and_LB', 'inmesh', 'LB');

    % Load Precomputed ones.
    load('../data/output/mesh_and_LB', 'inmesh', 'LB');
    [evals, evecs] = LB.get_spectra(100, 'barycentric');

%% Geodesic distance
id                = 1;
indicator_fct     = zeros(inmesh.num_vertices, 1);
indicator_fct(id) = 1;
[geo_dist]        = Mesh_Features.geodesic_distance_to_set(inmesh, LB, indicator_fct);

figure;
trisurf(inmesh.triangles, inmesh.vertices(:,1), inmesh.vertices(:,2), inmesh.vertices(:,3), geo_dist);
axis equal; shading interp;

%% Two Meshes and a F-map.
    num_eigs       = 100;   
    meshfile       = '../data/kid_rodola/0001.isometry.1.off';
    mesh1          = Mesh(meshfile, 'rodola_1_1');    
    
%     LB1            = Laplace_Beltrami(mesh1);    
%     [evals, evecs] = LB1.get_spectra(num_eigs, 'barycentric');
%     save('../data/output/LB1', 'LB1');          

    load('../data/output/LB1');    
    [evals, evecs] = LB1.get_spectra(num_eigs, 'barycentric');
            
    wks_samples    = 300;
    hks_samples    = 200;
    curvatures     = 100;
   
    [energies, sigma] = Mesh_Features.energy_sample_generator('log_linear', evals(2), evals(end), wks_samples);
    wks_sig           = Mesh_Features.wave_kernel_signature(evecs(:,2:end), evals(2:end), energies, sigma);
    
    heat_time         = Mesh_Features.energy_sample_generator('log_sampled', evals(2), evals(end), hks_samples);
    hks_sig           = Mesh_Features.heat_kernel_signature(evecs(:,2:end), evals(2:end), heat_time);
    
%     heat_time         = Mesh_Features.energy_sample_generator('log_sampled', evals(2), evals(end), curvatures-1);
%     mean_curvature    = Mesh_Features.mean_curvature(mesh1, LB1, heat_time);    
%     gauss_curvature   = Mesh_Features.gaussian_curvature(mesh1, heat_time);
    
    %TODO-P Normalize prob functions
    from_probes       = LB1.project_functions('barycentric', num_eigs, wks_sig, hks_sig);

        
%     to_probes         = from_probes;    
%     lambda            = 0;
    
%     X = Functional_Map.sum_of_squared_frobenius_norms(from_probes, to_probes, 0, 0, lambda);

%%    
    meshfile = '../data/kid_rodola/0002.isometry.1.off';
    mesh2    = Mesh(meshfile, 'rodola_2_1');
    LB2      = Laplace_Beltrami(mesh2);        
    [evals, evecs]    = LB2.get_spectra(num_eigs, 'barycentric');
    [energies, sigma] = Mesh_Features.energy_sample_generator('log_linear', evals(2), evals(end), wks_samples);
    wks_sig           = Mesh_Features.wave_kernel_signature(evecs(:,2:end), evals(2:end), energies, sigma);    
    heat_time         = Mesh_Features.energy_sample_generator('log_sampled', evals(2), evals(end), hks_samples);
    hks_sig           = Mesh_Features.heat_kernel_signature(evecs(:,2:end), evals(2:end), heat_time);
    to_probes         = LB2.project_functions('barycentric', num_eigs, wks_sig, hks_sig);
    
%%  
    lambda = 20;
    X      = Functional_Map.sum_of_squared_frobenius_norms(from_probes, to_probes, LB1.get_spectra(num_eigs, 'barycentric'), LB2.get_spectra(num_eigs, 'barycentric'), lambda); 
%%
    evaluation_samples  = 20;
    [evals1, evecs1]    = LB1.get_spectra(num_eigs, 'barycentric');
    [evals2, evecs2]    = LB2.get_spectra(num_eigs, 'barycentric');
    [ids, dist]         = Functional_Map.pair_wise_distortion_of_map(X, mesh1, evecs1, evecs2, evaluation_samples);                                          
    
%%
pairs = [1,2; 1,55; 1,100]';
% pairs must be passed as 2 x N
tic
D1 = comp_geodesics_pairs(inmesh.vertices(:,1), inmesh.vertices(:,2), inmesh.vertices(:,3), inmesh.triangles', pairs);
toc  
%%
sources = [1];
tic
D2 = comp_geodesics_to_all(inmesh.vertices(:,1), inmesh.vertices(:,2), inmesh.vertices(:,3), inmesh.triangles', sources);
toc