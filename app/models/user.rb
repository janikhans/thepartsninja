class User < ActiveRecord::Base

  #Lets make those URLs pretty. SEO and whatnot.
  extend FriendlyId
  friendly_id :username, use: [:finders]

  acts_as_voter #Our Users have to vote afterall
  enum role: [:user, :admin]  #Basic permissions setup
  after_initialize :set_default_role, if: :new_record?

  #Associations
  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile
  has_many :products
  has_many :parts
  has_many :fitments
  has_many :discoveries
  has_many :compatibles, through: :discoveries

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :username, uniqueness: { case_sensitive: false}, presence: true, length: { in: 4..20}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255}, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validate :validate_username
  attr_accessor :login
  after_create :build_profile

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      conditions.permit! if conditions.class.to_s == "ActionController::Parameters" ##Look into this more
      where(conditions).first
    end
  end

  private

    def validate_username
      if User.where(email: username).exists?
        errors.add(:username, :invalid)
      end
    end

    def set_default_role
      self.role ||= :user
    end

    def build_profile
      Profile.create(user: self)
    end

end
