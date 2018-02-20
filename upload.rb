# require 'aws-sdk-s3'

# s3 = Aws::S3::Resource.new(region: 'us-west-1');
# obj = s3.bucket('browzable-movies-input').object('Sintel.mov')

# drive = '/volumes/IEP_Masters/Invincible_Entertainment_Partners'

# puts "Starting: #{Time.now}"
# obj.upload_file('/Users/eli/Downloads/Yoga_Hosers_Trailer.mov')
# puts "Completed: #{Time.now}"


require 'fog'

connection = Fog::Storage.new({
  :provider                 => 'AWS',
  :aws_access_key_id        => ENV['AWS_ACCESS_KEY_ID'],
  :aws_secret_access_key    => ENV['AWS_SECRET_ACCESS_KEY'],
  :region => 'us-west-1'
})

directory = connection.directories.get('browzable-movies-input')

Dir.glob('/volumes/IEP_Masters/masters/*').each do |path|
  puts "starting #{path} at #{Time.now}"

  file = directory.files.create(key: path.gsub(/\/.*\//, ''),
                                body: File.open(path),
                                multipart_chunk_size: 16777216)

  puts "completed #{path} at #{Time.now}"
end
