class PopulateUTiposFuncoes < ActiveRecord::Migration[8.1]
  def up
    say_with_time("Populando u_tipos_funcoes") do
      Rake::Task["u_tipos_funcoes:populate"].invoke
    end
  end

  def down
  end
end
