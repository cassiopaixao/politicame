class AddFetchStatusToProposicaos < ActiveRecord::Migration
  def change
    add_column :proposicaos, :fetch_status, :integer, {:default => 0}
    Proposicao.reset_column_information
    Proposicao.all.each do |proposicao|
      proposicao.update_attributes!(:fetch_status => 0)
    end
  end
end
