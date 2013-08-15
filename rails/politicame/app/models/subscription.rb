class Subscription < ActiveRecord::Base
  attr_accessible :id, :email, :name, :subscribed_at, :unsubscribed_at
  
  validate :validate_email
  
  # this just work because there aren't updates, just new subscriptions
  def validate_email
    self.email = self.email.downcase.rstrip if !self.email.nil?
    errors.add :email, 'E-mail deve ser preenchido' if self.email.nil? or self.email.empty?
    errors.add :email, 'E-mail já cadastrado' if !Subscription.find_by_email(self.email).nil?
    errors.add :email, 'E-mail invalido' if /^([^@\s]+)@(([-a-z0-9]+\.)+[a-z]{2,})$/.match(self.email).nil?
  end
end
