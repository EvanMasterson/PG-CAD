class ImageUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  after :remove, :delete_empty_upstream_dirs # Clean up empty directories when the files in them are deleted

  # Choose what kind of storage to use for this uploader:
  # storage :file
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.unique_url}"
  end

  def delete_empty_upstream_dirs
    path = ::File.expand_path(store_dir, root)
    Dir.delete(path) # fails if path not empty dir, beware ".DS_Store" when in development
  rescue SystemCallError
    true # nothing, the dir is not empty
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
   def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   #ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
    "default.png"
   end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb, :if => :image? do
    process :resize_to_fit => [500, 500]
  end

  protected
  def image?(new_file)
    new_file.content_type.start_with? 'image'
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
   def extension_whitelist
     %w(jpg jpeg gif png mp4 mov pdf doc xls)
   end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end
