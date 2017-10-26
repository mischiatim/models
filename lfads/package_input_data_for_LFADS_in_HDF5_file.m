function package_input_data_for_LFADS_in_HDF5_file(data_structure,output_filename)
%function package_input_data_for_LFADS_in_HDF5_file(data_structure,output_filename)
%
% Packages all data required for LFADS execution from the Matlab structure
% 'data_structure' into an HDF5 file 'output_filename' that can be actually
% passed to LFADS. A critical step is typecasting of the variables in a
% manner compatible with LFADS execution. 
%
% % INPUTS
% 
% data_structure - a Matlab structure with the necessary and optional fields for LFADS:
%
%          data_structure.train_data (this is the only strictly necessary field)
%                      Nneurons x Nbins x Ntrain_trials of binned spike count for all training trials
%
%          data_structure.valid_data (this is not strictly necessary, but highly recommended)
%                      Nneurons x Nbins x Nvalid_trials of binned spike count for all validation trials
%
%          data_structure.train_ext_input (optional)
%                      Ninputs x Nbins x Ntrain_trials of known external input history (e.g. perturbation) for all training trials  
%
%          data_structure.valid_ext_input (optional)
%                      Ninputs x Nbins x Ntrain_trials of known external input history (e.g. perturbation) for all validation trials        
%
%          data_structure.alignment_matrix_cxf (optional)
%                      Nneurons x Nfactors matrix (only for datasets corresponding
%                      to multisession modeling). Here Nfactors is number
%                      of factors to be learnt (common to all sessions)
%
%          data_structure.alignment_bias_c (optional)
%                      Nfactors column vector (see previous field) but with the bias for each dataset (if belonging to multisession modeling).
% 
%          data_structure.bin_size_ms (optional)
%                      The size in ms of the bin size used to bin the spike counts.
%
% output_filename - the name of the HDF5 file to be created by the script
%
% 
% % OUTPUTS
% None
%
%
% Matteo Mischiati  
% October 2017

if isfield(data_structure,'train_data') 
    
    train_data = data_structure.train_data;
    
    Nneurons = size(train_data,1);
    Nbins = size(train_data,2);
    Ntrain_trials = size(train_data,3);
    
    if Nneurons > 0
        h5create(output_filename,'/train_data',[Nneurons Nbins Ntrain_trials],'DataType','int32');
        h5write(output_filename,'/train_data',int32(train_data));
        %hdf5write(output_filename, '/train_data', int32(train_data), 'WriteMode','overwrite');
    else
        fprintf('\n Could not generate HDF5 file: the training data field is empty. \n');
    end;
  
    if isfield(data_structure,'valid_data') 
        
        valid_data = data_structure.valid_data;
        
        if ((size(valid_data,1)==Nneurons) && (size(valid_data,2)==Nbins))
            
            Nvalid_trials = size(valid_data,3);
            
            h5create(output_filename,'/valid_data',[Nneurons Nbins Nvalid_trials],'DataType','int32');
            h5write(output_filename,'/valid_data',int32(valid_data));
            %hdf5write(output_filename, '/valid_data', int32(valid_data), 'WriteMode','append');
            
        else
            fprintf('\n Could not include valid data in HDF5 file: the dimensions were wrong. \n');
            Nvalid_trials = 0;
        end;
        
    else
        Nvalid_trials = 0;
            
    end;
    
    if isfield(data_structure,'train_ext_input') 
        
        train_ext_input = data_structure.train_ext_input;
        N_ext_inputs = size(train_ext_input,1);
        
        if ((size(train_ext_input,2)==Nbins) && (size(train_ext_input,3)==Ntrain_trials))

            h5create(output_filename,'/train_ext_input',[N_ext_inputs Nbins Ntrain_trials],'DataType','double');
            h5write(output_filename,'/train_ext_input',double(train_ext_input));
            %hdf5write(output_filename, '/train_ext_input', double(train_ext_input), 'WriteMode','append');
            
        else
            fprintf('\n Could not include train ext input data in HDF5 file: the dimensions were wrong. \n');
            N_ext_inputs = 0;
        end;
        
    else
        N_ext_inputs = 0;
            
    end;
    
    if isfield(data_structure,'valid_ext_input') 
        
        valid_ext_input = data_structure.valid_ext_input;
        
        if ((size(valid_ext_input,1)==N_ext_inputs) && (size(valid_ext_input,2)==Nbins) && (size(valid_ext_input,3)==Nvalid_trials))

            h5create(output_filename,'/valid_ext_input',[N_ext_inputs Nbins Nvalid_trials],'DataType','double');
            h5write(output_filename,'/valid_ext_input',double(valid_ext_input));
            %hdf5write(output_filename, '/valid_ext_input', double(valid_ext_input), 'WriteMode','append');
            
        else
            fprintf('\n Could not include valid ext input data in HDF5 file: the dimensions were wrong. \n');
        end;
            
    end;
    
    if isfield(data_structure,'alignment_matrix_cxf') 
        
        alignment_matrix_cxf = data_structure.alignment_matrix_cxf;
        Nfactors_multisess = size(alignment_matrix_cxf,2);
        
        if (size(alignment_matrix_cxf,1)==Nneurons)
            
            h5create(output_filename,'/alignment_matrix_cxf',[Nneurons Nfactors_multisess],'DataType','double');
            h5write(output_filename,'/alignment_matrix_cxf',double(alignment_matrix_cxf));
            %hdf5write(output_filename, '/alignment_matrix_cxf', double(alignment_matrix_cxf), 'WriteMode','append');
            
        else
            fprintf('\n Could not include alignment matrix cxf in HDF5 file: the dimensions were wrong. \n');
        end;
        
    else
        Nfactors_multisess = 0;
            
    end;
    
    if isfield(data_structure,'alignment_bias_c') 
        
        alignment_bias_c = data_structure.alignment_bias_c;
        
        if (size(alignment_bias_c,1)==Nfactors_multisess)
            
            h5create(output_filename,'/alignment_bias_c',[Nfactors_multisess 1],'DataType','double');
            h5write(output_filename,'/alignment_bias_c',double(alignment_bias_c));
            %hdf5write(output_filename, '/alignment_bias_c', double(alignment_bias_c), 'WriteMode','append');
            
        else
            fprintf('\n Could not include alignment bias c in HDF5 file: the dimensions were wrong. \n');
        end;
            
    end;
    
    if isfield(data_structure,'bin_size_ms') 
        
        bin_size_ms = data_structure.bin_size_ms;
        
        if (size(bin_size_ms,1)==1)
            
            h5create(output_filename,'/bin_size_ms',1,'DataType','double');
            h5write(output_filename,'/bin_size_ms',double(bin_size_ms));
            %hdf5write(output_filename, '/bin_size_ms', double(bin_size_ms), 'WriteMode','append');
            
        else
            fprintf('\n Could not include bin size in HDF5 file: the dimensions were wrong. \n');
        end;
        
    end;
    
else
    
    fprintf('\n Could not generate HDF5 file: the training data field is missing. \n');
    
end;
    