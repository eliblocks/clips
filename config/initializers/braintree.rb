Braintree::Configuration.environment = Rails.application.development? ? :sandbox : :production
Braintree::Configuration.merchant_id = Rails.application.credentials.braintree_id
Braintree::Configuration.public_key = Rails.application.credentials.braintree_public_key
Braintree::Configuration.private_key = Rails.application.credentials.private_key
