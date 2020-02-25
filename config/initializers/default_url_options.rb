Rails.application.routes.draw do
  default_url_options protocol: Rails.application.config.primary_protocol
end
