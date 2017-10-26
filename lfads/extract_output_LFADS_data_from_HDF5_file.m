function data_structure = extract_output_LFADS_data_from_HDF5_file(HDF5_output_filename)
%function data_structure = extract_output_LFADS_data_from_HDF5_file(HDF5_output_filename)
%
% Takes the output HDF5 file produced by LFADS after running it in output sampling mode 
% (i.e. with flag --kind=posterior_sample_and_average) and parses it into a structure with double fields to be used in Matlab. 
%
% % INPUTS
%
% HDF5_output_filename - the name of the HDF5 file created by LFADS to be parsed
%
% % OUTPUTS
% 
% data_structure - a Matlab structure with the following fields (all in double format):
%
%          data_structure.denoised_firing_rates 
%                      Nneurons x Nbins x Ntrials of inferred firing rates for all trials
%
%          data_structure.inferred_ext_input_histories 
%                      Ninputs x Nbins x Ntrials of inferred external input histories for all trials
%
%          data_structure.mean_inferred_g0_distrib
%                      g0Size x Ntrials of estimated initial mean of the inferred initial state g0 for all trials  
%
%          data_structure.logvar_inferred_g0_distrib
%                      g0Size x Ntrials of estimated initial (log) variance of the inferred initial state g0 for all trials         
%
%           data_structure.std_inferred_g0_distrib
%                      g0Size x Ntrials of estimated initial std of the inferred initial state g0 for all trials   
%
%          data_structure.mean_prior_g0_distrib (optional)
%          data_structure.logvar_prior_g0_distrib (optional)
%          data_structure.std_prior_g0_distrib (optional)
%                      same as the fields above, but priors for comparison
%
%          data_structure.inferred_factors_histories 
%                      Nfactors x Nbins x Ntrials of inferred factors histories for all trials
%
%          data_structure.inferred_generator_states 
%                      Ngenerator_units x Nbins x Ntrials of inferred generator state histories for all trials
%
%          data_structure.inferred_generator_ics
%                      Ngenerator_units x Ntrials of inferred generator units ics for all trials
%
%          data_structure.costs
%                      Ntrials vector with the cost for each trial    
%
%          data_structure.train_steps
%                      Ntrials vector with the train steps for each trial    
%
%          data_structure.nll_bound_vaes
%                      Ntrials vector with the nll bound vaes for each trial   
%
%          data_structure.nll_bound_iwaes
%                      Ntrials vector with the nll bound iwaes for each trial    
%
% Matteo Mischiati  
% October 2017


data_structure.denoised_firing_rates = double(h5read(HDF5_output_filename,'/output_dist_params'));

data_structure.inferred_ext_input_histories = double(h5read(HDF5_output_filename,'/controller_outputs'));

data_structure.mean_inferred_g0_distrib = double(h5read(HDF5_output_filename,'/post_g0_mean'));
data_structure.logvar_inferred_g0_distrib = double(h5read(HDF5_output_filename,'/post_g0_logvar'));
data_structure.std_inferred_g0_distrib = sqrt(exp(data_structure.logvar_inferred_g0_distrib));

data_structure.mean_prior_g0_distrib = double(h5read(HDF5_output_filename,'/prior_g0_mean'));
data_structure.logvar_prior_g0_distrib = double(h5read(HDF5_output_filename,'/prior_g0_logvar'));
data_structure.std_prior_g0_distrib = sqrt(exp(data_structure.logvar_prior_g0_distrib));

data_structure.inferred_factors_histories = double(h5read(HDF5_output_filename,'/factors'));

data_structure.inferred_generator_states = double(h5read(HDF5_output_filename,'/gen_states'));

data_structure.inferred_generator_ics = double(h5read(HDF5_output_filename,'/gen_ics'));


data_structure.costs = double(h5read(HDF5_output_filename,'/costs'));

data_structure.train_steps = double(h5read(HDF5_output_filename,'/train_steps'));

data_structure.nll_bound_vaes = double(h5read(HDF5_output_filename,'/nll_bound_vaes'));

data_structure.nll_bound_iwaes = double(h5read(HDF5_output_filename,'/nll_bound_iwaes'));

return;
    