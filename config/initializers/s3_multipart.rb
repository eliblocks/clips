require "uppy/s3_multipart"

resource = Aws::S3::Resource.new(region: "us-west-1")
bucket = resource.bucket("browzable")
UPPY_S3_MULTIPART_APP = Uppy::S3Multipart::App.new(bucket: bucket)