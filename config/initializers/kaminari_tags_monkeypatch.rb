module Kaminari
  module Helpers
    class Tag
      def initialize(template, options = {}) #:nodoc:
        @template, @options = template, options.dup
        #make param name available in template
        @param_name = @options[:param_name]
        @theme = @options[:theme] ? "#{@options.delete(:theme)}/" : ''
        @params = @options[:params] ? template.params.merge(@options.delete :params) : template.params
      end
    end
  end
end
