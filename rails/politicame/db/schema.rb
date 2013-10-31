# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20131031181346) do

  create_table "data_requests", :force => true do |t|
    t.string   "host"
    t.string   "path"
    t.string   "query_str"
    t.datetime "when"
    t.integer  "status_code"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "deputados", :force => true do |t|
    t.string   "nome"
    t.string   "uf"
    t.string   "partido"
    t.string   "email"
    t.string   "telefone"
    t.string   "condicao"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "id_camara"
    t.string   "matricula"
  end

  create_table "presenca_sessaos", :force => true do |t|
    t.integer  "deputado_id"
    t.integer  "presenca"
    t.integer  "ausencia"
    t.date     "inicio"
    t.date     "fim"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "proposicao_relevancia", :force => true do |t|
    t.integer  "voto"
    t.integer  "user_id"
    t.integer  "proposicao_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "proposicaos", :force => true do |t|
    t.string   "tipo"
    t.integer  "numero"
    t.integer  "ano"
    t.string   "autor_nome"
    t.string   "autor_partido"
    t.string   "autor_uf"
    t.integer  "qtd_autores"
    t.datetime "data_apresentacao"
    t.text     "ementa"
    t.text     "ementa_explicacao"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "fetch_status",      :default => 0
  end

  create_table "subscriptions", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "subscribed_at"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.datetime "unsubscribed_at"
  end

  create_table "twitters", :force => true do |t|
    t.integer  "deputado_id"
    t.string   "address"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "votacaos", :force => true do |t|
    t.string   "resumo"
    t.datetime "data_hora"
    t.string   "obj_votacao"
    t.boolean  "master",        :default => false
    t.integer  "proposicao_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "fetch_status",  :default => 0
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

  create_table "voto_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "votacao_id"
    t.integer  "voto"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
