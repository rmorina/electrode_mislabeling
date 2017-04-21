% test_generate_forward_model
for i = 20:20
    eeg_location = generateEEGLocation(i);
    depth_electrode_location = generateSEEGLocation(3);
    A = generateForwardModel(depth_electrode_location, eeg_location);
end