class PopulateUPerfisFuncoes < ActiveRecord::Migration[8.1]
  def up
    say_with_time("Vinculando perfis a funções") do
      Rake::Task["u_perfis_funcoes:populate"].invoke
    end
  end

  def down
  end
end
