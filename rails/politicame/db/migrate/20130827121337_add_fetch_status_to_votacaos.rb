class AddFetchStatusToVotacaos < ActiveRecord::Migration
  def change
    add_column :votacaos, :fetch_status, :integer, {:default => 0}
    Votacao.reset_column_information
    Votacao.all.each do |votacao|
      votacao.update_attributes!(:fetch_status => 0)
    end
  end
end
