class Video < ApplicationRecord
  # include ClipUploader[:clip]
  # include AlgoliaSearch

  belongs_to :account
  has_many :plays
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings, dependent: :destroy

  delegate :user, to: :account

  validates :imdb_id, uniqueness: true, allow_nil: true

  scope :approved, -> { where(approved: true) }
  scope :unremoved, -> { where(removed: false) }
  scope :listed, -> { where(public: true) }
  scope :featured, -> { where(featured: true) }
  scope :movies, -> { where.not(imdb_id: nil) }
  scope :viewable, -> { unremoved.where(suspended: false) }

  # algoliasearch per_environment: true do
  #   attribute :title, :views
  #   searchableAttributes ['title']
  #   hitsPerPage 4
  #   customRanking ['desc(views)']
  # end


  def s3_key
    storage_url[/\w{20,}.*/]
  end

  def storage_id
    s3_id || clip.id
  end

  def self.tagged_with(name)
    Tag.find_by_name!(name).videos
  end

  def self.tag_counts
    Tag.select("tags.*, count(taggings.tag_id) as count").
    joins(:taggings).group("taggings.tag_id")
  end

  def tag_list
    tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end

  def imdb_attrs
    response = HTTParty.get("http://www.omdbapi.com/?i=tt#{imdb_id}&apikey=#{ENV['OMDB_KEY']}")
    parsed_response = response.parsed_response
    attrs = {
      title: parsed_response['Title'],
      published_at: parsed_response['Released'],
      rating: parsed_response['Rated'],
      image: parsed_response['Poster'],
      runtime: parsed_response['Runtime'],
      director: parsed_response['Director'],
      description: parsed_response['Plot'],
      language:  parsed_response['Language']
    }
    genres = parsed_response['Genre']
    [attrs, genres]
  end

  def update_from_omdb
    attrs = imdb_attrs
    puts "updating #{attrs[0][:title]}"
    video_attrs = attrs[0]
    image_from_tmdb = tmdb_image
    video_attrs.merge!({image: image_from_tmdb}) if image_from_tmdb
    genres = attrs[1]
    update!(video_attrs)
    self.tag_list = genres if genres
  end

  def movie_rating
    rating == "N/A" ? "Unrated" : rating
  end

  def tmdb_image
    base_url = "https://image.tmdb.org/t/p/"
    size = "w370_and_h556_bestv2"
    path = tmdb_image_path
    path.nil? ? nil : base_url + size + path
  end

  def tmdb_image_path
    response = HTTParty.get("https://api.themoviedb.org/3/find/tt#{imdb_id}?api_key=#{ENV['TMDB_SECRET']}&language=en-US&external_source=imdb_id")
    movie_results = response.parsed_response['movie_results']
    movie_results.empty? ? nil : movie_results[0]['poster_path']
  end

  def signed_cloudfront_url
    signer = Aws::CloudFront::UrlSigner.new(
      key_pair_id: Rails.application.credentials.cloudfront_key_id,
      private_key: Rails.application.credentials.cloudfront_private_key
    )
    url = signer.signed_url(cloudfront_url, policy: policy.to_json)
  end

  def cloudfront_url
    "https://media.browzable.com/#{storage_id}"
  end

  def policy
    {
      "Statement" => [
        {
           "Resource" => cloudfront_url,
           "Condition" => {
              "DateLessThan" => {
                 "AWS:EpochTime" => 1.days.from_now.to_i
              }
           }
        }
      ]
    }
  end

  def remove
    update(removed: true, approved: false, featured: false)
  end

  def suspend
    update(approved: false, suspended: true, featured: false)
  end

  def approve
    update(approved: true, suspended: false)
  end

  def feature
    update(approved: true, suspended: false, featured: true)
  end


  def remove_or_destroy
    plays.any? ? remove : destroy
  end

  def delete_plays_and_destroy
    plays.all.each(&:destroy)
    self.destroy
  end

  def update_views(play)
    new_views = views + play.duration
    update(views: new_views)
  end

  def image_id
    image.split('/')[1]
  end

  def image_version
    image.split('/')[0]
  end

  def self.cl_base_url
    "https://res.cloudinary.com/eli/image/upload"
  end

  def image_url
    "#{Video.cl_base_url}/#{image_id}"
  end

  # def duration
  #   return 0 unless clip && clip.metadata['duration']
  #   clip.metadata['duration'].round
  # end

  def minutes
    views/60
  end

  def preview
    if image
      image_url
    else
      "jw_black.png"
    end
  end

  def seconds_played
    plays.sum(:duration) || 0
  end

  def s3_download_url
    presigner = Aws::S3::Presigner.new(client: Aws::S3::Client.new)
    presigner.presigned_url(
      "get_object",
      key: s3_key,
      bucket: "browzable"
    )
  end
end
