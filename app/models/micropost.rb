class Micropost < ApplicationRecord
  belongs_to :user
  default_scope ->{order(created_at: :desc)}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.micropost.content.maximum}
  validate :picture_size

  private

  def picture_size
    return unless picture.size > 5.megabytes
    errors.add :picture, t("micropost.attributes.picture.size_warning")
  end
end
