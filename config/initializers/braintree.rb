Braintree::Configuration.environment = Rails.env.development? ? :sandbox : :production
Braintree::Configuration.merchant_id = Rails.application.credentials.braintree_id
Braintree::Configuration.public_key = Rails.application.credentials.braintree_public_key
Braintree::Configuration.private_key = Rails.application.credentials.braintree_private_key
