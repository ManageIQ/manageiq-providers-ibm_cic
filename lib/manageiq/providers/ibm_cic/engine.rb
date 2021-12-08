module ManageIQ
  module Providers
    module IbmCic
      class Engine < ::Rails::Engine
        isolate_namespace ManageIQ::Providers::IbmCic

        config.autoload_paths << root.join('lib').to_s

        initializer :append_secrets do |app|
          app.config.paths["config/secrets"] << root.join("config", "secrets.defaults.yml").to_s
          app.config.paths["config/secrets"] << root.join("config", "secrets.yml").to_s
        end

        def self.vmdb_plugin?
          true
        end

        def self.plugin_name
          _('Ibm Cic Provider')
        end

        def self.init_loggers
          $ibm_cic_log ||= Vmdb::Loggers.create_logger("ibm_cic.log")
        end

        def self.apply_logger_config(config)
          Vmdb::Loggers.apply_config_value(config, $ibm_cic_log, :level_ibm_cic)
        end
      end
    end
  end
end
