require 'i18n/backend/pluralization'

module I18n
  module Backend
    class DiscourseI18n < I18n::Backend::Simple
      include I18n::Backend::Fallbacks
      include I18n::Backend::Pluralization

      def available_locales
        # in case you are wondering this is:
        # Dir.glob( File.join(Rails.root, 'config', 'locales', 'client.*.yml') )
        #    .map {|x| x.split('.')[-2]}.sort
        LocaleSiteSetting.supported_locales.map(&:to_sym)
      end

      def reload!
        @overrides = {}
        @pluralizers = {}
        super
      end

      # force explicit loading
      def load_translations(*filenames)
        unless filenames.empty?
          filenames.flatten.each { |filename| load_file(filename) }
        end
      end

      def fallbacks(locale)
        [locale, SiteSetting.default_locale.to_sym, :en].uniq.compact
      end

      def exists?(locale, key)
        fallbacks(locale).each do |fallback|
          begin
            return true if super(fallback, key)
          rescue I18n::InvalidLocale
            # we do nothing when the locale is invalid, as this is a fallback anyways.
          end
        end

        false
      end

      def search(locale, query)
        results = {}

        fallbacks(locale).each do |fallback|
          find_results(/#{query}/i, results, translations[fallback])
        end

        results
      end

      protected
        def find_results(regexp, results, translations, path=nil)
          return results if translations.blank?

          translations.each do |k_sym, v|
            k = k_sym.to_s
            key_path = path ? "#{path}.#{k}" : k
            if v.is_a?(String)
              unless results.has_key?(key_path)
                results[key_path] = v if key_path =~ regexp || v =~ regexp
              end
            elsif v.is_a?(Hash)
              find_results(regexp, results, v, key_path)
            end
          end
          results
        end

        # Support interpolation and pluralization of overrides by first looking up
        # the original translations before applying our overrides.
        def lookup(locale, key, scope = [], options = {})
          existing_translations = super(locale, key, scope, options)

          if options[:overrides] && existing_translations
            if options[:count]

              remapped_translations =
                if existing_translations.is_a?(Hash)
                  Hash[existing_translations.map { |k, v| ["#{key}.#{k}", v] }]
                elsif existing_translations.is_a?(String)
                  Hash[[[key, existing_translations]]]
                end

              result = {}

              remapped_translations.merge(options[:overrides]).each do |k, v|
                result[k.split('.').last.to_sym] = v if k != key && k.start_with?(key.to_s)
              end
              return result if result.size > 0
            end

            return options[:overrides][key] if options[:overrides][key]
          end

          existing_translations
        end

    end
  end
end
