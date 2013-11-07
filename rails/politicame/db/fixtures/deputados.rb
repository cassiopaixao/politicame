
deputados = Deputado.all
i = 0
next_percentage = 0.00

deputados.each do |d|
  if i.to_f / deputados.size >= next_percentage
    puts('migrating deputados: %.2f%%' % [next_percentage * 100])
    next_percentage += 0.1
  end

  VotoDeputado.where(:nome => d.nome.upcase, :uf => d.uf).each do |voto|
    voto.deputado_id = d.id
    voto.save
  end
  i += 1
end

puts('migrating deputados: 100%%') if deputados.size > 0
