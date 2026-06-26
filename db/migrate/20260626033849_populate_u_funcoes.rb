class PopulateUFuncoes < ActiveRecord::Migration[8.1]
  def up
    say_with_time("Populando u_funcoes") do
      Rake::Task["u_funcoes:populate"].invoke
    end
  end

  def down
  end
end
