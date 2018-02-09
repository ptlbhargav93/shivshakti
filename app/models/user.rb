class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  enum role: ['EXECUTIVE', 'STAFF']

  has_many :income_expenses, inverse_of: :user
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"
  belongs_to :updater, class_name: "User", foreign_key: "updater_id"

  include HasResources
  
  validates :first_name, :presence => true, :length => {:maximum => 255}
  validates :last_name, :presence => true, :length => {:maximum => 50}
  
  validates_presence_of   :email, :length => {:maximum => 15, :allow_blank => true}, if: :email_required?
  validates_format_of     :email, :with => Devise.email_regexp, :allow_blank => true, :if => :email_changed?
  
  validates_presence_of     :password, if: :password_required?
  validates_confirmation_of :password, if: :password_required?
  validates_presence_of     :password_confirmation, if: :password_required?
  validates_length_of       :password, within: Devise.password_length, allow_blank: true
    
  scope :executives, -> { where('users.role = ?', User.roles['EXECUTIVE']) }
  scope :staffs, -> { where('users.role = ?', User.roles['STAFF']) }

  default_scope {where(is_deleted: false)}
  
  def executive?
    role == 'EXECUTIVE'
  end

  def staff?
    role == 'STAFF'
  end  

  def name
    first_name.to_s + " " + last_name.to_s
  end

  def email_required?
    true
  end

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end