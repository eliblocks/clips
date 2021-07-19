# Braintree::Configuration.environment = Rails.env.development? ? :sandbox : :production
#temporarily use sandbox in prod since prod is suspended
Braintree::Configuration.environment = :sandbox
Braintree::Configuration.merchant_id = Rails.configuration.braintree_id
Braintree::Configuration.public_key = Rails.configuration.braintree_public_key
Braintree::Configuration.private_key = Rails.configuration.braintree_private_key
