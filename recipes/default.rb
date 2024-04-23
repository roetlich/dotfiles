# Description: This recipe creates symlinks for dotfiles in your home directory.

# Define a hash where the keys are directories in your dotfiles repo and the values are corresponding
# paths in your home directory.
mappings = {
  "doom" => ".doom.d",
  #"dir2" => ".dir2_path"
  # Add more mappings as needed.
}

# Loop over each item in the mappings.
mappings.each do |src, dst|

  # Construct full path for both the source and destination.
  source_file = "#{ENV['HOME']}/dotfiles/#{src}"
  destination_file = "#{ENV['HOME']}/#{dst}"

  # Use Chef's link resource to create the symlink.
  link destination_file do
    to source_file
    only_if do
      if ::File.symlink?(destination_file) || !::File.exist?(destination_file)
        true
      else
        Chef::Log.fatal("Destination file: #{destination_file} already exists as non-symlink - skipping")
        false
      end
    end
  end

end
