class PopulateGInstrumentosNaipes < ActiveRecord::Migration[8.1]
  def up
    say_with_time("Vinculando instrumentos aos naipes") do
      Rake::Task["g_instrumentos_naipes:populate"].invoke
    end
  end

  def down
  end
end
