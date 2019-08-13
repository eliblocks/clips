class Video < ApplicationRecord
  include AlgoliaSearch

  belongs_to :user
  has_many :plays
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings, dependent: :destroy

  validates :imdb_id, uniqueness: true, allow_nil: true

  scope :approved, -> { where(approved: true) }
  scope :unremoved, -> { where(removed: false) }
  scope :listed, -> { where(public: true) }
  scope :featured, -> { where(featured: true) }
  scope :movies, -> { where.not(imdb_id: nil) }
  scope :viewable, -> { unremoved.where(suspended: false) }

  algoliasearch per_environment: true do
    attribute :title, :views
    searchableAttributes ['title']
    hitsPerPage 4
    customRanking ['desc(views)']
  end

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

  def minutes
    views/60
  end

  def preview
    return image_url if image
    "jw_black.png"
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

  def mux_playback_url
    "https://stream.mux.com/#{mux_playback_id}.m3u8?token=#{self.mux_token("v")}"
  end

  def mux_token(aud)
    sign_url(
      mux_playback_id,
      aud,
      Time.now + 360000,
      Rails.configuration.mux_signing_id,
      Rails.configuration.mux_private_key
    )
  end

  def sign_url(playback_id, audience, expires, signing_key_id, private_key, params = {})
    rsa_private = OpenSSL::PKey::RSA.new(Base64.decode64(private_key))
    payload = {sub: playback_id, exp: expires.to_i, kid: signing_key_id, aud: audience}
    payload.merge!(params)
    JWT.encode(payload, rsa_private, 'RS256')
  end

  def post_to_mux(signed_url)
    HTTParty.post(
      "https://api.mux.com/video/v1/assets",
      body: { input: signed_url, playback_policy: "signed"},
      basic_auth: {
        username: Rails.configuration.mux_id,
        password: Rails.configuration.mux_secret
      }
    )
  end

  def process_with_mux(signed_url)
    response = post_to_mux(signed_url)
    if response.success? && response.parsed_response.data.status == "preparing"
      puts response
      update!(
        mux_asset_id: response.parsed_response.data.id,
        mux_playback_id: response.parsed_response.data.playback_ids.first.id
      )
    end
  end

  def get_mux_asset
    HTTParty.get("https://api.mux.com/video/v1/assets/#{mux_asset_id}", basic_auth: {
      username: Rails.configuration.mux_id,
      password: Rails.configuration.mux_secret
    })
  end

  def mux_thumbnail_url
    "https://image.mux.com/#{mux_playback_id}/thumbnail.png?token=#{mux_token("t")}"
  end

  def mux_duration(asset_response)
    asset_response.parsed_response.data.tracks.find { |track| track.type == "video" }.duration
  end

  def mux_status(asset_response)
    asset_response.parsed_response.data.status
  end
end
