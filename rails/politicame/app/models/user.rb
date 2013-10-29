class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # :recoverable, :validatable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_many :voto_users
  has_many :proposica_relevancia

  validates_presence_of :email, :message => 'Um e-mail deve ser informado'
  validates_uniqueness_of :email, :message => 'E-mail já cadastrado no sistema'
  validates_presence_of :password, :on => :create, :message => 'Uma senha deve ser informada'
  validates_confirmation_of :password, :message => 'A senha repetida não coincide com a informada'

end
