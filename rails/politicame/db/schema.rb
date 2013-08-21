# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130821000435) do

  create_table "proposicaos", :force => true do |t|
    t.string   "tipo"
    t.integer  "numero"
    t.integer  "ano"
    t.string   "autor_nome"
    t.string   "autor_partido"
    t.string   "autor_uf"
    t.integer  "qtd_autores"
    t.datetime "data_apresentacao"
    t.string   "ementa"
    t.string   "ementa_explicacao"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "subscriptions", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "subscribed_at"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.datetime "unsubscribed_at"
  end

  create_table "votacaos", :force => true do |t|
    t.string   "resumo"
    t.datetime "data_hora"
    t.string   "obj_votacao"
    t.boolean  "master",        :default => false
    t.integer  "proposicao_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "voto_deputados", :force => true do |t|
    t.string   "nome"
    t.string   "partido"
    t.string   "uf"
    t.integer  "voto"
    t.integer  "votacao_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
