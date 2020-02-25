# I18n.load_path += Dir[Rails.root.join('config', 'locale', '*.{rb,yml}')]
I18n.available_locales = %i[ru en]
I18n.default_locale = :ru

# NOTE: Just for testing purposes
# I18nSimpleBackend = I18n::Backend::Simple.new
# I18n.exception_handler = lambda do |exception, locale, key, options|
#   case exception
#   when I18n::MissingTranslationData
#     I18nSimpleBackend.translate(:en, key, options || {})
#   else
#     raise exception
#   end
# end
