module DynamicSitemaps
  class Generator
    class << self
      def generate
        instance_eval open(DynamicSitemaps.config_path).read
        generate_index
        ap sitemaps
      end

      def generate_index
        # TODO based on #sitemaps
      end

      def sitemap(*args, &block)
        args << {} unless args.last.is_a?(Hash)
        args.last[:host] ||= host
        args.last[:folder] ||= folder
        sitemap = Sitemap.new(*args, &block)
        sitemaps << SitemapGenerator.new(sitemap).generate
      end

      # Array of SitemapResult
      def sitemaps
        @sitemaps ||= []
      end

      def host(*args)
        if args.any?
          @host = args.first
          Rails.application.routes.default_url_options[:host] = @host
        else
          @host
        end
      end

      def folder(*args)
        if args.any?
          @folder = args.first
          raise ArgumentError, "Folder can't be blank." if @folder.blank?

          FileUtils.rm_rf "#{DynamicSitemaps.path}/#{folder}"
        else
          # Ensure that the default folder is set and cleaned.
          folder DynamicSitemaps.folder if @folder.blank?

          @folder
        end
      end
    end
  end
end