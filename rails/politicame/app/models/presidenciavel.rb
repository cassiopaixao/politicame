# Copyright 2013 de PoliticaMe/Cassio Paixao e Max Rosan.
# Este arquivo e parte do programa PoliticaMe.
# O PoliticaMe e um software livre; voce pode redistribui-lo e/ou modifica-lo
# dentro dos termos da GNU General Public License.
# como publicada pela Fundacao do Software Livre (FSF); na versao 3 da Licenca.
# Este programa e distribuido na esperanca que possa ser util,
# mas SEM NENHUMA GARANTIA; sem uma garantia implicita de ADEQUACAO a qualquer MERCADO ou APLICACAO EM PARTICULAR.
# Veja a licenca para maiores detalhes.
# Voce deve ter recebido uma copia da GNU General Public License,
# sob o titulo "LICENCA.txt", junto com este programa, se nao, acesse http://www.gnu.org/licenses/

class Presidenciavel
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :slug, :name, :partido, :numero

  def persisted?
    true
  end

  def id
    slug
  end

  def self.build(parameterized_name)
    p = Presidenciavel.new
    case parameterized_name
    when 'aecio-neves'
      p.slug = 'aecio-neves'
      p.name = 'Aécio Neves'
      p.partido = 'PSDB'
      p.numero = 45
    when 'dilma'
      p.slug = 'dilma'
      p.name = 'Dilma Rousseff'
      p.partido = 'PT'
      p.numero = 13
    when 'eduardo-jorge'
      p.slug = 'eduardo-jorge'
      p.name = 'Eduardo Jorge'
      p.partido = 'PV'
      p.numero = 43
    when 'eymael'
      p.slug = 'eymael'
      p.name = 'Eymael'
      p.partido = 'PSDC'
      p.numero = 27
    when 'levy-fidelix'
      p.slug = 'levy-fidelix'
      p.name = 'Levy Fidelix'
      p.partido = 'PRTB'
      p.numero = 28
    when 'luciana-genro'
      p.slug = 'luciana-genro'
      p.name = 'Luciana Genro'
      p.partido = 'PSOL'
      p.numero = 50
    when 'marina-silva'
      p.slug = 'marina-silva'
      p.name = 'Marina Silva'
      p.partido = 'PSB'
      p.numero = 40
    when 'mauro-iasi'
      p.slug = 'mauro-iasi'
      p.name = 'Mauro Iasi'
      p.partido = 'PCB'
      p.numero = 21
    when 'pastor-everaldo'
      p.slug = 'pastor-everaldo'
      p.name = 'Pastor Everaldo'
      p.partido = 'PSC'
      p.numero = 20
    when 'rui-costa-pimenta'
      p.slug = 'rui-costa-pimenta'
      p.name = 'Rui Costa Pimenta'
      p.partido = 'PCO'
      p.numero = 29
    when 'ze-maria'
      p.slug = 'ze-maria'
      p.name = 'Zé Maria'
      p.partido = 'PSTU'
      p.numero = 16
    end
    p
  end

  def self.build_all
    [
      self.build('aecio-neves'),
      self.build('dilma'),
      # self.build('eduardo-jorge'),
      # self.build('eymael'),
      # self.build('levy-fidelix'),
      # self.build('luciana-genro'),
      self.build('marina-silva'),
      # self.build('mauro-iasi'),
      # self.build('pastor-everaldo'),
      # self.build('rui-costa-pimenta'),
      # self.build('ze-maria')
    ]
  end
end
