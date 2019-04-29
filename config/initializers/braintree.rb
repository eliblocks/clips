Braintree::Configuration.environment = Rails.env.development? ? :sandbox : :production
Braintree::Configuration.merchant_id = Rails.configuration.braintree_id
Braintree::Configuration.public_key = Rails.configuration.braintree_public_key
Braintree::Configuration.private_key = Rails.configuration.braintree_private_key
