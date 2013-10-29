class ProposicaoRelevancia < ActiveRecord::Migration

  def change 
  	create_table :proposicao_relevancia do |t|
  	    t.integer :voto
  	    t.integer :user_id
  	    t.integer :proposicao_id
      	t.timestamps
  	end
  end

end
