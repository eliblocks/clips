require "shrine/storage/s3"

cache_s3_options = {
  access_key_id:     ENV["EMBEDS_AWS_ACCESS_KEY_ID"],
  secret_access_key: ENV["EMBEDS_AWS_SECRET_ACCESS_KEY"],
  region:            "us-west-1",
  bucket:            "clips-cache",
}

store_s3_options = {
  access_key_id:     ENV["EMBEDS_AWS_ACCESS_KEY_ID"],
  secret_access_key: ENV["EMBEDS_AWS_SECRET_ACCESS_KEY"],
  region:            "us-west-1",
  bucket:            "clips-store",
}

Shrine.storages = {
  cache: Shrine::Storage::S3.new(**cache_s3_options),
  store: Shrine::Storage::S3.new(**store_s3_options)
}


Shrine.plugin :activerecord
Shrine.plugin :presign_endpoint
Shrine.plugin :upload_endpoint
Shrine.plugin :restore_cached_data
Shrine.plugin :backgrounding
Shrine::Attacher.promote { |data| PromoteJobWorker.perform_async(data) }
Shrine::Attacher.delete { |data| DeleteJobWorker.perform_async(data) }
