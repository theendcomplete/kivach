# https://guides.rubyonrails.org/security.html#content-security-policy
Rails.application.config.content_security_policy do |policy|
  policy.default_src :self, :https
  policy.font_src    :self, :https, :data
  policy.img_src     :self, :https, :data
  policy.object_src  :none
  policy.script_src  :self, :https
  policy.style_src   :self, :https

  # Specify URI for violation reports
  # policy.report_uri "/csp-violation-report-endpoint"
end
