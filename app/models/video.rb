class Video < ApplicationRecord
  include ClipUploader[:clip]
  include AlgoliaSearch

  belongs_to :user
  has_many :plays

  scope :approved, -> { where(approved: true) }
  scope :unremoved, -> { where(removed: false) }
  scope :listed, -> { where(public: true) }
  scope :featured, -> { where(featured: true) }
  scope :movies, -> { where.not(imdb_id: nil)}

  algoliasearch per_environment: true do
    attribute :title, :views
    searchableAttributes ['title']
    hitsPerPage 4
    customRanking ['desc(views)']
  end

  def signed_cloudfront_url
    signer = Aws::CloudFront::UrlSigner.new(
      key_pair_id: ENV["CLOUDFRONT_KEY_ID"],
      private_key: ENV["CLOUDFRONT_PRIVATE_KEY"]
    )
    url = signer.signed_url(cloudfront_url, policy: policy.to_json)
  end

  def cloudfront_url
    domain_id = ENV["CLIPS_CLOUDFRONT_DOMAIN_ID"]
    "https://#{domain_id}.cloudfront.net/#{clip.id}"
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

  def remove_or_destroy
    plays.any? ? remove : destroy
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

  def duration
    return 0 unless clip.metadata['duration']
    clip.metadata['duration'].round
  end

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
end
