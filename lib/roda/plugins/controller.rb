# frozen_string_literal: true

require "roda/plugins/controller/version"

class Roda
  module RodaPlugins
    module Controller
      DEFAULTS = {
        registered_controllers: {},
        inject: nil,
        args: nil
      }

      def self.configure(app, opts={}, &block)
        plugin_opts = (app.opts[:controller] ||= DEFAULTS)

        app.opts[:controller] = plugin_opts.merge(opts)

        app.register_controller(opts[:controllers]) if opts[:controllers]
      end

      def self.underscore(name, acronym_regex: /(?=a)b/)
        return name unless name =~ /[A-Z-]|::/

        name.gsub!(/Controller$/, "")

        word = name.to_s.gsub("::", "/")
        word.gsub!(/(?:(?<=([A-Za-z\d]))|\b)(#{acronym_regex})(?=\b|[^a-z])/) { "#{$1 && '_' }#{$2.downcase}" }
        word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
        word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
        word.tr!("-", "_")
        word.downcase!
        word
      end

      module ClassMethods
        def register_controller(*args)
          controllers = opts[:controller][:registered_controllers]

          if args.size == 2
            controller_key, controller = args

            controllers.merge! controller_key.to_sym => controller
          elsif args.size == 1
            controller = args[0]

            if controller.kind_of? Hash
              controllers.merge!(controller)
            elsif controller.kind_of? Array
              controller.each {|c| register_controller(c) }
            elsif controller.kind_of? Class
              register_controller(Controller.underscore(controller.name), controller)
            end
          end
        end
      end

      module InstanceMethods
        def dispatch(to, args: nil, inject: nil)
          controller_key, action = to.to_s.split('#')
          controllers = opts[:controller][:registered_controllers]
          controller = controllers[controller_key.to_sym]

          inject ||= opts[:controller][:inject]

          if inject.respond_to?(:to_proc)
            controller_args = Array(instance_exec(&inject))
          else
            controller_args = Array(inject)
          end

          if controller.respond_to?(:to_proc)
            controller = controller.to_proc.call(*controller_args)
          elsif controller.kind_of?(Class)
            controller = controller.new(*controller_args)
          end

          response = controller.send(action, *Array(args))

          responds_with = controller.instance_variable_get(:@responds_with)
          responds_with ||= {}

          responds_with.each do |var, val|
            ivar = :"@#{var}"

            if !instance_variable_defined?(ivar)
              instance_variable_set(ivar, val)
            end
          end

          response
        end

        def controller(to, args: nil, inject: nil)
          controller_key, action = to.to_s.split('#')

          result = dispatch(to, args: args, inject: inject)

          view("#{controller_key}/#{action}")

          result
        end
      end
    end

    register_plugin(:controller, Controller)
  end
end
