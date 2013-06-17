if defined? Kaminari
  module Kaminari::Helpers
    module SinatraHelpers
      
      class ActionViewTemplateProxy
        def render(*args)
          base = ActionView::Base.new.tap do |a|
            a.view_paths << File.expand_path("#{ActivateAdmin.root}/lib", __FILE__)
          end
          base.render(*args)
        end      
      end
    
      def page_entries_info(collection, options = {})
        entry_name = if options[:entry_name]
          options[:entry_name]
        elsif collection.empty? || collection.is_a?(Array)
          'entry'
        else
          if collection.respond_to? :model  # DataMapper
            collection.model.model_name.human.downcase
          else  # AR
            collection.model_name.human.downcase
          end
        end
        entry_name = entry_name.pluralize unless collection.total_count == 1

        if collection.total_pages < 2
          t('helpers.page_entries_info.one_page.display_entries', :entry_name => entry_name, :count => collection.total_count)
        else
          first = collection.offset_value + 1
          last = collection.last_page? ? collection.total_count : collection.offset_value + collection.limit_value
          t('helpers.page_entries_info.more_pages.display_entries', :entry_name => entry_name, :first => first, :last => last, :total => collection.total_count)
        end.html_safe
      end
      
      module HelperMethods
        def paginate(scope, options = {}, &block)
          current_path = env['REQUEST_PATH'] rescue nil
          current_params = Rack::Utils.parse_query(env['QUERY_STRING']).symbolize_keys rescue {}
          paginator = Kaminari::Helpers::Paginator.new(
            ActionViewTemplateProxy.new(:current_params => current_params, :current_path => current_path, :param_name => options[:param_name] || Kaminari.config.param_name),
            options.reverse_merge(:current_page => scope.current_page, :total_pages => scope.total_pages, :per_page => scope.limit_value, :param_name => Kaminari.config.param_name, :remote => false)
          )
          paginator.to_s
        end     
      end
      
    end
  end
end