
module XCRes
      module ResourcesAnalyzer
            class ImageHelper

                  # Find image files in a given list of file paths
                  #
                  # @param  [Array<Pathname>] file_paths
                  #         the list of files
                  #
                  # @return [Array<Pathname>]
                  #         the filtered list
                  #
                  def find_image_files file_paths
                        file_paths.select { |path| path.to_s.match /\.(png|jpe?g|gif)$/ }
                  end
            end
      end
end