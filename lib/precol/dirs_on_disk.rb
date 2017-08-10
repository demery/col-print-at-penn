module Precol
  class DirsOnDisk
    def initialize path_list
      @path_list = path_list
    end

    def matches book_data
      m = @path_list.grep(/#{book_data.file_name}$/)
      return m unless m.empty?
      m = @path_list.grep(/#{book_data.file_name_for_item}$/)
      return m unless m.empty?
      @path_list.grep(/#{book_data.file_name.gsub(/_/, '')}$/)
    end

    def on_disk? paths
      paths.all? { |p| @path_list.grep(/#{p}$/) }
    end
  end
end
