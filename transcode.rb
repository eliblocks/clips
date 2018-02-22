require 'aws-sdk-s3'
require 'aws-sdk-mediaconvert'

s3 = Aws::S3::Resource.new(region: 'us-west-1')

input_bucket = s3.bucket('browzable-movies-input')
output_bucket = s3.bucket('browzable-movies-output')
job_template = "arn:aws:mediaconvert:us-west-1:121996608541:jobTemplates/hq_only"
queue = "arn:aws:mediaconvert:us-west-1:121996608541:queues/Default"
role = "arn:aws:iam::121996608541:role/media-convert"
input_key = "White Raven_1080_ProRes_6channel.mov"
file_input = "s3://#{input_bucket.name}/#{input_key}"



client = Aws::MediaConvert::Client.new
resp = client.describe_endpoints(max_results: 1)
endpoint = resp.endpoints[0].url
client = Aws::MediaConvert::Client.new(endpoint: endpoint)

job = {
  job_template: job_template,
  queue: queue,
  role: role,
  settings: {
    inputs: [
      file_input: file_input
    ]
  }
}

puts client.create_job(job)
