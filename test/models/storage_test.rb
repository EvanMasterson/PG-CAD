require 'test_helper'

class StorageTest < ActiveSupport::TestCase
  test "when files do not exist it should calculate storage size as 0" do
    @storage = storages(:one)
    @storage.uploaded_files = []
    
    assert_equal(0, @storage.calculate_storage_size)
  end

  test "when files exist it should calculate correct storage size" do
    @storage = storages(:one)
    @storage.uploaded_files = [uploaded_files(:one), uploaded_files(:two)]
    
    assert_equal(123456, @storage.calculate_storage_size)
  end
end
