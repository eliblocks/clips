Aws.config.update({
  credentials: Aws::Credentials.new(
    Rails.application.credentials.aws_storage_access_key_id, 
    Rails.application.credentials.aws_storage_secret_access_key
  )
})